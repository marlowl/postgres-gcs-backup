## How to use

 1. Unlock `script.sh`
 ```bash
chmod +x script.sh
```
 2. Build the Dockerfile 
 ```bash
docker build . -t postgres-gcs-backup
 ```

3. Upload the Dockerfile to a registry of your choice

4. Adjust `cronjob.yaml` 

```yaml
  ...
  - name: postgres-backup
            image: YOUR_DOCKER_IMAGE #here
            env:
            - name: POSTGRES_USER
              value: your_postgres_user
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: database-postgresql
                  key: postgresql-password
            - name: POSTGRES_DATABASE
              value: your_database
            - name: POSTGRES_HOST
              value: database-postgresql 
            - name: POSTGRES_PORT
              value: "5432"
            - name: BACKUP_GCS_BUCKET
              value: YOUR_GCS_BUCKET #here
            - name: GOOGLE_CLOUD_KEY 
              valueFrom:
                secretKeyRef:
                  name: postgres-sa
                  key: key.json
            resources:
              limits:
                memory: 256M
                cpu: "250m"
              requests:
                memory: 100M
                cpu: "10m"
          restartPolicy: OnFailure
          imagePullSecrets:
            - name: pull-secret

```
5. Apply `cronjob.yaml` to make frequent backups
 
