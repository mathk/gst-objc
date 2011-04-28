AC_PREREQ(2.59)
AC_CONFIG_MACRO_DIR([m4])
AC_INIT([GNU Smalltalk package Objc], [0.0], , gst-objc)
AC_CONFIG_SRCDIR([configure.ac])

AM_INIT_AUTOMAKE

AM_PATH_GST([3.2])
GST_PACKAGE_ENABLE([Objc], [gst-objc])

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([gst], [chmod +x gst])

dnl ------------------------------- PROGRAMS ------------------
{ echo; echo "${term_bold}Build Tools:${term_norm}"; } >& AS_MESSAGE_FD

AC_PROG_LIBTOOL
PKG_PROG_PKG_CONFIG

PKG_CHECK_MODULES([LIBFFI], [libffi], [HAVE_LIBFFI=yes])
if test "no$HAVE_LIBFFI" == no
then
	 AC_MSG_ERROR([libffi is missing. Try to install it before])
fi

GST_HAVE_GMP

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

AC_SUBST(OBJC, [$CC])
AC_SUBST(OBJCFLAGS, [$CFLAGS])
AC_SUBST(GNUSTEP_CFLAGS)
AC_SUBST(OBJCLIBS)
AC_SUBST(LIBTOOL_DEPS)
AC_OUTPUT
