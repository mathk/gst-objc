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
_AM_DEPENDENCIES(OBJC)
AC_CANONICAL_HOST
LDFLAGS=-module
case $host in
     *-*-darwin*) OBJCLIBS='-framework Cocoa' ;;
     *)		  OBJCLIBS='-lobjc' ;;
esac
AC_SUBST([OBJCLIBS])
AC_SUBST(LIBTOOL_DEPS)
AC_OUTPUT
