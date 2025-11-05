# Database Project

## Getting Started

Start the database:

```bash
docker compose up
```

## Database Backup

To backup the database, run:

```bash
docker compose exec -T postgres pg_dump -U postgres postgres > ./backups/db_dump.sql
```

This will create a SQL dump file in the `./backups/` directory with the name `db_dump.sql`.
