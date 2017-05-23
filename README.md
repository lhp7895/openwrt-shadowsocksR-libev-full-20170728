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

 - 从 OpenWrt 的 [SDK][S] 编译

   ```bash
   # 以 OpenWrt Chaos Calmer 15.05 ar71xx 平台为例
   wget https://downloads.openwrt.org/chaos_calmer/15.05/ar71xx/generic/OpenWrt-SDK-15.05-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2
   tar xjf OpenWrt-SDK-15.05-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2
   cd OpenWrt-SDK-15.05-ar71xx-*
   # 获取 Makefile
   git clone https://github.com/bettermanbao/openwrt-shadowsocksR-libev-full.git package/shadowsocksR-libev-full
   # 选择要编译的包 Network -> shadowsocksr-libev
   make menuconfig
   # 开始编译
   make package/shadowsocksR-libev-full/compile V=s
   ```

配置  
---

 - shadowsocks-libev 配置文件: `/etc/shadowsocksr.json`


感谢  
---

Makefile参考 [openwrt-shadowsocks][P]

----------

  [O]: https://github.com/bettermanbao/openwrt-shadowsocks-libev-full
  [1]: https://github.com/breakwa11/shadowsocks-libev
  [R]: https://github.com/bettermanbao/openwrt-shadowsocksR-libev-full/releases
  [S]: http://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
  [X]: http://www.right.com.cn/forum/thread-185635-1-1.html
  [P]: https://github.com/shadowsocks/openwrt-shadowsocks
