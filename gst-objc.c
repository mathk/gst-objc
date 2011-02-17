#include <gstpub.h>
#include <objc/runtime.h>
//#include <stdio.h>
typedef double CGFloat;

//id objc_msg_Send (id, SEL, ...);
typedef struct _NSPoint {
      CGFloat x;
      CGFloat y;
} NSPoint;

typedef struct _NSSize {
      CGFloat width;
      CGFloat height;
} NSSize;

typedef struct _NSRect {
      NSPoint origin;
      NSSize size;
} NSRect;


NSRect*
make_rect (double x, double y, double w, double h)
{
  NSRect * newRect = malloc (sizeof (NSRect));
  newRect->origin.x = x;
  newRect->origin.y = y;
  newRect->size.width = w;
  newRect->size.height = h;
  return newRect;
}

void
gst_initModule (VMProxy * proxy)
{
  proxy->dlOpen ("libobjc", false);
  proxy->dlOpen ("Cocoa.framework/Cocoa", false);
  proxy->dlOpen ("Foundation.framework/Foundation", false);
  proxy->dlOpen ("CoreFoundation.framework/CoreFoundation", false);
  proxy->defineCFunc ("nsMakeRect", make_rect);
}

