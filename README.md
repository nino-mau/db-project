# Database Project

## Getting Started

Start the database:

```bash
docker compose up
```

## Database Backup

To backup the database, run:

```bash
docker compose exec -T postgres pg_dump -U postgres postgres > ./backups/dumps/db_dump_$(date -d "%Y%m%d%H%M").sql
```

This will create a SQL dump file in the `./backups/` directory with the name `db_dump.sql`.
