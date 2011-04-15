#import "gst-objc-ext.h"
#import "LKObject.h"

@implementation NSView (gst)
- (NSRect *) gstBounds
{
  NSRect * rect = malloc (sizeof (NSRect));
  NSRect returnRect = [self bounds];

  rect->origin.x = returnRect.origin.x;
  rect->origin.y = returnRect.origin.y;
  rect->size.width = returnRect.size.width;
  rect->size.height = returnRect.size.height;
  return rect;
}
@end

void
gst_prepareArguments(OOP args, OOP recipient)
{
  
}


NSString *
gst_toNSString(char * string)
{
  return [NSString stringWithUTF8String: string];
}

void
gst_rectFill (NSRect * rect)
{
  NSRectFill (NSMakeRect (rect->origin.x, rect->origin.y, rect->size.width, rect->size.height));
}


