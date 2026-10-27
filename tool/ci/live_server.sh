#!/usr/bin/env bash
# A real REST Mail server for the API client's live tests
# (packages/restmail_api/test/live), in two containers: Postgres and the API.
#
#   tool/ci/live_server.sh up     start it, and write the tests' settings
#   tool/ci/live_server.sh down   remove it
#
# The default server is the immutable image in the generated-client contract
# lock (public, amd64 and arm64), or IMAGE= another for an explicit comparison.
# It starts as a fresh install does: one
# admin, admin@live.test, with a bootstrap password and nothing else. The
# tests do the rest themselves through the client, as the app would: a
# password of their own, an authenticator, then the admin API.
#
# `up` writes the settings to $LIVE_ENV (default .dart_tool/live_server.env)
# as KEY=value lines, and to $GITHUB_ENV when CI sets it:
#
#   RESTMAIL_LIVE_SERVER    http://127.0.0.1:$PORT
#   RESTMAIL_LIVE_EMAIL     the bootstrap admin's address
#   RESTMAIL_LIVE_PASSWORD  its bootstrap password
#
# Then, from packages/restmail_api:
#
#   set -a; . ../../.dart_tool/live_server.env; set +a
#   dart test test/live
#
# Needs Docker, curl and openssl.
set -euo pipefail

CONTRACT_LOCK="$(cd "$(dirname "${BASH_SOURCE[0]}")/../rest_api" && pwd)/contract.lock.json"
read -r contract_image contract_revision < <(python3 - "$CONTRACT_LOCK" <<'PYLOCK'
import json, re, sys
with open(sys.argv[1]) as source:
    server = json.load(source)["server"]
image, revision = server["image"], server["revision"]
if not re.fullmatch(r"ghcr\.io/rest-mail/api@sha256:[0-9a-f]{64}", image) or not re.fullmatch(r"[0-9a-f]{40}", revision):
    sys.exit("the live fixture needs an immutable image and exact contract revision")
print(image, revision)
PYLOCK
)
IMAGE=${IMAGE:-$contract_image}
PORT=${PORT:-58180}
NAME=${NAME:-rm-live}
LIVE_ENV=${LIVE_ENV:-.dart_tool/live_server.env}
ADMIN=admin@live.test

down() {
  docker rm -f "$NAME-api" "$NAME-pg" >/dev/null 2>&1 || true
  docker network rm "$NAME" >/dev/null 2>&1 || true
}

up() {
  down
  docker network create "$NAME" >/dev/null
  docker run -d --name "$NAME-pg" --network "$NAME" \
    -e POSTGRES_USER=restmail -e POSTGRES_PASSWORD=restmail -e POSTGRES_DB=restmail \
    postgres:16-alpine >/dev/null
  for _ in $(seq 60); do
    docker exec "$NAME-pg" pg_isready -U restmail >/dev/null 2>&1 && break
    sleep 1
  done

  local password
  password=$(openssl rand -hex 18)
  docker pull -q "$IMAGE" >/dev/null
  if [[ "$IMAGE" == "$contract_image" ]]; then
    local actual_revision
    actual_revision=$(docker image inspect "$IMAGE" --format '{{ index .Config.Labels "org.opencontainers.image.revision" }}')
    if [[ "$actual_revision" != "$contract_revision" ]]; then
      echo "the live image revision disagrees with the generated-client contract lock" >&2
      exit 1
    fi
  fi
  docker run -d --name "$NAME-api" --network "$NAME" -p "127.0.0.1:$PORT:8080" \
    -e DB_HOST="$NAME-pg" -e DB_NAME=restmail -e DB_USER=restmail -e DB_PASS=restmail \
    -e DB_SSLMODE=disable \
    -e JWT_SECRET="$(openssl rand -hex 32)" -e MASTER_KEY="$(openssl rand -hex 32)" \
    -e RESTMAIL_BOOTSTRAP_ADMIN_ADDRESS="$ADMIN" \
    -e RESTMAIL_BOOTSTRAP_ADMIN_PASSWORD="$password" \
    "$IMAGE" >/dev/null

  local healthy=
  for _ in $(seq 90); do
    if curl -fsS "http://127.0.0.1:$PORT/api/health" >/dev/null 2>&1; then
      healthy=1
      break
    fi
    sleep 1
  done
  if [[ -z $healthy ]]; then
    docker logs "$NAME-api" 2>&1 | tail -40 >&2
    echo "the API did not come up on 127.0.0.1:$PORT" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$LIVE_ENV")"
  {
    echo "RESTMAIL_LIVE_SERVER=http://127.0.0.1:$PORT"
    echo "RESTMAIL_LIVE_EMAIL=$ADMIN"
    echo "RESTMAIL_LIVE_PASSWORD=$password"
  } >"$LIVE_ENV"
  if [[ -n ${GITHUB_ENV:-} ]]; then cat "$LIVE_ENV" >>"$GITHUB_ENV"; fi
  echo "live server up: $IMAGE on http://127.0.0.1:$PORT, settings in $LIVE_ENV"
}

case ${1:-} in
  up) up ;;
  down) down ;;
  *)
    echo "usage: $0 up|down" >&2
    exit 2
    ;;
esac
