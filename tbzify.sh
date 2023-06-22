#!/usr/bin/env bash

clear="\033[0m"
red="\033[0;31m"
yellow="\033[0;33m"

showHelp () {
  echo -e \
"Options:
-a [path]              : set custom path to Spotify.app
-b, --blockupdates     : block Spotify auto-updates
--datawipe             : delete app data only
-h, --help             : print this message
-p [path]              : set tbz/download path
-s, --save             : save tbz after script finishes
-u [URL]               : URL of tbz to download/install
--unblockupdates       : unblock Spotify auto-updates
--uninstall            : uninstall Spotify, including app data"
}

updatesPathVar="${HOME}/Library/Application Support/Spotify/PersistentCache/Update"

while getopts ':a:bhsp:u:-:' flag; do
  case "${flag}" in
    -)
      case "${OPTARG}" in
        blockupdates)   updatesVar="true" ;;
        datawipe)       appDataVar="true" ;;
        help)           showHelp; exit 0 ;;
        save)           saveVar="true" ;;
        unblockupdates) unblockUpdatesVar="true" ;;
        uninstall)      uninstallVar="true" ;;
        *) echo -e "${red}Error:${clear} '--${OPTARG}' not supported\n\n$(showHelp)\n" >&2; exit 1 ;;
      esac ;;
    a) appPath="${OPTARG}" ;;
    b) updatesVar="true" ;;
    h) showHelp; exit 0 ;;
    s) saveVar="true" ;;
    p) pathVar="${OPTARG}" ;;
    u) urlVar="${OPTARG}" ;;
    \?) echo -e "${red}Error:${clear} '-${OPTARG}' not supported\n\n$(showHelp)" >&2; exit 1 ;;
    :)  echo -e "${red}Error:${clear} '-${OPTARG}' requires an argument\n\n$(showHelp)" >&2; exit 1 ;;
  esac
done

[[ -z "${appDataVar+x}" && -z "${pathVar+x}" && -z "${uninstallVar+x}" && -z "${urlVar+x}" && -z "${unblockUpdatesVar+x}" && -z "${updatesVar+x}" ]] \
  && { echo -e "${red}Required option(s) not set.${clear}\n" >&2; exit 1; }

[[ -z "${appPath+x}" ]] && { [[ -d "${HOME}/Applications/Spotify.app" ]] && appPath="${HOME}/Applications" || appPath="/Applications"; }
appPathVar="${appPath}/Spotify.app"

if [[ "${updatesVar}" ]]; then
  [[ -d "${updatesPathVar}" ]] || mkdir -p "${updatesPathVar}"
  [[ -f "${updatesPathVar}/BLOCKED" ]] \
    && echo -e "Auto-updates are already blocked.\n" \
    || { echo "Blocking auto-updates..."; rm -f "${updatesPathVar}/"* 2>/dev/null; touch "${updatesPathVar}/BLOCKED" 2>/dev/null; chflags uchg "${updatesPathVar}"; echo -e "Auto-updates blocked.\n"; }
  [[ -z "${uninstallVar+x}" && -z "${appDataVar+x}" && -z "${urlVar+x}" && -z "${pathVar+x}" ]] && { echo -e "Finished!\n"; exit 0; }
fi

if [[ "${unblockUpdatesVar}" ]]; then
  [[ -f "${updatesPathVar}/BLOCKED" ]] \
    && { echo "Unblocking auto-updates..."; chflags -R nouchg "${updatesPathVar}" 2>/dev/null; rm -f "${updatesPathVar}/BLOCKED" 2>/dev/null; echo -e "Auto-updates unblocked.\n"; } \
    || echo -e "Auto-updates are not currently blocked.\n"
  [[ -z "${uninstallVar+x}" && -z "${appDataVar+x}" && -z "${urlVar+x}" && -z "${pathVar+x}" ]] && { echo -e "Finished!\n"; exit 0; }
fi

if [[ "${uninstallVar}" || "${appDataVar}" ]]; then
  [[ "${uninstallVar}" ]] && echo "Uninstalling Spotify..." || echo "Deleting app data..."
  command pgrep [sS]potify >/dev/null && osascript -e 'quit app "Spotify"'
  [[ "${uninstallVar}" ]] && { [[ -d "${appPathVar}" ]] && rm -rf "${appPathVar}" 2>/dev/null || echo -e "${yellow}${appPathVar} not found but continuing removal of app data...${clear}"; }
  chflags -R nouchg "$HOME/Library/Application Support/Spotify" 2>/dev/null
  rm -rf "$HOME/Library/Application Support/Spotify" 2>/dev/null
  rm -rf "$HOME"/Library/*/com.spotify* 2>/dev/null
  rm -rf /private/var/folders/*/*/*/*om.spotify* 2>/dev/null
  [[ -z "${urlVar+x}" && -z "${pathVar+x}" ]] && { echo -e "Finished!\n"; exit 0; }
fi

if [[ -z "${urlVar+x}" ]]; then
  [[ ! -f "${pathVar}" ]] && { echo -e "${red}Archive not found!${clear}\n" >&2; exit 1; }
  fileVar="$(echo "${pathVar}" | perl -ne '/\/([^\/]+)$/ && print "$1"')"
  pathVar="$(echo "${pathVar}"  | perl -ne '/^(.+)\/[^\/]+$/ && print "$1"')"
  noDownload="true"
else
  echo "${urlVar}" | perl -ne 'exit 1 unless /^https?:\/\//i' \
    || { echo -e "${red}Invalid URL.${clear} Provide a full URL beginning with http:// or https://\n" >&2; exit 1; }
  fileVar="$(echo "${urlVar}" | perl -ne '/^https?:\/\/[^?]*\/([^?\/#]+)/ && print "$1"')"
  [[ -z "${fileVar}" ]] && fileVar="spotify-archive.tbz"
  [[ -z "${pathVar+x}" ]] && pathVar="${HOME}/Downloads"
  [[ ! -d "${pathVar}" ]] && mkdir -p "${pathVar}"
  echo -e "Downloading to ${yellow}${pathVar}/${fileVar}${clear}..."
  curl -q --progress-bar -f -o "${pathVar}/${fileVar}" "${urlVar}" \
    || { echo -e "${red}Download failed.${clear} Confirm the URL is valid and accessible.\n" >&2; rm -f "${pathVar}/${fileVar}" 2>/dev/null; exit 1; }
fi

echo -e "Installing to ${yellow}${appPathVar}${clear}..."
command pgrep [sS]potify >/dev/null && osascript -e 'quit app "Spotify"'
mkdir -p "${appPathVar}/tmpSpot"
tar -xpf "${pathVar}/${fileVar}" -C "${appPathVar}/tmpSpot" --strip-components=1 \
  || { echo -e "${red}Install failed.${clear} Exiting...\n" >&2; rm -rf "${appPathVar}/tmpSpot"; exit 1; }
rm -rf "${appPathVar}/Contents" 2>/dev/null
mv "${appPathVar}/tmpSpot" "${appPathVar}/Contents" 2>/dev/null

[[ -z "${noDownload+x}" && -z "${saveVar+x}" ]] && { echo -e "Deleting ${yellow}${pathVar}/${fileVar}${clear}..."; rm -f "${pathVar}/${fileVar}" 2>/dev/null; }
echo -e "Finished!\n"
exit 0