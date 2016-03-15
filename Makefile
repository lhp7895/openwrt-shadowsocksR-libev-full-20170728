#
# Copyright (C) 2015 OpenWrt-dist
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksr-libev
PKG_VERSION:=2.4.5
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/breakwa11/shadowsocks-libev.git
PKG_SOURCE_VERSION:=9dd25c3f1dee13f32350c9c1749bac293648522f

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksr-libev/Default
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Lightweight Secured Socks5 Proxy $(2)
	URL:=https://github.com/breakwa11/shadowsocks-libev.git
	VARIANT:=$(1)
	DEPENDS:=$(3)
endef

Package/shadowsocksr-libev = $(call Package/shadowsocksr-libev/Default,openssl,(OpenSSL),+libopenssl +libpthread)
Package/shadowsocksr-libev-polarssl = $(call Package/shadowsocksr-libev/Default,polarssl,(PolarSSL),+libpolarssl +libpthread)

define Package/shadowsocksr-libev/description
Shadowsocksr-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocksr-libev-polarssl/description = $(Package/shadowsocksr-libev/description)

define Package/shadowsocksr-libev/conffiles
/etc/shadowsocksr.json
endef

Package/shadowsocksr-libev-polarssl/conffiles = $(Package/shadowsocksr-libev/conffiles)

CONFIGURE_ARGS += --disable-ssp

ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-{local,redir,tunnel} $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/shadowsocksr.json $(1)/etc/shadowsocksr.json
	$(INSTALL_BIN) ./files/shadowsocksr $(1)/etc/init.d/shadowsocksr
endef

Package/shadowsocksr-libev-polarssl/install = $(Package/shadowsocksr-libev/install)

$(eval $(call BuildPackage,shadowsocksr-libev))
$(eval $(call BuildPackage,shadowsocksr-libev-polarssl))
