#include <gstpub.h>
#include <gst-objc-ext.h>
//#define _NATIVE_OBJC_EXCEPTIONS
#import <Foundation/Foundation.h>
#import "LKInterpreterRuntime.h"
#ifdef __APPLE__
#include <objc/runtime.h>
#endif


void
gst_initModule (VMProxy * proxy)
{
#ifdef __APPLE__
  proxy->dlOpen ("libobjc", false);
  proxy->dlOpen ("Cocoa.framework/Cocoa", false);
#else // __APPLE__
  proxy->dlOpen ("libgnustep-base", false);
 // proxy->defineCFunc ("objc_msgSend", );
#endif  // __APPLE__
  proxy->defineCFunc ("fillRedCB", fillRed);
  proxy->defineCFunc ("gstRectFill", gst_rectFill);
  NSLog (@"Load complete");
}

