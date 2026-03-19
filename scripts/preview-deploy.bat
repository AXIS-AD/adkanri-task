@echo off
chcp 65001 >nul
setlocal

REM プレビューデプロイスクリプト（ローカル実行用）
REM 使い方: scripts\preview-deploy.bat
REM 現在のブランチをCloudflare Pagesにプレビューデプロイします

cd /d "%~dp0\..\backend"

REM ブランチ名取得
for /f "tokens=*" %%i in ('git rev-parse --abbrev-ref HEAD') do set BRANCH=%%i
for /f "tokens=*" %%i in ('git rev-parse --short HEAD') do set COMMIT=%%i

if "%BRANCH%"=="master" (
    echo [ERROR] masterブランチではプレビューデプロイできません。
    echo   別のブランチを作成してください: git checkout -b feature/xxx
    exit /b 1
)

echo.
echo ========================================
echo   プレビューデプロイ
echo   ブランチ: %BRANCH%
echo   コミット: %COMMIT%
echo ========================================
echo.

REM フロントエンドをCloudflare Pagesにデプロイ（本番APIを使用）
echo [1/2] フロントエンドをデプロイ中...
cd /d "%~dp0\.."
npx wrangler pages deploy docs/ --project-name=adkanri-task --branch="%BRANCH%" --commit-hash="%COMMIT%"

if %errorlevel% neq 0 (
    echo [ERROR] フロントエンドのデプロイに失敗しました
    exit /b 1
)

echo.
echo ========================================
echo   デプロイ完了！
echo.
echo   プレビューURL:
echo   https://%BRANCH%.adkanri-task.pages.dev/
echo.
echo   ※ ブランチ名にスラッシュが含まれる場合、
echo     URLのスラッシュはハイフンに置換されます
echo ========================================

endlocal
