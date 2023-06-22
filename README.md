<h1 align="center">TBZify</h1>
<h3 align="center">Download and install TBZs. Block auto-updates. Uninstall everything.</h3>


### Usage:
- Run the following command in Terminal:
```
bash <(curl -sSL https://raw.githubusercontent.com/jetfir3/TBZify/main/tbzify.sh) -v 1
```
- script can instead be downloaded/run locally
- `-v 1` will download/install latest known version
- replace `1` with full version number* to specify version
- view options, examples and FAQ below for more
<sub>
*as of May 2023, v1.1.58.820 and below is disabled by Spotify</sub>

<details>
<summary><h3>Options:</h3></summary>

| Option | Description |
| --- | --- |
| `-a [path]` | set custom path to Spotify.app |  
| `-b` | block Spotify auto-updates (--blockupdates) |  
| `-d` | download only, no install (--noinstall) |  
| `--datawipe` | delete app data only |  
| `-h` | print options (--help) |
| `-p [path]` | set archive/download path |
| `-s` | save archive after script finishes (--save) |
| `-u [URL]` | URL of archive to download/install |  
| `--uninstall` | uninstall Spotify, including app data |  
| `-v [version]` | archive version to download/install |  
</details>
<details>
<summary><h3>Examples:</h3></summary>

**Download TBZ, install client, delete TBZ**
```
./tbzify.sh -v 1.2.13.661
```
**Download TBZ (via URL), install client, delete TBZ**
```
./tbzify.sh -u https://exampleurl.com/file.tbz
```
**Install local TBZ archive**
```
./tbzify.sh -p /path/to/file.tbz
```
**Delete Spotify app data**
```
./tbzify.sh --datawipe
```
**Uninstall Spotify, including app data**
```
./tbzify.sh --uninstall
```
**Delete app data, download to `Desktop`, install to `Downloads`, block updates, save TBZ**
```
./tbzify.sh --datawipe -v 1.2.13.661 -p $HOME/Desktop -a $HOME/Downloads -bs
```
</details>

### FAQ:

**Q:** What is a TBZ file?  
**A:** TBZ is a Bzip2 compressed TAR file. Spotify packages their macOS desktop client updates in this format.

**Q:** Can't I just download the app installer on the Spotify download page?  
**A:** Absolutely, but the download page only provides the most recent stable version. "Latest isn't always the greatest" and new builds can sometimes have bugs, change/remove features, etc. Installing a different/specific version may then be preferred.

**Q:** Why is a script needed to download or install a TBZ file?  
**A:** It's not, but handling the archive is not as simple as the usual macOS installation methods.

**Q:** How can I manually download and install a TBZ instead?  
**A:** Download a TBZ archive, delete your current `Spotify.app/Contents/` directory (if a previous Spotify.app doesn't exist, create a Spotify.app directory/folder), then extract the contents of the TBZ archive into your `Spotify.app` directory. This can all be done via GUI|browser/Finder or CLI|Terminal. 

**Q:** Why am I getting an "Invalid version/unofficial source detected." error?  
**A:** This repo only supports downloading from Spotify's official CDN, anything else may fail. If using `-v [version]`, availability is soley based on known versions in examples.txt. If you have the URL of a version not already listed you can use it with `-u [URL]`.

**Q:** Why isn't Spotify working correctly after upgrading/downgrading?  
**A:** There may be conflicts with Spotify app data leftover from a previous install. Use `--datawipe` to delete Spotify's app data. Using `--datawipe` paired with `-u [URL]` or `-v [version]` would delete app data and install the specified app version in a single run. Issues related to Spotify bugs and/or computer/OS issues fall outside the scope of this repo but may be solved by installing a different Spotify app version and/or wiping app data.

***

