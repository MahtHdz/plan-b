#!/bin/bash

# Load environment variables
source env.sh

# Ensure environment variables are set
if [ -z "$BACKUP_DIR" ]; then
    echo "BACKUP_DIR environment variable is not set"
    exit 1
fi

# Variables
TMP_DIR="/tmp"
BANNER_PATH="banner"
TODAY=$(date +"%Y-%m-%d")
INCREMENTAL_DIR="$BACKUP_DIR/incremental"
DIFFERENTIAL_DIR="$BACKUP_DIR/differential"
FULL_DIR="$BACKUP_DIR/full"
OS_RECOVERY_DIR="$BACKUP_DIR/os_recovery"
ROLLBACK_DIR="$BACKUP_DIR/rollback"
LOG_FILE="$TMP_DIR/backup.log"

# Important directories to backup
DIRECTORIES_TO_BACKUP="/etc /home /opt /root /usr/local /var/lib /var/www"

# OS recovery directories
OS_DIRECTORIES_TO_BACKUP="/boot /boot/efi /bin /sbin /etc /lib /lib64 /usr /var"

# Ensure backup directories exist
mkdir -p $INCREMENTAL_DIR $DIFFERENTIAL_DIR $FULL_DIR $OS_RECOVERY_DIR $ROLLBACK_DIR

# Logging function
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Backup function
perform_backup() {
    local backup_type=$1
    local tar_options=$2
    local backup_dir=$3
    local snapshot_file=$4
    local filename="${backup_type}-${TODAY}.tar.gz"
    local filepath="${TMP_DIR}/${filename}"

    cat $BANNER_PATH > $LOG_FILE
    log "Starting ${backup_type} backup"

    tar $tar_options -cvzf $filepath $DIRECTORIES_TO_BACKUP $snapshot_file >> $LOG_FILE 2>&1
    if [ $? -eq 0 ]; then
        rclone copy $filepath onedrive:$backup_dir -P --stats 1s
        rm $filepath
        log "${backup_type} backup completed"
    else
        log "Error during ${backup_type} backup"
    fi
}

# Perform full backup
full_backup() {
    perform_backup "full" "-cvzf" $FULL_DIR ""
}

# Perform incremental backup
incremental_backup() {
    perform_backup "incremental" "--listed-incremental=$INCREMENTAL_DIR/snapshot.file -cvzf" $INCREMENTAL_DIR ""
}

# Perform differential backup
differential_backup() {
    perform_backup "differential" "--listed-incremental=$DIFFERENTIAL_DIR/snapshot.file -cvzf" $DIFFERENTIAL_DIR ""
}

# Perform OS recovery backup
os_recovery_backup() {
    perform_backup "os_recovery" "-cvzf" $OS_RECOVERY_DIR ""
}

# Perform rollback backup (before major changes)
rollback_backup() {
    perform_backup "rollback" "-cvzf" $ROLLBACK_DIR ""
}

# Restore from backup
restore_backup() {
    local backup_file=$2
    if [ -z "$backup_file" ]; then
        echo "Usage: $0 restore <backup_file>"
        exit 1
    fi
    log "Starting restoration from $backup_file"
    tar -xzf $backup_file -C /
    if [ $? -eq 0 ]; then
        log "Restoration completed from $backup_file"
    else
        log "Error during restoration from $backup_file"
    fi
}

# Main
main() {
    case "$1" in
        full)
            full_backup
            ;;
        incremental)
            incremental_backup
            ;;
        differential)
            differential_backup
            ;;
        os_recovery)
            os_recovery_backup
            ;;
        rollback)
            rollback_backup
            ;;
        restore)
            restore_backup $@
            ;;
        *)
            echo "Usage: $0 {full|incremental|differential|os_recovery|rollback|restore <backup_file>}"
            exit 1
            ;;
    esac

    log "Backup script completed"
    rclone copy $LOG_FILE onedrive:$BACKUP_DIR/logs -P --stats 1s
    rm $LOG_FILE
}

main $@
