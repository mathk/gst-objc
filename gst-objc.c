#include <gstpub.h>
//#include <objc/runtime.h>
//#include <stdio.h>

//id objc_msg_Send (id, SEL, ...);

int
gst_NSApplicationMain()
{
  char args[] =  {"gst-cocoa"};
  char **argv = &args;
  return NSApplicationMain(1, argv);
}

void
gst_initModule (VMProxy * proxy)
{
  proxy->dlOpen ("libobjc", false);
  proxy->dlOpen ("Cocoa.framework/Cocoa", false);
  proxy->defineCFunc ("NSApplicationMain", gst_NSApplicationMain);

}

