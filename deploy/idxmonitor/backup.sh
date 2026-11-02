#!/bin/sh
# Backup diário do Securo (banco + anexos), 14 dias de retenção.
# Studio Ágil - Adriano Gelain · www.studioagil.com.br
# cron do usuário deploy: 30 3 * * * $HOME/securo/deploy/idxmonitor/backup.sh
set -eu
DIR="$HOME/securo-backups"
DATA=$(date +%Y%m%d-%H%M)
mkdir -p "$DIR"
chmod 700 "$DIR"
cd "$HOME/securo"
docker compose exec -T db pg_dump -U postgres -Fc securo > "$DIR/securo-$DATA.dump"
docker run --rm -v securo_attachments:/a:ro alpine tar czf - -C /a . > "$DIR/anexos-$DATA.tar.gz"
find "$DIR" -type f -mtime +14 -delete
