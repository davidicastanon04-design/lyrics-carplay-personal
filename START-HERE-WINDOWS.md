# Lyrics for CarPlay — Windows setup

Prepared from https://github.com/darsy29/lyrics-carplay at commit a6c8e72ea150a542940a831832a806683c80ecdd.

## Current status

This package adds a project generator specification and a manual GitHub Actions build. The app and Live Activity extension are both included. Two ObservableObject source files now explicitly import Combine. Your supplied public Spotify Client ID is preconfigured. No Spotify Client Secret, password, or token is included. The ID can also be edited inside the app before connecting.

YAML, source wiring, and package validation have passed. Compilation, signing, installation, Spotify login, and CarPlay behavior have NOT yet been tested. This is source code plus build automation, not an installable IPA. A macOS runner still has to compile it.

## 1. Spotify app settings

Open https://developer.spotify.com/dashboard and select the app you already made.

- In Settings, add the exact Redirect URI: `lyricscarplay://spotify-callback` and save it. Keep existing redirects if other uses depend on them.
- Use Web API. The source uses PKCE, so only the Client ID is needed; never put your Client Secret in the project or workflow.
- The app owner needs active Spotify Premium. Use that same Spotify account for the first test. If using a different account, add it under User Management; development mode has a five-user cap.

## 2. Recommended: Windows launcher

1. Install Git for Windows from https://git-scm.com/download/win and GitHub CLI from https://cli.github.com if you do not already have them.
2. Extract this ZIP fully into its own folder. Do not run from inside the ZIP.
3. Double-click `Build-on-Windows.cmd`. It will ask you to sign in to GitHub through the official CLI if necessary.
4. The launcher creates a **public** repository named `lyrics-carplay-personal` in the account you sign in to. It pushes the source, starts the hosted Mac build, waits for the result, then downloads the IPA into `downloads`. Standard public-repository runners are free. The public Client ID is included; no Client Secret is used.
5. Once the build succeeds, continue to section 4 below. If the launcher stops, keep its error text. It does not overwrite an existing remote repository. A second run after partial setup may require opening Actions manually.

This launcher has been reviewed as source but has not been executed on Windows or against your GitHub account. Compilation is still unverified. It cannot complete GitHub login or iPhone signing for you while you are away.

## 2b. Manual alternative: put the project in your GitHub account

Either fork the original repository and add the supplied changes, or create a new repository containing this package. Preserve `.github/workflows/build-ios.yml`, `project.yml`, App, Shared, Widget, Config, LICENSE, and README.md.

On Windows, GitHub Desktop can publish the extracted folder as a repository. In Desktop choose File > Add Local Repository, select the extracted project folder, then use the offered create-repository option if necessary. Commit the files, then Publish Repository. Review visibility before publishing. A public repository gets free standard hosted runners; private repositories have included usage limits and may incur charges beyond them. There are no passwords or Client Secrets in this package.

If you use the website's Upload files feature, include the `.github` directory too, and upload the project contents at the repository root, not inside another folder. Merely uploading this ZIP will not enable the workflow.

## 3. Build the IPA in GitHub

1. Open your repository > Actions. Enable Actions if GitHub requests it for a fork.
2. Select **Build iPhone IPA** > **Run workflow**.
3. No workflow input is needed: your public Client ID is already configured in the app.
4. Run the workflow and wait for a green completion. It uses GitHub's `macos-26` runner, Xcode, and Homebrew's XcodeGen.
5. Open the completed run and download the **LyricsCarPlay-unsigned-IPA** artifact. Extract it to get `LyricsCarPlay-unsigned.ipa`.

The IPA has no Apple signing identity yet. It cannot be installed by opening it in the iPhone Files app. If the build fails, share the failed step's error log (remove any unrelated secrets) so it can be fixed.

## 4. Install from Windows with Sideloadly

1. Download Windows Sideloadly from https://sideloadly.io and follow its current Apple driver/iTunes/iCloud prerequisites. Get Apple components only through the links in the official setup instructions.
2. Connect your unlocked iPhone by USB and accept its Trust This Computer prompt.
3. Open Sideloadly, select the iPhone, and select the generated IPA.
4. Use your own Apple Account in Sideloadly. Complete password and verification prompts there, never in chat or GitHub.
5. Keep **Remove App Extensions (PlugIns)** disabled. The embedded LyricsWidget extension is required for the Live Activity. If Sideloadly asks to remove extensions, preserve it.
6. Start signing/installing. After installation, follow iPhone prompts to trust your developer profile in Settings > General > VPN & Device Management. Enable Developer Mode under Settings > Privacy & Security when required, including the requested restart and confirmation. These steps must be done on your own iPhone.

Free Apple Accounts sign apps for seven days. Re-sign with the same account and bundle ID before expiry, or configure Sideloadly auto-refresh with the computer available and USB/Wi-Fi pairing. Free accounts also have app/App ID limits, and this app includes an extension. A paid Apple Developer membership is not necessary for the proposed personal installation route.

## 5. Test before using CarPlay

1. Your iPhone must run iOS 26 or later for this project's CarPlay Live Activity use.
2. Open Lyrics for CarPlay and tap Connect Spotify. Your public Client ID is already set; expand Spotify app settings if it needs changing. Approve the requested playback-read access in Spotify's own login flow.
3. Play a popular song in Spotify, then return to the lyrics app. Confirm a track and lyric line appear.
4. Check the Live Activity on your lock screen, then check your CarPlay Dashboard while parked. Enable Live Activities for the app in iPhone settings if needed. CarPlay presentation can depend on vehicle display support and settings.
5. Expect updates roughly every five seconds, not karaoke timing. Some songs have no synced lyrics.

## Practical limits

The original app polls Spotify from an ordinary app task. iOS can suspend it in the background, so lyrics may freeze during a longer drive. The package does not add a push server or promise continuous background synchronization. The original activity also stores track title/artist as fixed attributes, which may leave old metadata after a song change; this needs an on-device check/fix if observed.

No Mac ownership is needed for the proposed cloud-build/Windows-signing route, but the complete app-and-extension signing and CarPlay result still need to be verified on your iPhone. There is no prebuilt release supplied by the original repository at the time checked.

## References

- Original project/setup: https://github.com/darsy29/lyrics-carplay
- GitHub runner billing: https://docs.github.com/en/actions/concepts/billing-and-usage
- macOS 26 hosted runners: https://github.blog/changelog/2026-02-26-macos-26-is-now-generally-available-for-github-hosted-runners/
- Sideloadly/install and refresh: https://sideloadly.io/faq
- Spotify development-mode rules: https://developer.spotify.com/documentation/web-api/tutorials/february-2026-migration-guide
- Spotify custom mobile redirect schemes: https://developer.spotify.com/documentation/web-api/concepts/apps

## Account access checked during preparation

The connected GitHub username was confirmed, but the connection returned zero accessible repositories and zero GitHub App installations. No remote repository or Actions build was created through that connection. To have this handled in chat later, create/fork a repository and make it available to the ChatGPT GitHub connection, or use the Windows launcher above.

Your screenshots confirm the Spotify app is named CarPlay, uses Web API, and has the expected redirect URI. The full Client ID was supplied afterward and is configured in App/SpotifyConfiguration.swift. Spotify login and Premium status remain unverified.
