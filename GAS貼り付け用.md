# GAS 貼り付け用

このフォルダ内のファイルを GAS プロジェクトにコピーします。

---

## ① Code.gs

1. **貼り付け先**: [script.google.com](https://script.google.com/) でプロジェクト作成 → 左の `Code.gs`
2. **コピー元**: このフォルダの `Code.gs` を開く
3. 全選択（Ctrl+A）→ コピー（Ctrl+C）
4. GAS の Code.gs の内容を全削除してから貼り付け

---

## ② index.html

1. **貼り付け先**: GAS 左の「+」→「HTML」→ ファイル名を `index` に
2. **コピー元**: このフォルダの `index.html` を開く
3. 全選択（Ctrl+A）→ コピー（Ctrl+C）
4. GAS の index の内容を全削除してから貼り付け

---

## ③ 設定値の置き換え

貼り付け後、`Code.gs` の以下の行を編集：

| 行 | 置き換え |
|----|----------|
| 7 | `YOUR_CHATWORK_API_TOKEN` → APIトークン |
| 8 | `YOUR_CHATWORK_ROOM_ID` → ルームID |
| 14-22 | `USER_ID_1` / `USER_ID_2` → 担当者のユーザーID |
| 25 | `YOUR_USER_IDS_COMMA_SEPARATED` → 営業時間外の通知先 |

詳細は `設定値メモ.md` を参照。
