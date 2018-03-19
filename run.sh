#!/bin/bash

MONGODB_HOST=$([[ ! -z $MONGODB_HOST ]] && echo "$MONGODB_HOST" || echo "127.0.0.1")
MONGODB_PORT=$([[ ! -z $MONGODB_PORT ]] && echo "$MONGODB_PORT" || echo "27017")
MONGODB_DB=$([[ ! -z $MONGODB_PORT ]] && echo "$MONGODB_DB" || echo "test")

BACKUP_CMD="mongodump --gzip --archive=/backup/"'${BACKUP_NAME}'" --host ${MONGODB_HOST} --port ${MONGODB_PORT} --db ${MONGODB_DB}"

echo "=> Creating backup script"
rm -f /backup.sh
cat <<EOF >> /backup.sh
#!/bin/bash
MAX_BACKUPS=${MAX_BACKUPS}
BACKUP_NAME=\$(date +\%Y.\%m.\%d.\%H\%M\%S)
echo "=> Backup started"
if ${BACKUP_CMD} ;then
    echo "   Backup succeeded"
else
    echo "   Backup failed"
    rm -rf /backup/\${BACKUP_NAME}
fi
if [ -n "\${MAX_BACKUPS}" ]; then
    while [ \$(ls /backup -N1 | wc -l) -gt \${MAX_BACKUPS} ];
    do
        BACKUP_TO_BE_DELETED=\$(ls /backup -N1 | sort | head -n 1)
        echo "   Deleting backup \${BACKUP_TO_BE_DELETED}"
        rm -rf /backup/\${BACKUP_TO_BE_DELETED}
    done
fi
echo "=> Backup done"
EOF
chmod +x /backup.sh

touch /mongo_backup.log
tail -F /mongo_backup.log &

if [ -n "${INIT_BACKUP}" ]; then
    echo "=> Create a backup on the startup"
    /backup.sh
fi

echo "${CRON_TIME} /backup.sh >> /mongo_backup.log 2>&1" > /crontab.conf
crontab  /crontab.conf
echo "=> Running cron job at interval: \"${CRON_TIME}\""
systemctl restart crond.service