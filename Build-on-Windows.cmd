@echo off
setlocal
cd /d "%~dp0"
echo Lyrics for CarPlay - Windows cloud build
echo This creates a PUBLIC GitHub repository containing this project's source.
echo Your Spotify Client ID is public app metadata. No Client Secret is used.
echo.
where git >nul 2>&1
if errorlevel 1 goto missinggit
where gh >nul 2>&1
if errorlevel 1 goto missinggh
gh auth status >nul 2>&1
if errorlevel 1 (
  gh auth login --hostname github.com --git-protocol https --web --scopes repo,workflow
  if errorlevel 1 goto failed
)
gh auth setup-git
if errorlevel 1 goto failed
for /f "delims=" %%U in ('gh api user --jq .login') do set "LYRICS_GITHUB_USER=%%U"
if not defined LYRICS_GITHUB_USER goto failed
set "LYRICS_REPO=%LYRICS_GITHUB_USER%/lyrics-carplay-personal"
gh repo view "%LYRICS_REPO%" >nul 2>&1
if not errorlevel 1 goto existing
if exist .git goto existinglocal
git init -b main
if errorlevel 1 goto failed
git add .
if errorlevel 1 goto failed
git -c "user.name=%LYRICS_GITHUB_USER%" -c "user.email=%LYRICS_GITHUB_USER%@users.noreply.github.com" commit -m "Set up personal Lyrics for CarPlay cloud build"
if errorlevel 1 goto failed
gh repo create "%LYRICS_REPO%" --public --description "Personal Spotify lyrics Live Activity for iOS and CarPlay; based on darsy29/lyrics-carplay" --source . --remote origin --push
if errorlevel 1 goto failed
echo Waiting briefly for GitHub to register the workflow...
timeout /t 8 /nobreak >nul
gh workflow run build-ios.yml --repo "%LYRICS_REPO%" --ref main
if errorlevel 1 goto failed
timeout /t 5 /nobreak >nul
for /f "delims=" %%R in ('gh run list --repo "%LYRICS_REPO%" --workflow build-ios.yml --limit 1 --json databaseId --jq ".[0].databaseId"') do set "LYRICS_RUN_ID=%%R"
if not defined LYRICS_RUN_ID goto failed
gh run watch "%LYRICS_RUN_ID%" --repo "%LYRICS_REPO%" --exit-status
if errorlevel 1 goto failed
gh run download "%LYRICS_RUN_ID%" --repo "%LYRICS_REPO%" --name LyricsCarPlay-unsigned-IPA --dir downloads
if errorlevel 1 goto failed
echo.
echo Success: downloads\LyricsCarPlay-unsigned.ipa is ready for Sideloadly.
echo Keep app extensions enabled when signing/installing.
pause
exit /b 0
:missinggit
echo Install Git for Windows from https://git-scm.com/download/win then run again.
pause
exit /b 1
:missinggh
echo Install GitHub CLI from https://cli.github.com then run again.
pause
exit /b 1
:existing
echo Repository already exists. No files were changed in it.
echo Open its Actions tab to run Build iPhone IPA, or ask for help updating it.
gh repo view "%LYRICS_REPO%" --web
pause
exit /b 1
:existinglocal
echo This folder already contains Git history. Use a freshly extracted copy.
echo No repository files were overwritten.
pause
exit /b 1
:failed
echo.
echo Setup stopped at the error above. Existing files and repositories are preserved.
echo If a repository was created, inspect its Actions tab before retrying.
echo Send the error text for help. Do not include passwords or login codes.
pause
exit /b 1
