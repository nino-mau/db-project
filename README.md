# Database Project

## Getting Started

Start the database:

```bash
docker compose up
```

## Database Backup

To backup the database, run the dump.sh script:

```bash
bash ./scripts/dump.sh
```

This will create a SQL dump file in the `./backups/dumps` directory with timestamped name.
