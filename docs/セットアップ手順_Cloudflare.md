# TOアド管理ツール - Cloudflare Workers 移行手順

GAS を廃止し、Cloudflare Workers をバックエンドとして使う手順です。

---

## 1. Cloudflare アカウント作成

1. https://dash.cloudflare.com/sign-up にアクセス
2. メールアドレスとパスワードで無料アカウントを作成

---

## 2. Node.js のインストール（未導入の場合）

https://nodejs.org/ から LTS 版をインストール

---

## 3. Wrangler（Cloudflare CLI）のセットアップ

```bash
# プロジェクトの backend フォルダに移動
cd backend

# 依存関係をインストール
npm install

# Cloudflare にログイン（ブラウザが開きます）
npx wrangler login
```

---

## 4. KV ストレージの作成

```bash
npx wrangler kv:namespace create TASK_STORE
```

実行すると以下のような出力が表示されます:

```
{ binding = "TASK_STORE", id = "abcdef1234567890abcdef1234567890" }
```

**この `id` の値を `wrangler.toml` に書き込んでください:**

```toml
[[kv_namespaces]]
binding = "TASK_STORE"
id = "abcdef1234567890abcdef1234567890"  ← ここを差し替え
```

---

## 5. シークレット（環境変数）の設定

GAS のスクリプトプロパティに設定していた値を、Cloudflare Workers のシークレットとして設定します。

```bash
# 各コマンドを実行すると値の入力を求められます
npx wrangler secret put CHATWORK_API_TOKEN
npx wrangler secret put CHATWORK_ROOM_ID
npx wrangler secret put ALL_USER_IDS
npx wrangler secret put ASSIGN_MAP_JSON
npx wrangler secret put GOOGLE_CLIENT_ID
```

> **GOOGLE_CLIENT_ID** は次のステップ 6 で取得します。先にステップ 6 を完了してからこの値を設定してください。

---

## 6. Google OAuth クライアント ID の作成

1. https://console.cloud.google.com/ にアクセス
2. 左上のプロジェクト選択 → **新しいプロジェクト** を作成（名前: `adkanri-tool` など）
3. 左メニュー → **APIとサービス** → **OAuth 同意画面**
   - ユーザータイプ: **内部**（Google Workspace ユーザーのみ）
   - アプリ名: `TOアド管理ツール`
   - サポートメール: 自分のメールアドレス
   - **保存して次へ** → スコープはそのまま → **保存**
4. 左メニュー → **認証情報** → **認証情報を作成** → **OAuth クライアント ID**
   - アプリケーションの種類: **ウェブ アプリケーション**
   - 名前: `TOアド管理ツール`
   - **承認済みの JavaScript 生成元** に以下を追加:
     - `https://axis-ad.github.io`
   - **作成** をクリック
5. 表示される **クライアント ID** をコピー（`xxxx.apps.googleusercontent.com` の形式）

---

## 7. Worker のデプロイ

```bash
cd backend
npx wrangler deploy
```

デプロイ後、Worker の URL が表示されます:

```
https://adkanri-api.YOUR_SUBDOMAIN.workers.dev
```

この URL をメモしてください。

---

## 8. フロントエンドの設定

`docs/config.js` を編集して、2つの値を設定:

```javascript
var API_URL = 'https://adkanri-api.YOUR_SUBDOMAIN.workers.dev';
var GOOGLE_CLIENT_ID = 'xxxx.apps.googleusercontent.com';
```

---

## 9. GitHub にプッシュ

```bash
git add -A
git commit -m "Cloudflare Workers 移行: GAS廃止"
git push
```

GitHub Pages が自動で反映されます。

---

## 10. 動作確認

https://axis-ad.github.io/adkanri-task/ にアクセスして:

1. Google ログイン画面が表示される
2. AXIS/shibuya-ad.com/axis-company.jp のアカウントでログインできる
3. フォームから依頼を送信できる
4. チャットワークにタスクが作成される

---

## 移行後の変更点

| 項目 | 旧（GAS） | 新（Cloudflare Workers） |
|------|-----------|------------------------|
| フロントエンド変更 | GAS に HTML 貼り付け + デプロイ | `git push` のみ |
| バックエンド変更 | GAS エディタで編集 + デプロイ | `npx wrangler deploy` |
| ユーザー認証 | GAS の Session（自動） | Google Sign-In（ワンクリック） |
| データ保管 | PropertiesService | Cloudflare KV |
| Chatwork 連携 | GAS の UrlFetchApp | Cloudflare Workers の fetch |

**GAS は完全に不要になります。**
