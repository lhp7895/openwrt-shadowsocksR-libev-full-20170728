include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksR-libev
PKG_VERSION:=v20170521
PKG_RELEASE:=1pre

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_SOURCE_URL:=https://github.com/breakwa11/shadowsocks-libev.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=0a3613ab2977de13596bc8e8393b977e012f895d
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
  DEPENDS:=+libopenssl +libpthread +libpcre
endef

define Package/shadowsocksr-libev-polarssl
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (PolarSSL)
  VARIANT:=polarssl
  DEPENDS:=+libpolarssl +libpthread +libpcre
endef

define Package/shadowsocksr-libev-mbedtls
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (mbedTLS)
  VARIANT:=mbedtls
  DEPENDS:=+libmbedtls +libpthread +libpcre
endef

define Package/shadowsocksr-libev/description
ShadowsocksR-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocksr-libev-polarssl/description=$(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-mbedtls/description=$(Package/shadowsocksr-libev/description)

define Package/shadowsocksr-libev/conffiles
/etc/shadowsocksr.json
endef

Package/shadowsocksr-libev-polarssl/conffiles = $(Package/shadowsocksr-libev/conffiles)
Package/shadowsocksr-libev-mbedtls/conffiles = $(Package/shadowsocksr-libev/conffiles)

CONFIGURE_ARGS += --disable-ssp --disable-documentation --disable-assert

ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

ifeq ($(BUILD_VARIANT),mbedtls)
	CONFIGURE_ARGS += --with-crypto-library=mbedtls
endif

define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/shadowsocksr $(1)/etc/init.d/shadowsocksr
	$(INSTALL_CONF) ./files/shadowsocksr.json $(1)/etc/shadowsocksr.json
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-tunnel $(1)/usr/bin/ssr-tunnel
endef

Package/shadowsocksr-libev-polarssl/install=$(Package/shadowsocksr-libev/install)
Package/shadowsocksr-libev-mbedtls/install=$(Package/shadowsocksr-libev/install)

$(eval $(call BuildPackage,shadowsocksr-libev))
$(eval $(call BuildPackage,shadowsocksr-libev-polarssl))
$(eval $(call BuildPackage,shadowsocksr-libev-mbedtls))

