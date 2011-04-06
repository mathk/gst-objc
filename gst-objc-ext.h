//#ifdef __APPLE__
#import <Cocoa/Cocoa.h>
#import "LKObject.h"

@interface NSWindow (gst)

- (id) initWithContentRectPointer: (LKObjectPtr) rect styleMask: (NSUInteger) windowAtyle backing: (NSBackingStoreType) bufferingType defer: (BOOL)deferCreation;

@end

@interface NSView (gs)
- (NSRect*) gstBounds;
@end

void fillRed (id, SEL, NSRect);
void gst_rectFill (NSRect*);
NSString* toNSString (char * string);

//#endif // __APPLE__
