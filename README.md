# A Debian-based LiveCD builder for ICPC

Summary:
a 64-bit Debian Live installation for the International Collegiate Programming Competition (ICPC).

Includes: gcc, g++, Java, Python 3, Eclipse (for C, C++, Java, and Python), PyCharm, Visual Studio Code, Vim, Emacs, gdb.
Locked down to prevent user administrative access, and limits all outbound network traffic to a preconfigured Squid proxy server.
Currently preconfigured for the US Mid-Central region proxy server, and only administerable via root ssh key.

System requirements:

- Debian amd64 installation (tested on 12.7, may work on earlier versions)

Basic Usage:

1. Read through `build.sh` and the files under `debian-live/config`.
2. Run `./build.sh` or `./build.sh allow-internet` as root (unprivileged builds will come later).
3. Copy the resulting `live-image-amd64.hybrid.iso` to media and boot.

**The `allow-internet` build will allow full outbound Internet access for teams to practice with, and should not be used for an actual contest.**

You may have to remove the `/root/icpc` directory before making a new build. The included `Vagrantfile` does this automatically as part of provisioning.

Eclipse installation with C, C++, Java, and Python support is somewhat difficult to achieve (advice, or even better, pull requests accepted on this item). We made ours by:

1. Temporarily changing ownership of `/opt` to the `live` user,
2. Doing an Eclipse installation into `/opt/eclipse`,
3. Adding language support for C, C++, and Java,
4. Adding Python support following the instructions at [PyDev - Install](https://www.pydev.org/manual_101_install.html),
5. Renaming/moving `~live/.p2` to `/opt/eclipse/p2`,
6. Making a tarball of the `eclipse` folder from `/opt`,
7. Copying the `eclipse.tgz` file to the top-level folder for this repository clone.

The `/etc/skel` folder will automatically include a symlink from `~live/p2` to `/opt/eclipse/p2`.

Administration:

1. For normal usage, replace the `authorized_keys` file in `debian-live/config/includes.chroot/root/.ssh` and rebuild the image.
2. If you need to install other packages on the live system, or otherwise need network access, run `shorewall stop` to disable the firewall, and unset the needed the `*proxy` variables that were set from `/etc/environment`: `http_proxy`, `https_proxy`, `ftp_proxy`, `HTTP_PROXY`, `HTTPS_PROXY`, `FTP_PROXY`. Once you're done, restart shorewall with `shorewall start`.

References:

- [Debian Live Manual](https://live-team.pages.debian.net/live-manual/)
- [Debian Wiki: DebianLive](https://wiki.debian.org/DebianLive)
