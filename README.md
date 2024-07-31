MongoDB Backup and Restore Project
This project provides a comprehensive solution for managing MongoDB backups. It includes scripts and configurations for:

MongoDB Backup to S3: Automates the backup of MongoDB databases to an AWS S3 bucket, including compression and scheduling via cron jobs.
Backup Restoration from S3 to MongoDB: Restores MongoDB backups directly from S3 to a MongoDB instance, with automated handling of backups and restores.
EBS Integration: Includes configuration for integrating EBS (Elastic Block Store) for backup storage.

Features:
Automated backups with cron job scheduling
Secure and efficient storage of backups in AWS S3
Direct restoration of backups from S3 to MongoDB
EBS configuration for additional backup storage options
