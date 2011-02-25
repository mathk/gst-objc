#ifdef __APPLE__
#import <Cocoa/Cocoa.h>

@interface NSWindow (gst)

- (id) initWithContentRectPointer: (NSRect*) rect styleMask: (NSUInteger) windowAtyle backing: (NSBackingStoreType) bufferingType defer: (BOOL)deferCreation;

@end

@interface NSView (gs)
- (NSRect*) gstBounds;
@end

void fillRed (id, SEL, NSRect);
void gst_rectFill (NSRect*);

#endif // __APPLE__
