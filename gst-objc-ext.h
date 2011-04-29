
#include <gstpub.h>
#import <Cocoa/Cocoa.h>
#import "gst-objc.h"
#import "objc-proxy.h"
#ifndef GNU_RUNTIME
#import <objc/objc-runtime.h>
#endif

typedef struct gst_objc_object
{
  OBJ_HEADER;
  OOP objcPtr;
  OOP isClass;
}
 *gst_objc_object;

@interface NSView (gs)
- (NSRect*) gstBounds;
@end

void gst_retain(id object);
void gst_release(id object);
int gst_sizeofCGFloat();
NSString* gst_toNSString (char * string);
int gst_sendMessageReturnSize (id receiver, SEL selector);
char* gst_sendMessageReturnType (id receiver, SEL selector);
void gst_boxValue (void* value, OOP* dest, const char *objctype);
void gst_unboxValue (OOP value, void* dest, const char *objctype);
void gst_sendMessage(id receiver, SEL selector, int argc, OOP args, Class superClass, char* result);

