# Backup Script

This is a shell script for performing various types of backups on a Linux system. It supports full, incremental, differential, OS recovery, and rollback backups. The backups are stored using `rclone` to a OneDrive remote.

## Prerequisites

- `rclone` should be installed and configured with a remote named `onedrive`.
- Environment variables should be set in `env.sh` file.

## Environment Variables

The following environment variables should be defined in `env.sh`:

- `BACKUP_DIR`: The base directory for storing backups.

## Usage

To run the script, use the following command format:

```bash
./backup.sh {full|incremental|differential|os_recovery|rollback|restore <backup_file>}
```

### Full Backup: Backs up all important directories

```bash
./backup.sh full
```

### Incremental Backup: Backs up changes since the last incremental or full backup

```bash
./backup.sh incremental
```

### Differential Backup: Backs up changes since the last full backup

```bash
./backup.sh differential
```

### OS Recovery Backup: Backs up the OS-specific directories for system recovery

```bash
./backup.sh os_recovery
```

### Rollback Backup: Backs up important directories and OS-specific directories before major changes

```bash
./backup.sh rollback
```

## Restore from Backup: Restores from a specified backup file

```bash
    ./backup.sh restore <backup_file>
```

## Script Details

### Important Directories to Backup

- /etc
- /home
- /opt
- /root
- /usr/local
- /var/lib
- /var/www

### OS Recovery Directories

- /boot
- /boot/efi
- /bin
- /sbin
- /etc
- /lib
- /lib64
- /usr
- /var

## Logging

Each backup operation logs its activities to a log file located in /tmp directory. The log file is then copied to the logs directory in the backup location on OneDrive.
Example

To perform a full backup:

```bash
./backup.sh full
```

To restore from a backup file:

```bash
./backup.sh restore /path/to/backup_file.tar.gz
```

## Notes

Ensure that the BACKUP_DIR environment variable is set in env.sh.
The script checks for the existence of the BACKUP_DIR variable before performing any backup operations.

## License

This script is open-source and available under the MIT License.
