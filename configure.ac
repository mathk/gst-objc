AC_PREREQ(2.59)
AC_CONFIG_MACRO_DIR([m4])
AC_INIT([GNU Smalltalk package Objc], [0.0], , gst-objc)
AC_CONFIG_SRCDIR([configure.ac])

AM_INIT_AUTOMAKE

AM_PATH_GST([3.2])
GST_PACKAGE_ENABLE([Objc], [gst-objc])

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([gst], [chmod +x gst])
AC_PROG_LIBTOOL
AC_SUBST(OBJC, [$CC])
AC_SUBST(OBJCFLAGS, [$CFLAGS])
AC_SUBST(GNUSTEP_CFLAGS)
AC_SUBST(OBJCLIBS)
_AM_DEPENDENCIES(OBJC)
AC_CANONICAL_HOST
LDFLAGS=-module
case $host in
     *-*-darwin*) OBJCLIBS='-framework Cocoa' ;;
     *)		  AC_CHECK_TOOL(GNUSTEP_CONFIG, [gnustep-config], 
     		  		[no])
	          if test "$GNUSTEP_CONFIG" == no; then
		     AC_MSG_ERROR([gnustep is missing perhaps you need to souce \$GNUSTEP_INSTALL_DIR/System/Library/Makefiles/GNUstep.sh])
		  fi
		  OBJCLIBS=`$GNUSTEP_CONFIG --gui-libs`
     		  GNUSTEP_CFLAGS=`$GNUSTEP_CONFIG --objc-flags` ;;
esac

AC_SUBST(LIBTOOL_DEPS)
AC_OUTPUT
