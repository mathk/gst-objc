#include <gstpub.h>
#include <gst-objc-ext.h>
//#define _NATIVE_OBJC_EXCEPTIONS
#import <Foundation/Foundation.h>
#import "LKInterpreterRuntime.h"
#ifdef __APPLE__
#include <objc/runtime.h>
#endif
static NSAutoreleasePool* pool;

void
gst_initModule (VMProxy * proxy)
{
#ifdef __APPLE__
  proxy->dlOpen ("libobjc", false);
  proxy->dlOpen ("Cocoa.framework/Cocoa", false);
#else // __APPLE__
  proxy->dlOpen ("libgnustep-base", false);
#endif  // __APPLE__
  proxy->defineCFunc ("fillRedCB", fillRed);
  proxy->defineCFunc ("gstRectFill", gst_rectFill);
  proxy->defineCFunc ("sendMsg", LKSendMessage);
  proxy->defineCFunc ("toNSString", toNSString);
  pool = [[NSAutoreleasePool alloc] init];
  /*NSApplication *myApplication;
    myApplication = [NSApplication sharedApplication];*/
  NSLog (@"Load complete");
}

