#import <Cocoa/Cocoa.h>

#ifdef __APPLE__

@interface NSWindow (gst)

- (id) initWithContentRectPointer: (NSRect*) rect styleMask: (NSUInteger) windowAtyle backing: (NSBackingStoreType) bufferingType defer: (BOOL)deferCreation;

@end

#endif // __APPLE__
