ShadowsocksR-libev-full for OpenWrt  
===

简介  
---

 本项目是 [ShadowsocksR-libev][1] 在 OpenWrt 上的移植。   
 当前版本: v20170521  
 
 [预编译 OpenWrt Chaos Calmer ipk 下载][R]


特性  
---

 - shadowsocksR-libev

   > 官方原版客户端  
   
   > 可执行文件 `ssr-{local,redir}`  
   > 默认启动:  
   > `ssr-local` 提供 SOCKS 代理  

编译  
---

 - 从 lede 的 [SDK][S] 编译
 
```bash
   
   # 以 ubuntu 14.04 x86_64 为例
   apt-get update
   apt-get install software-properties-common xz-utils build-essential ccache git libncurses5-dev libncursesw5-dev gawk
   
   #ubuntu 14.04 以后的版本不需要这一步
   add-apt-repository ppa:ubuntu-toolchain-r/test
   apt-get update
   apt-get install libstdc++6-4.7-dev libstdc++6
   
   # 下载lede-SDK，以ramips为例
   wget https://downloads.lede-project.org/releases/17.01.1/targets/ramips/mt7620/lede-sdk-17.01.1-ramips-mt7620_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz
   tar xf lede-sdk-17.01.1-ramips-mt7620_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz
   cd lede-sdk-*
   
   # git clone openwrt-shadowsocksR-libev-full
   git clone https://github.com/bettermanbao/openwrt-shadowsocksR-libev-full.git package/shadowsocksR-libev-full
   
   # 选择要编译的包 Network -> shadowsocksr-libev
   make menuconfig
   
   # 一些杂七杂八的坑
   ./scripts/feeds update base
   ./scripts/feeds update packages
   ./scripts/feeds install libpcre libopenssl libopenssl libmbedtls
   wget -P package/feeds/base/mbedtls/patches https://github.com/bettermanbao/lede/raw/lede-17.01/package/libs/mbedtls/patches/999-tweak-config-for-shadowsocks.patch
   
   # 开始编译
   make package/shadowsocksR-libev-full/compile V=s
   
   ```

配置  
---

 - shadowsocks-libev 配置文件: `/etc/shadowsocksr.json`


感谢  
---

Makefile参考  [openwrt-shadowsocks][E]

----------

  [O]: https://github.com/bettermanbao/openwrt-shadowsocks-libev-full
  [1]: https://github.com/breakwa11/shadowsocks-libev
  [R]: https://github.com/bettermanbao/openwrt-shadowsocksR-libev-full/releases
  [S]: https://downloads.lede-project.org/releases/17.01.1/targets
  [E]: https://github.com/shadowsocks/openwrt-shadowsocks
  
