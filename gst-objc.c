#include <gstpub.h>
//#include <objc/runtime.h>
//#include <stdio.h>

//id objc_msg_Send (id, SEL, ...);

void
gst_initModule (VMProxy * proxy)
{
  proxy->dlOpen("libobjc", false);
  proxy->dlOpen("Foundation.framework/Foundation", false);

}

