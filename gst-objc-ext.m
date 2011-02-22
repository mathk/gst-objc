#import "gst-objc-ext.h"

#ifdef __APPLE__

@implementation NSWindow (gst)

- (id) initWithContentRectPointer: (NSRect*) rect styleMask: (NSUInteger) windowAtyle backing: (NSBackingStoreType) bufferingType defer: (BOOL)deferCreation
{
  return [self initWithContentRect: NSMakeRect (rect->origin.x, rect->origin.y, rect->size.width, rect->size.height) 
			     styleMask: windowAtyle 
			       backing: bufferingType 
			     defer: deferCreation];
}
@end
#endif // __APPLE__
