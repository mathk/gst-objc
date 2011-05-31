#include <gstpub.h>
#import <Cocoa/Cocoa.h>
#import "gst-objc.h"
#import "gst-string.h"
#import "gst-array.h"
#import "objc-proxy.h"
#ifndef GNU_RUNTIME
#import <objc/objc-runtime.h>
#endif

@interface NSObject (gst)
- (BOOL)isSmalltalk;
- (BOOL)isStProxy;
@end

@interface NSApplication (gst)
- (BOOL) setRunning;
@end

typedef struct gst_objc_object
{
  OBJ_HEADER;
  OOP objcPtr;
  OOP isClass;
}
 *gst_objc_object;

/* Initialize threading object */
void gst_initThreading ();

/* Initialize ffi type */
void gst_initFFIType ();

/* Initialize some variables */
void gst_initGlobal ();

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
void gst_addMethod(char * selector, Class cls, const char * typeStr);

/* Convert from smalltalk to ObjC*/
void gst_boxValue (void* value, OOP* dest, const char *objctype);

/* Convert from ObjC to smalltalk */
void gst_unboxValue (OOP value, void* dest, const char *objctype);

/* Send a message to an ObjC object */
void gst_sendMessage(id receiver, SEL selector, int argc, OOP args, Class superClass, char* result);

/* Make a sublcass behave as a smalltalk object. Especialy when
   returning this object into smalltalk */
void gst_makeSmalltalk (Class cls);

/* Add a setter to a instance variable of an objc object */
void gst_addSetter (char * iVarName, char * setterName, Class cls, const char * typeStr);

/* Add a getter to a instance variable of an objc object */
void gst_addGetter (char * iVarName, char * getterName, Class cls, const char * typeStr);

/* Speciall getter for the hidden ivar of objective-c object that is
   an instance of a subclass declare in smalltalk */
void gst_addStObjectGetter (Class cls);

/* install the hook for idle task */
void gst_installSuspendLoop ();
