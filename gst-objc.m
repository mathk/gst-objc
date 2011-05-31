#import "gst-objc.h"


static NSAutoreleasePool* pool;
VMProxy* gst_proxy;


void
gst_initModule (VMProxy * proxy)
{
  gst_proxy = proxy;
#ifndef GNU_RUNTIME
  proxy->dlOpen ("libobjc", false);
  proxy->dlOpen ("Cocoa.framework/Cocoa", false);
#else // __APPLE__
  proxy->dlOpen ("libgnustep-base", false);
#endif  // __APPLE__
  gst_initFFIType ();
  gst_initThreading ();
  gst_initGlobal ();
  proxy->defineCFunc ("objc_sendMsg", gst_sendMessage);
  proxy->defineCFunc ("objc_addStObjectGetter", gst_addStObjectGetter);
  proxy->defineCFunc ("objc_sizeofCGFloat", gst_sizeofCGFloat);
  proxy->defineCFunc ("objc_addSetter", gst_addSetter);
  proxy->defineCFunc ("objc_addGetter", gst_addGetter);
  proxy->defineCFunc ("objc_sendReturnSize", gst_sendMessageReturnSize);
  proxy->defineCFunc ("objc_sendReturnType", gst_sendMessageReturnType);
  proxy->defineCFunc ("objc_setIvarOOP", gst_setIvarOOP);
  proxy->defineCFunc ("objc_addMethod", gst_addMethod);
  proxy->defineCFunc ("objc_makeSmalltalk", gst_makeSmalltalk);
  proxy->defineCFunc ("objc_retain", gst_retain);
  proxy->defineCFunc ("objc_release", gst_release);
  proxy->defineCFunc ("objc_installSuspendLoop", gst_installSuspendLoop);
  proxy->defineCFunc ("gstRectFill", gst_rectFill);
  pool = [[NSAutoreleasePool alloc] init];
  NSLog (@"Load complete");
}

