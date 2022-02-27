# A Debian-based LiveCD builder for ICPC

Summary: a 64-bit Debian Live installation for the International Collegiate Programming Competition (ICPC).

Includes: gcc, g++, Java, Python 2, Python 3, Visual Studio Code, Eclipse, Vim, Emacs

System requirements:

- Debian amd64 installation (tested on 11.2.0, may work on earlier versions)

Usage:

1. Read through `build.sh` and the files under `debian-live/config`.
2. `bash build.sh`
3. Copy the resulting `live-image-amd64.hybrid.iso` to media and boot.

References:

- [Debian Live Manual](https://live-team.pages.debian.net/live-manual/)
- [Debian Wiki: DebianLive](https://wiki.debian.org/DebianLive)
