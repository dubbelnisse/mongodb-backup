# mongodb-backup
This image runs mongodump to backup data using cronjob to folder `/backup`

## Usage:

  docker run --name mongodb-backup --link=mongodb:mongodb dubbelnisse/mongodb-backup

## Parameters

    MONGODB_HOST    the host/ip of your mongodb database (deafult: 127.0.0.1).
    MONGODB_PORT    the port number of your mongodb database (deafult: 27017).
    MONGODB_DB      the database name to dump (deafult: test).
    CRON_TIME       the interval of cron job to run mongodump (deafult: 0 0 * * *).
    MAX_BACKUPS     the number of backups to keep. When reaching the limit, the old backup will be discarded (deafult: 5).
    INIT_BACKUP     create a backup when the container is launched (deafult:true).

## Cron syntax
```
 # ┌──────────── minute
 # │ ┌────────── hour
 # │ │ ┌──────── day of month
 # │ │ │ ┌────── month
 # │ │ │ │ ┌──── day of week
 # │ │ │ │ │
 # │ │ │ │ │
 # * * * * *
```
|     field    |        value        |
|--------------|---------------------|
|    minute    |         0-59        |
|     hour     |         0-23        |
| day of month |         1-31        |
|     month    |     1-12 (or names) |
|  day of week |     0-7 (or names, 0 or 7 are sunday)  |
