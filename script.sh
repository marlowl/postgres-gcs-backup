set -e
source /google-cloud-sdk/path.bash.inc

#Make sql backup from a Postgres database
touch ~/.pgpass
chmod 0600 ~/.pgpass
echo $POSTGRES_HOST:${POSTGRES_PORT:-5432}:$POSTGRES_DATABASE:$POSTGRES_USER:$POSTGRES_PASSWORD > ~/.pgpass
pg_dump -U $POSTGRES_USER $POSTGRES_DATABASE -h $POSTGRES_HOST -p ${POSTGRES_PORT:-5432} > backup.sql
zstd -${COMPRESSION_LEVEL:-19} backup.sql

#Upload backup to a gcloud cloud bucket
echo $GOOGLE_CLOUD_KEY > /tmp/google_cloud_key.json
gcloud auth activate-service-account --key-file /tmp/google_cloud_key.json
gsutil cp backup.sql.zst gs://$BACKUP_GCS_BUCKET/${BACKUP_PREFIX:-backup}-$(date +%FT%H-%M).sql.zst
