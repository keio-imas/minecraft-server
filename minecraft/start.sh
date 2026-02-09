#!/usr/bin/env bash
set -euo pipefail

cd /srv/minecraft

eula_path="/srv/minecraft/eula.txt"

if ! echo "eula=${EULA}" > "${eula_path}" 2>/dev/null; then
  echo "ERROR: cannot write ${eula_path}. Check volume permissions/ownership."
  ls -la /srv/minecraft || true
  id || true
  exit 1
fi


PROJECT="${PROJECT:-paper}"
MINECRAFT_VERSION="${MINECRAFT_VERSION:-1.21.11}"

USER_AGENT="${PAPER_USER_AGENT:-cool-project/1.0.0 (contact@me.com)}"

AUTO_UPDATE="${AUTO_UPDATE:-true}"

download_latest_stable()
{
  local builds_response papermc_url

  builds_response="$(curl -fsSL -H "User-Agent: ${USER_AGENT}" \
    "https://fill.papermc.io/v3/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds")"

  if echo "${builds_response}" | jq -e '.ok == false' >/dev/null 2>&1; then
    echo "PaperMC API error: $(echo "${builds_response}" | jq -r '.message // "Unknown error"')"
    return 1
  fi

  papermc_url="$(echo "${builds_response}" | jq -r \
    'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url) // "null"')"

  if [ "${papermc_url}" = "null" ]; then
    echo "No STABLE build for Minecraft ${MINECRAFT_VERSION} (${PROJECT})"
    return 1
  fi

  echo "Downloading: ${papermc_url}"
  curl -fsSL -H "User-Agent: ${USER_AGENT}" -o server.jar "${papermc_url}"
}

if [ "${AUTO_UPDATE}" = "true" ]; then
  download_latest_stable
else
  if [ ! -f server.jar ]; then
    echo "server.jar not found and AUTO_UPDATE=false"
    exit 1
  fi
fi

JAVA_OPTS="${JAVA_OPTS:--Xms2G -Xmx8G -XX:+UseG1GC -XX:MaxGCPauseMillis=200}"

exec java ${JAVA_OPTS} -jar server.jar --nogui

