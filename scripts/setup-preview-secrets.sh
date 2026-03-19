#!/bin/bash
# プレビュー Worker にシークレットを設定するスクリプト
# 本番の値と同じものを使用

cd "$(dirname "$0")/../backend"

echo "=== プレビュー Worker のシークレットを設定 ==="
echo "各プロンプトで本番と同じ値を入力してください"
echo ""

SECRETS=(
  CHATWORK_API_TOKEN
  CHATWORK_ROOM_ID
  ALL_USER_IDS
  ASSIGN_MAP_JSON
  GOOGLE_CLIENT_ID
  CHATWORK_ROOM_2
  MY_ACCOUNT_ID
  PERSONS_JSON
  CHATWORK_DONE_TOKEN
  CHATWORK_TOKEN_TSUTSUI
  CHATWORK_TOKEN_NISHIMURA
  CHATWORK_TOKEN_ISHIDA
  CHATWORK_TOKEN_TOMORI
  GOOGLE_SERVICE_ACCOUNT_KEY
)

for secret in "${SECRETS[@]}"; do
  echo "--- $secret ---"
  npx wrangler secret put "$secret" --env preview
  echo ""
done

echo "=== 完了 ==="
