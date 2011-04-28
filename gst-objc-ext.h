#ifndef GST_OBJC_EXT_H
#define GST_OBJC_EXT_H

#include <gstpub.h>
#import <Cocoa/Cocoa.h>
#import "objc-proxy.h"

extern  VMProxy* gst_proxy;


typedef union ObjcType {
  id idType;
  BOOL boolType;
  unsigned char ucharType;
  short shortType;
  unsigned short ushortType;
  int intType;
  unsigned int uintType;
  long longType;
  unsigned long ulongType;
  // long long longlongType;
  // unsigned long long ulonglongType;
  // float floatTYpe;
  // double doubleType;
  SEL selType;
} ObjcType;

@interface NSView (gs)
- (NSRect*) gstBounds;
@end

/* Build a NSString from  a C string */
void gst_retain(id object);
void gst_release(id object);
NSString* gst_toNSString (char * string);
void gst_prepareArguments(OOP args, OOP recipient);
int gst_sendMessageReturnSize (id receiver, SEL selector);
char* gst_sendMessageReturnType (id receiver, SEL selector);
void gst_boxValue (void* value, OOP* dest, const char *objctype);
void gst_unboxValue (OOP value, void* dest, const char *objctype);
void gst_sendMessage(id receiver, SEL selector, int argc, OOP args, Class superClass, char* result);

#endif
