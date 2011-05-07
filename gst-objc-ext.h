
#include <gstpub.h>
#import <Cocoa/Cocoa.h>
#import "gst-objc.h"
#import "gst-string.h"
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


void gst_initFFIType ();
void gst_retain(id object);
void gst_release(id object);
int gst_sizeofCGFloat();
void gst_setIvarOOP(id receiver, const char * name, OOP value);
void gst_rectFill (NSRect * rect);
int gst_sendMessageReturnSize (id receiver, SEL selector);
char* gst_sendMessageReturnType (id receiver, SEL selector);
void gst_addMethod(char * selector, Class cls, char * typeStr);
void gst_boxValue (void* value, OOP* dest, const char *objctype);
void gst_unboxValue (OOP value, void* dest, const char *objctype);
void gst_sendMessage(id receiver, SEL selector, int argc, OOP args, Class superClass, char* result);

