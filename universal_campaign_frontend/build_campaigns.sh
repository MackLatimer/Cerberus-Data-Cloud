#!/bin/sh
set -e

CAMPAIGNS="emmons blair cox gauntt mintz tice leudeke tulloch whitson"

for campaign in $CAMPAIGNS
do
  echo "Building campaign: $campaign"
  cp "assets/${campaign}_config.json" "assets/default_config.json"
  flutter build web --release
  npx firebase-tools deploy --only "hosting:${campaign}" --project "cerberus-data-cloud"
done
