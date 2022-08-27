<h1 align="center">
    <img src="https://koolclash.js.org/img/koolclash.png" alt="Clash" width="120">
    <br>KoolClash
</h1>

<p align="center">
A rule based custom proxy for <strong>Koolshare OpenWrt/LEDE x64</strong> based on <a href="https://github.com/Dreamacro/clash" target="_blank">Clash</a>.
<br>
<a href="https://koolclash.js.org">Documentation(zh-Hans)</a> |
<a href="https://github.com/SukkaW/Koolshare-Clash.git">From SukkaW</a> |
<a href="https://github.com/houzi-/Koolshare-Clash-hack/releases">Download</a> 
</p>

<p align="center">
    <!--<a href="https://travis-ci.org/SukkaW/KoolShare-Clash">
        <img src="https://img.shields.io/travis/SukkaW/KoolShare-Clash.svg?style=flat-square" alt="Travis-CI">
    </a>-->
    <a href="https://github.com/houzi-/Koolshare-Clash-hack/releases" target="_blank">
        <img src="https://img.shields.io/github/release/houzi-/Koolshare-Clash-hack/all.svg?style=flat-square">
    </a>
    <a href="https://github.com/Dreamacro/clash" target="_blank">
        <img src="https://img.shields.io/github/release/Dreamacro/clash/all.svg?style=flat-square"/>
    </a>
    <a href="https://github.com/houzi-/Koolshare-Clash-hack/blob/master/LICENSE" target="_blank">
        <img src="https://img.shields.io/github/license/sukkaw/koolshare-clash.svg?style=flat-square"/>
    </a>
    <a href="https://github.com/houzi-/Koolshare-Clash-hack/releases" target="_blank">
        <img src="https://img.shields.io/github/downloads/houzi-/Koolshare-Clash-hack/total.svg?style=flat-square"/>
    </a>
</p>

<p align="center">
    <img src="http://router.houzi-blog.top:3090/images/2022-08-27.png">
</p>

> KoolClash is for [Koolshare OpenWrt/LEDE x86_64](http://fw.koolcenter.com/LEDE_X64_fw867) ONLY. Use [OpenClash](https://github.com/vernesong/OpenClash/) if you are running original OpenWrt.

## Keywords

- [Clash](https://github.com/Dreamacro/clash) : A multi-platform & rule-base tunnel
- **[KoolClash](https://koolclash.js.org) : This project, a rule based custom proxy for [Koolshare OpenWrt/LEDE x64](https://www.koolcenter.com/) based on Clash.**

## Features

- HTTP/HTTPS and SOCKS protocol
- Surge like configuration
- ~~GeoIP rule support~~
- ~~Support Vmess/Shadowsocks/Socks5~~
- Support for Netfilter TCP redirect
- ~~Support Equipment control

Besides those features that Clash have, KoolClash has more:

- Install clash and upload config to [Koolshare OpenWrt/LEDE X86](http://fw.koolcenter.com/LEDE_X64_fw867/)
- ~~Transparent proxy for all of your devices~~
- Proxy gateway like Surge Enhanced Mode 

## Installation

Download latest `koolshare.tar.gz` from [GitHub Release](https://github.com/houzi-/Koolshare-Clash-hack/releases), and then upload to Koolshare OpenWrt/LEDE Soft Center as offline installation.

Read the [detailed installation instructions (written in Chinese)](https://koolclash.js.org/#/install) for more details.

## Build

```bash
$ git clone https://github.com/houzi-/Koolshare-Clash-hack.git
$ cd Koolshare-Clash-hack
$ ./build # Package installation package
```

## Clash on Other Platforms

- [Clash for Windows](https://github.com/Fndroid/clash_for_windows_pkg) : A Windows GUI based on Clash
- [clashX](https://github.com/yichengchen/clashX) : A rule based custom proxy with GUI for Mac base on clash
- [ClashA](https://github.com/ccg2018/ClashA) : An Android GUI for Clash
- [OpenClash](https://github.com/vernesong/OpenClash) : Another Clash Client For OpenWrt

## Contributions

[Report a Bug](https://github.com/houzi-/Koolshare-Clash-hack/issues/new/choose) | [Improve Documentations](https://github.com/SukkaW/Koolshare-Clash/tree/master/docs) | [Fork & Open a New PR](https://github.com/houzi-/Koolshare-Clash-hack/fork)

All kinds of contributions (enhancements, new features, documentation & code improvements, issues & bugs reporting) are welcome.

## License

KoolClash is released under the GPL-3.0 License - see the [LICENSE](https://github.com/houzi-/Koolshare-Clash-hack/blob/main/LICENSE) file for details.

Also, this project includes [GeoLite2](https://dev.maxmind.com/geoip/geoip2/geolite2/) data created by [MaxMind](https://www.maxmind.com).

## Disclaimer

KoolClash is not responsible for any loss of any user, including but not limited to Kernel Panic, device fail to boot or can not function normally, storage damage or data loss, atomic bombing, World War III, The CK-Class Restructuring Scenario that SCP Foundation can not prevent, and so on.

## Sponsors

<a href="https://tshl.ru/auth/register?code=
NN2p9zXWg8cyIPDjtOEDXuMMQeRuhFr7" target="_blank"><img src="https://raw.githubusercontent.com/houzi-/Koolshare-Clash-hack/main/adv.png" width="130px" height="25px"></a>

## Maintainer

**KoolClash** © [Sukka](https://github.com/SukkaW), Released under the [GPL-3.0]([./LICENSE](https://github.com/houzi-/Koolshare-Clash-hack/blob/main/LICENSE)) License.<br>
Authored and maintained by [Sukka](https://github.com/SukkaW) with help from contributors ([list](https://github.com/SukkaW/Koolshare-Clash/contributors)).

> [Personal Website](https://skk.moe) · [Blog](https://blog.skk.moe) · GitHub [@SukkaW](https://github.com/SukkaW) · Telegram Channel [@SukkaChannel](https://t.me/SukkaChannel) · Twitter [@isukkaw](https://twitter.com/isukkaw) · Keybase [@sukka](https://keybase.io/sukka)

**KoolClash-hack** © [houzi-](https://github.com/houzi-), Released under the [GPL-3.0]([./LICENSE](https://github.com/houzi-/Koolshare-Clash-hack/blob/main/LICENSE)) License.<br>
Hacker by [houzi-](https://github.com/houzi-) with help from contributors ([list](https://github.com/houzi-/Koolshare-Clash-hack/contributors)).
