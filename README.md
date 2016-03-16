ShadowsocksR-libev-full for OpenWrt  
===

简介
---

 本项目尚在完善中，感兴趣的朋友可以先试用我的另外一个项目，移植的是原版的Shadowsocks-libev。  
 项目地址： [openwrt-shadowsocks-libev-full][O]  

 本项目是 [shadowsocksR-libev][1] 在 OpenWrt 上的完整移植，包括客户器端和服务端。   
 当前版本: 2.4.5-2  
 [预编译 OpenWrt Chaos Calmer 15.05 ipk 下载][R]

特性
---

可编译 两种客户端版本 和 一种服务器端版本。

 - shadowsocksR-libev

   > 官方原版客户端  
   
   > 可执行文件 `ssr-{local,redir,tunnel}`  
   > 默认启动:  
   > `ssr-redir` 提供透明代理  
   > `ssr-tunnel` 提供隧道转发   

 - shadowsocksR-libev-gfwlist

   > 集成gfwlist的一键安装版客户端，带luci界面  
   
   > 可执行文件 `ssr-{redir,tunnel,watchdog}`  
   > 默认启动:  
   > `ssr-redir` 提供透明代理  
   > `ssr-tunnel` 提供 UDP 转发, 用于 DNS 查询。  
   > `ssr-watchdog` 守护进程，每10分钟检查一次 www.google.com.hk 的联通情况。
   
   > 安装方法：  
     >> shadowsocksr-libev-gfwlist 使用openssl加密库 完整安装需要约 5.0M 空间  
     >> shadowsocksr-libev-gfwlist-polarssl 使用polarssl加密库 完整安装需要约 3.5M 空间  
     >> 用 winscp 把对应平台的 shadowsocksr-libev-gfwlist 的ipk文件上传到路由器 /tmp 目录  
     >> 带上--force-overwrite 选项运行 opkg install  
     >> ```bash  
     >> opkg --force-overwrite install /tmp/shadowsocksr-libev-gfwlist*.ipk  
     >> ```  
     >> 安装结束时会提示一条错误信息，这是升级dnsmasq-full时的配置文件残留造成的，可以忽略。  

 - shadowsocksR-libev-server

   > 官方原版服务器端  
   
   > 可执行文件 `ssr-server`  
   > 默认启动:  
   > `ssr-server` 提供 shadowsocks 服务  

编译
---

 - 从 OpenWrt 的 [SDK][S] 编译

   ```bash
   # 以 OpenWrt Chaos Calmer 15.05 ar71xx 平台为例
   wget https://downloads.openwrt.org/chaos_calmer/15.05/ar71xx/generic/OpenWrt-SDK-15.05-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2
   tar xjf OpenWrt-SDK-15.05-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2
   cd OpenWrt-SDK-15.05-ar71xx-*
   # 获取 Makefile
   git clone https://github.com/bettermanbao/openwrt-shadowsocksR-libev-full.git package/shadowsocksr-libev-full
   # 选择要编译的包 Network -> shadowsocksr-libev
   make menuconfig
   # 开始编译
   make package/shadowsocksr-libev-full/compile V=s
   ```

配置
---

 - shadowsocks-libev 配置文件: `/etc/shadowsocksr.json`

 - shadowsocks-libev-gfwlist 配置文件: `/etc/shadowsocksr.json`

 - shadowsocks-libev-server 配置文件: `/etc/shadowsocksr-server.json`

----------

  [O]: https://github.com/bettermanbao/openwrt-shadowsocks-libev-full
  [1]: https://github.com/breakwa11/shadowsocks-libev
  [R]: https://github.com/bettermanbao/openwrt-shadowsocksR-libev-full/releases
  [S]: http://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
