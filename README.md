# Backup Script

This is a shell script for performing various types of backups on a Linux system. It supports full, incremental, differential, OS recovery, and rollback backups. The backups are stored using `rclone` to multiple remote storage providers.

## Prerequisites

- `rclone` should be installed and configured with the required remotes.
- Environment variables should be set in the `env.sh` file.

## Environment Variables

The following environment variables should be defined in `env.sh`:

- `BACKUP_DIR`: The base directory for storing backups.
- `REMOTE_NAME`: A space-separated list of remote names for storing backups. Example: `onedrive dropbox google-drive`.

## Supported Storage Providers for `rclone`

1. 1Fichier (fichier)
2. Akamai NetStorage (netstorage)
3. Alias for an existing remote (alias)
4. Amazon Drive (amazon cloud drive)
5. Amazon S3 Compliant Storage Providers including AWS, Alibaba, ArvanCloud, Ceph, China Mobile, Cloudflare, GCS, DigitalOcean, Dreamhost, Huawei OBS, IBM COS, IDrive e2, IONOS Cloud, Leviia, Liara, Lyve Cloud, Minio, Netease, Petabox, RackCorp, Scaleway, SeaweedFS, StackPath, Storj, Synology, Tencent COS, Qiniu, and Wasabi (s3)
6. Backblaze B2 (b2)
7. Better checksums for other remotes (hasher)
8. Box (box)
9. Cache a remote (cache)
10. Citrix Sharefile (sharefile)
11. Combine several remotes into one (combine)
12. Compress a remote (compress)
13. Dropbox (dropbox)
14. Encrypt/Decrypt a remote (crypt)
15. Enterprise File Fabric (filefabric)
16. FTP (ftp)
17. Google Cloud Storage (this is not Google Drive) (google cloud storage)
18. Google Drive (drive)
19. Google Photos (google photos)
20. HTTP (http)
21. Hadoop distributed file system (hdfs)
22. HiDrive (hidrive)
23. In-memory object storage system (memory)
24. Internet Archive (internetarchive)
25. Jottacloud (jottacloud)
26. Koofr, Digi Storage, and other Koofr-compatible storage providers (koofr)
27. Local Disk (local)
28. Mail.ru Cloud (mailru)
29. Mega (mega)
30. Microsoft Azure Blob Storage (azureblob)
31. Microsoft OneDrive (onedrive)
32. OpenDrive (opendrive)
33. OpenStack Swift (Rackspace Cloud Files, Blomp Cloud Storage, Memset Memstore, OVH) (swift)
34. Oracle Cloud Infrastructure Object Storage (oracleobjectstorage)
35. Pcloud (pcloud)
36. PikPak (pikpak)
37. Put.io (putio)
38. QingCloud Object Storage (qingstor)
39. Quatrix by Maytech (quatrix)
40. SMB / CIFS (smb)
41. SSH/SFTP (sftp)
42. Sia Decentralized Cloud (sia)
43. Sugarsync (sugarsync)
44. Transparently chunk/split large files (chunker)
45. Union merges the contents of several upstream fs (union)
46. Uptobox (uptobox)
47. WebDAV (webdav)
48. Yandex Disk (yandex)
49. Zoho (zoho)
50. premiumize.me (premiumizeme)
51. seafile (seafile)

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

Each backup operation logs its activities to a log file located in the `/tmp` directory. The log file is then copied to the `logs` directory in the backup location on all configured remote storage providers.

### Example

To perform a full backup:

```bash
./backup.sh full
```

To restore from a backup file:

```bash
./backup.sh restore /path/to/backup_file.tar.gz
```

## Notes

Ensure that the `BACKUP_DIR` and `REMOTE_NAME` environment variables are set in `env.sh`. The script checks for the existence of the `BACKUP_DIR` variable before performing any backup operations.

## License

This script is open-source and available under the MIT License.
