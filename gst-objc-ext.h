#include <gstpub.h>
#import <Cocoa/Cocoa.h>
#import "LKObject.h"

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
ObjcType gst_sendMessage(id receiver, SEL selector, int argc, id* args, Class superClass);
