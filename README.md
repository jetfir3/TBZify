<h1 align="center">TBZify</h1>
<h3 align="center">Install Spotify TBZs. Block auto-updates. Uninstall everything.</h3>

### Options:
| Option | Description |
| --- | --- |
| `-a [path]` | set custom path to Spotify.app |  
| `-b, --blockupdates` | block Spotify auto-updates |  
| `--datawipe` | delete app data only |  
| `-h, --help` | print options |
| `-p [path]` | set TBZ/download path |
| `-s, --save` | save TBZ after script finishes |
| `-u [URL]` | URL of TBZ to download/install |  
| `--unblockupdates` | unblock Spotify auto-updates |  
| `--uninstall` | uninstall Spotify, including app data |  

### Examples:
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
./tbzify.sh --datawipe -u https://exampleurl.com/file.tbz -p $HOME/Desktop -a $HOME/Downloads -bs
```

### FAQ:

**Q:** What is a TBZ file?  
**A:** TBZ is a Bzip2 compressed TAR file. Spotify packages their macOS desktop client updates in this format.

**Q:** Why is a script needed to download or install a TBZ file?  
**A:** It's not, but handling the archive is not as simple as the usual macOS app installation methods.

**Q:** How can I manually install a TBZ instead?  
**A:** Delete your current `Spotify.app/Contents/` directory, move TBZ file into Spotify.app and extract (if a previous Spotify.app doesn't exist, create a new directory and name it Spotify.app).

***

