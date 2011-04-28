#include <gstpub.h>
#include "gst-objc-ext.h"
#import <Foundation/Foundation.h>
//#import "LKInterpreterRuntime.h"
#ifdef __APPLE__
#include <objc/runtime.h>
#endif
static NSAutoreleasePool* pool;
VMProxy* gst_proxy;


void
gst_initModule (VMProxy * proxy)
{
  gst_proxy = proxy;
#ifdef __APPLE__
  proxy->dlOpen ("libobjc", false);
  proxy->dlOpen ("Cocoa.framework/Cocoa", false);
#else // __APPLE__
  proxy->dlOpen ("libgnustep-base", false);
#endif  // __APPLE__
  proxy->defineCFunc ("objc_sendMsg", gst_sendMessage);
  proxy->defineCFunc ("objc_toNSString", gst_toNSString);
  proxy->defineCFunc ("objc_prepareArguments", gst_prepareArguments);
  proxy->defineCFunc ("objc_sendReturnSize", gst_sendMessageReturnSize);
  proxy->defineCFunc ("objc_sendReturnType", gst_sendMessageReturnType);
  proxy->defineCFunc ("objc_retain", gst_retain);
  proxy->defineCFunc ("objc_release", gst_release);
  pool = [[NSAutoreleasePool alloc] init];
  NSLog (@"Load complete");
}

