################################################################################
#
# mongoose
#
################################################################################

MONGOOSE_VERSION = 5.3
MONGOOSE_SITE = $(call github,cesanta,mongoose,$(MONGOOSE_VERSION))
MONGOOSE_LICENSE = GPLv2
MONGOOSE_LICENSE_FILES = LICENSE
MONGOOSE_INSTALL_STAGING = YES

MONGOOSE_CFLAGS = $(TARGET_CFLAGS) $(TARGET_LDFLAGS)

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MONGOOSE_DEPENDENCIES += openssl
# directly linked
MONGOOSE_CFLAGS += -DNS_ENABLE_SSL -lssl -lcrypto -lz
endif

define MONGOOSE_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)/examples \
		CFLAGS_EXTRA="$(MONGOOSE_CFLAGS)" server
	$(TARGET_CC) -c $(@D)/mongoose.c $(MONGOOSE_CFLAGS) -o $(@D)/mongoose.o
	$(TARGET_AR) rcs $(@D)/libmongoose.a $(@D)/mongoose.o
endef

define MONGOOSE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/examples/server \
		$(TARGET_DIR)/usr/sbin/mongoose
	$(INSTALL) -D -m 755 package/mongoose/S85mongoose \
		$(TARGET_DIR)/etc/init.d/S85mongoose
endef

define MONGOOSE_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libmongoose.a \
		$(STAGING_DIR)/usr/lib/libmongoose.a
	$(INSTALL) -D -m 644 $(@D)/mongoose.h \
		$(STAGING_DIR)/usr/include/mongoose.h
endef

$(eval $(generic-package))
