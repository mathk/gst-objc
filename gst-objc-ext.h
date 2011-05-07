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

/* Initialize ffi type */
void gst_initFFIType ();

/* Retain ObjC object */
void gst_retain(id object);

/* Release ObjC object */
void gst_release(id object);

/* Return number of byte of a CGFlaot */
int gst_sizeofCGFloat();

/* Set the smalltalk object of a ObjC proxy */
void gst_setIvarOOP(id receiver, const char * name, OOP value);

/* Fill a NSRect with the current NSColor.  This is needed since gst
   ccall out does not suport struct */
void gst_rectFill (NSRect * rect);

/* Return the size of the return value for a given message */
int gst_sendMessageReturnSize (id receiver, SEL selector);

/* Return the string encode of the return value */
char* gst_sendMessageReturnType (id receiver, SEL selector);

/* Add a method to smalltalk object.  This create a call into
   smalltalk whenever a message is send to the ObjC object */
void gst_addMethod(char * selector, Class cls, char * typeStr);

/* Convert from smalltalk to ObjC*/
void gst_boxValue (void* value, OOP* dest, const char *objctype);

/* Convert from ObjC to smalltalk */
void gst_unboxValue (OOP value, void* dest, const char *objctype);

/* Send a message to an ObjC object */
void gst_sendMessage(id receiver, SEL selector, int argc, OOP args, Class superClass, char* result);

