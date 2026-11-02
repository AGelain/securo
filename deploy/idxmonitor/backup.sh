#!/bin/sh
# Backup diário do Securo (banco + anexos): uma cópia por dia da semana,
# cada uma sobrescrita na semana seguinte, sempre 7 cópias no máximo.
# Studio Ágil - Adriano Gelain · www.studioagil.com.br
# cron do usuário deploy: 30 3 * * * $HOME/securo/deploy/idxmonitor/backup.sh
set -eu
DIR="$HOME/securo-backups"
DIA=$(LC_ALL=C date +%u-%a)
mkdir -p "$DIR"
chmod 700 "$DIR"
cd "$HOME/securo"
# Grava em .tmp e só troca no fim: se falhar no meio, a cópia anterior fica intacta.
docker compose exec -T db pg_dump -U postgres -Fc securo > "$DIR/securo-$DIA.dump.tmp"
docker run --rm -v securo_attachments:/a:ro alpine tar czf - -C /a . > "$DIR/anexos-$DIA.tar.gz.tmp"
mv "$DIR/securo-$DIA.dump.tmp" "$DIR/securo-$DIA.dump"
mv "$DIR/anexos-$DIA.tar.gz.tmp" "$DIR/anexos-$DIA.tar.gz"
echo "$(date '+%F %T') ok securo-$DIA"
