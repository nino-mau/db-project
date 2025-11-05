#!/bin/bash

docker compose exec -T postgres pg_dump -U postgres postgres >~/Documents/dev/handigital/db-project/backups/dumps/db_dump_$(date +'%Y-%m-%d_%H:%M:%S').sql
