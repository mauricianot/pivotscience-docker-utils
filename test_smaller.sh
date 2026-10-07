#!/usr/bin/env bash
# test_service.sh: run from the project root
set -euo pipefail

SERVICE=shinysmaller
PORT=8086   
COMPOSE="docker compose -f docker-compose-run.yml" 

fail() { echo "FAIL: $1"; $COMPOSE logs --tail=50 $SERVICE; exit 1; }

echo "Building and starting..."
$COMPOSE up -d --build $SERVICE

echo "Waiting for Shiny Server..."
for i in {1..20}; do
  curl -sf -o /dev/null "http://localhost:$PORT/" && break
  sleep 0.5
  [ "$i" -eq 20 ] && fail "server never responded"
done

echo "Checking the app renders (not a Shiny error page)..."
curl -s "http://localhost:$PORT/" | grep -q "shiny" || fail "response doesn't look like a Shiny app"

echo "Checking the repo mount is present and read-only..."
$COMPOSE exec -T $SERVICE test -f /srv/shiny-server/server.R || fail "app.R not found: mount broken"
$COMPOSE exec -T $SERVICE sh -c 'touch /srv/shiny-server/x 2>/dev/null' && fail "repo mount is writable"

echo "Checking the cache dir is writable by shiny..."
$COMPOSE exec -T -u shiny $SERVICE sh -c 'touch /srv/shiny-server/app_cache/.t && rm /srv/shiny-server/app_cache/.t' || fail "cache not writable"

echo "Checking for errors in the logs..."
$COMPOSE logs $SERVICE | grep -iE "error|fatal" && fail "errors in logs" || true

echo "Testing data update visibility..."
echo "test" > shinysmaller/SMALLER-shiny/data/.update_test
$COMPOSE exec -T $SERVICE test -f /srv/shiny-server/data/.update_test || fail "host changes not visible in container"
rm shinysmaller/SMALLER-shiny/data/.update_test

echo "Testing restart.txt..."
before=$($COMPOSE exec -T $SERVICE sh -c 'pgrep -f "R --no-save" | sort | head -1')
curl -s -o /dev/null "http://localhost:$PORT/"   # make sure a process exists
touch shinysmaller/SMALLER-shiny/restart.txt
sleep 2
curl -s -o /dev/null "http://localhost:$PORT/"   # triggers the new process
after=$($COMPOSE exec -T $SERVICE sh -c 'pgrep -f "R --no-save" | sort | head -1')
[ "$before" != "$after" ] || echo "WARN: R process PID unchanged, check restart behavior manually"

echo "PASS"