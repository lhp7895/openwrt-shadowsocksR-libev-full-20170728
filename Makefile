include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksR-libev
PKG_VERSION:=2.4.5
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_SOURCE_URL:=https://github.com/breakwa11/shadowsocks-libev.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=6214de59b370eab12b06ff9a20dd5bad55afc769
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_MAINTAINER:=breakwa11

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksr-libev/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Lightweight Secured Socks5 Proxy
  URL:=https://github.com/breakwa11/shadowsocks-libev
endef

define Package/shadowsocksr-libev
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (OpenSSL)
  VARIANT:=openssl
  DEPENDS:=+libopenssl +libpthread
endef

define Package/shadowsocksr-libev-polarssl
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (PolarSSL)
  VARIANT:=polarssl
  DEPENDS:=+libpolarssl +libpthread
endef

define Package/shadowsocksr-libev-gfwlist
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (OpenSSL)
  VARIANT:=openssl
  DEPENDS:=+libopenssl +libpthread +dnsmasq-full +ipset +iptables +wget
endef

define Package/shadowsocksr-libev-gfwlist-polarssl
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (PolarSSL)
  VARIANT:=polarssl
  DEPENDS:=+libpolarssl +libpthread +dnsmasq-full +ipset +iptables +wget-nossl
endef

define Package/shadowsocksr-libev-server
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (OpenSSL)
  VARIANT:=openssl
  DEPENDS:=+libopenssl +libpthread
endef

define Package/shadowsocksr-libev-server-polarssl
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (PolarSSL)
  VARIANT:=polarssl
  DEPENDS:=+libpolarssl +libpthread
endef

define Package/shadowsocksr-libev/description
ShadowsocksR-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocksr-libev-polarssl/description=$(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-gfwlist/description=$(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-gfwlist-polarssl/description=$(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-server/description=$(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-server-polarssl/description=$(Package/shadowsocksr-libev/description)

define Package/shadowsocksr-libev/conffiles
/etc/shadowsocksr.json
endef

Package/shadowsocksr-libev-polarssl/conffiles = $(Package/shadowsocksr-libev/conffiles)

define Package/shadowsocksr-libev-gfwlist/conffiles
/etc/shadowsocksr.json
/etc/dnsmasq.d/custom_list.conf
endef

Package/shadowsocksr-libev-gfwlist-polarssl/conffiles = $(Package/shadowsocksr-libev-gfwlist/conffiles)

define Package/shadowsocksr-libev-server/conffiles
/etc/shadowsocksr-server.json
endef

Package/shadowsocksr-libev-server-polarssl/conffiles = $(Package/shadowsocksr-libev-server/conffiles)

define Package/shadowsocksr-libev-gfwlist/preinst
#!/bin/sh
if [ ! -f /etc/dnsmasq.d/custom_list.conf ]; then
	echo "ipset -N gfwlist iphash" >> /etc/firewall.user
	echo "iptables -t nat -A PREROUTING -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1080" >> /etc/firewall.user
	echo "iptables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1080" >> /etc/firewall.user
	
	echo "cache-size=5000" >> /etc/dnsmasq.conf
	echo "min-cache-ttl=1800" >> /etc/dnsmasq.conf
	echo "conf-dir=/etc/dnsmasq.d" >> /etc/dnsmasq.conf
	
	echo "*/10 * * * * /root/ssr-watchdog >> /var/log/shadowsocksr_watchdog.log 2>&1" >> /etc/crontabs/root
	echo "0 1 * * 0 echo \"\" > /var/log/shadowsocksr_watchdog.log" >> /etc/crontabs/root
fi
exit 0
endef

define Package/shadowsocksr-libev-gfwlist/postinst
#!/bin/sh
ipset -N gfwlist iphash
iptables -t nat -A PREROUTING -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1080
iptables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1080

/etc/init.d/dnsmasq restart
/etc/init.d/cron restart
/etc/init.d/shadowsocksr restart
exit 0
endef

define Package/shadowsocks-libev-gfwlist/postrm
#!/bin/sh
sed -i '/cache-size=5000/d' /etc/dnsmasq.conf
sed -i '/min-cache-ttl=1800/d' /etc/dnsmasq.conf
sed -i '/conf-dir=\/etc\/dnsmasq.d/d' /etc/dnsmasq.conf
rm -rf /etc/dnsmasq.d
/etc/init.d/dnsmasq restart

sed -i '/ipset -N gfwlist iphash/d' /etc/firewall.user
sed -i '/iptables -t nat -A PREROUTING -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1080/d' /etc/firewall.user
sed -i '/iptables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1080/d' /etc/firewall.user
ipset flush gfwlist

sed -i '/shadowsocksr_watchdog.log/d' /etc/crontabs/root
/etc/init.d/cron restart

exit 0
endef

Package/shadowsocksr-libev-gfwlist-polarssl/preinst = $(Package/shadowsocksr-libev-gfwlist/preinst)
Package/shadowsocksr-libev-gfwlist-polarssl/postinst = $(Package/shadowsocksr-libev-gfwlist/postinst)
Package/shadowsocksr-libev-gfwlist-polarssl/postrm = $(Package/shadowsocksr-libev-gfwlist/postrm)

CONFIGURE_ARGS += --disable-ssp

ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/shadowsocksr.json $(1)/etc/shadowsocksr.json
	$(INSTALL_BIN) ./files/shadowsocksr $(1)/etc/init.d/shadowsocksr
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-tunnel $(1)/usr/bin/ssr-tunnel
endef

Package/shadowsocksr-libev-polarssl/install=$(Package/shadowsocksr-libev/install)

define Package/shadowsocksr-libev-gfwlist/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-tunnel $(1)/usr/bin/ssr-tunnel
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/shadowsocksr-gfwlist.json $(1)/etc/shadowsocksr.json
	$(INSTALL_BIN) ./files/shadowsocksr-gfwlist $(1)/etc/init.d/shadowsocksr
	$(INSTALL_DIR) $(1)/etc/dnsmasq.d
	$(INSTALL_CONF) ./files/dnsmasq_list.conf $(1)/etc/dnsmasq.d/dnsmasq_list.conf
	$(INSTALL_CONF) ./files/custom_list.conf $(1)/etc/dnsmasq.d/custom_list.conf
	$(INSTALL_DIR) $(1)/root
	$(INSTALL_BIN) ./files/ssr-watchdog $(1)/root/ssr-watchdog
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_CONF) ./files/shadowsocksr-libev.lua $(1)/usr/lib/lua/luci/controller/shadowsocksr-libev.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/shadowsocksr-libev
	$(INSTALL_CONF) ./files/shadowsocksr-libev-general.lua $(1)/usr/lib/lua/luci/model/cbi/shadowsocksr-libev/shadowsocksr-libev-general.lua
	$(INSTALL_CONF) ./files/shadowsocksr-libev-custom.lua $(1)/usr/lib/lua/luci/model/cbi/shadowsocksr-libev/shadowsocksr-libev-custom.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/shadowsocksr-libev
	$(INSTALL_CONF) ./files/gfwlistr.htm $(1)/usr/lib/lua/luci/view/shadowsocksr-libev/gfwlistr.htm
	$(INSTALL_CONF) ./files/watchdogr.htm $(1)/usr/lib/lua/luci/view/shadowsocksr-libev/watchdogr.htm
endef

Package/shadowsocksr-libev-gfwlist-polarssl/install = $(Package/shadowsocksr-libev-gfwlist/install)

define Package/shadowsocksr-libev-server/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/shadowsocksr-server.json $(1)/etc/shadowsocksr-server.json
	$(INSTALL_BIN) ./files/shadowsocksr-server $(1)/etc/init.d/shadowsocksr-server
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-server $(1)/usr/bin/ssr-server
endef

Package/shadowsocksr-libev-server-polarssl/install=$(Package/shadowsocksr-libev-server/install)

$(eval $(call BuildPackage,shadowsocksr-libev))
$(eval $(call BuildPackage,shadowsocksr-libev-polarssl))
$(eval $(call BuildPackage,shadowsocksr-libev-gfwlist))
$(eval $(call BuildPackage,shadowsocksr-libev-gfwlist-polarssl))
$(eval $(call BuildPackage,shadowsocksr-libev-server))
$(eval $(call BuildPackage,shadowsocksr-libev-server-polarssl))
