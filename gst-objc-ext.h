#include <gstpub.h>
#import <Cocoa/Cocoa.h>
#import "LKObject.h"


@interface NSView (gs)
- (NSRect*) gstBounds;
@end

/* Build a NSString from  a C string */
NSString* gst_toNSString (char * string);
void gst_prepareArguments(OOP args, OOP recipient);
