AUTOMAKE_OPTIONS = foreign
ACLOCAL_AMFLAGS = -I m4
AM_CPPFLAGS = $(GST_CFLAGS) $(LIBFFI_CFLAGS)
AM_OBJCFLAGS = $(GNUSTEP_CFLAGS)

## Example:
##
## gst_module_ldflags = -rpath $(gstlibdir) -module \
##        -no-undefined -export-symbols-regex gst_initModule
##
## noinst_HEADERS = md5.h sha1.h
## gstlib_LTLIBRARIES = digest.la
## digest_la_SOURCES = digest.c md5.c sha1.c
## digest_la_LDFLAGS = $(gst_module_ldflags)

#include $(GNUSTEP_MAKEFILES)/common.make

lib_LTLIBRARIES = libgstobjc.la
libgstobjc_la_SOURCES = gst-objc.m gst-objc.h gst-objc-ext.m gst-objc-ext.h \
			objc-proxy.m objc-proxy.h gst-string.h gst-string.m \
			gst-array.h gst-array.m
libgstobjc_la_LDFLAGS = $(OBJCLIBS) $(LIBFFI_LIBS) $(LIBGMP)

### -------------------------------------- ###
### Rules completed by GST_PACKAGE_ENABLE. ###
### -------------------------------------- ###

DISTCLEANFILES = pkgrules.tmp
all-local:
clean-local::
install-data-hook::
dist-hook::
uninstall-local::

@PACKAGE_RULES@
