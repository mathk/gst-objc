#include <ffi.h>
#import "gst-objc-ext.h"

pthread_mutex_t gstProxyMutex;
OOP gstObjcObjectClass;
OOP gstUnicodeString;

ffi_type *ffi_type_cgfloat;
ffi_type ffi_type_nspoint;
ffi_type ffi_type_nsrect;
ffi_type ffi_type_nsrange;
ffi_type *_ffi_type_nspoint_elements[3];
ffi_type *_ffi_type_nsrect_elements[3];
ffi_type *_ffi_type_nsrange_elements[3];


typedef struct objc_ffi_closure {
  ffi_closure closure;
  NSMethodSignature* sig;
  ffi_cif cif;
  ffi_type *return_type;
  ffi_type *arg_types[1];
}
  objc_ffi_closure;

@implementation NSObject (gst)
- (BOOL)isSmalltalk
{
  return NO;
}
@end

void gst_initThreading ()
{
  pthread_mutex_init (&gstProxyMutex, NULL);
}

void gst_initGlobal ()
{
  gstUnicodeString = gst_proxy->classNameToOOP("UnicodeString");
}

void gst_initFFIType ()
{
  ffi_type_cgfloat = (sizeof(CGFloat) == sizeof(double)) ? &ffi_type_double : &ffi_type_float;
  
  _ffi_type_nspoint_elements[0] = ffi_type_cgfloat;
  _ffi_type_nspoint_elements[1] = ffi_type_cgfloat;
  _ffi_type_nspoint_elements[2] = NULL;


  ffi_type_nspoint.size = 0;
  ffi_type_nspoint.alignment = 0;
  ffi_type_nspoint.type = FFI_TYPE_STRUCT;
  ffi_type_nspoint.elements = _ffi_type_nspoint_elements;

  _ffi_type_nsrect_elements[0] = &ffi_type_nspoint;
  _ffi_type_nsrect_elements[1] = &ffi_type_nspoint;
  _ffi_type_nsrect_elements[2] = NULL;
 
  ffi_type_nsrect.size = 0;
  ffi_type_nsrect.alignment = 0;
  ffi_type_nsrect.type = FFI_TYPE_STRUCT;
  ffi_type_nsrect.elements = _ffi_type_nsrect_elements;

#if NSUIntegerMax == ULONG_MAX
  _ffi_type_nsrange_elements[0] = &ffi_type_ulong;
  _ffi_type_nsrange_elements[1] = &ffi_type_ulong;
  _ffi_type_nsrange_elements[2] = NULL;
#else
  _ffi_type_nsrange_elements[0] = &ffi_type_uint;
  _ffi_type_nsrange_elements[1] = &ffi_type_uint;
  _ffi_type_nsrange_elements[2] = NULL;
#endif

  ffi_type_nsrange.size = 0;
  ffi_type_nsrange.alignment = 0;
  ffi_type_nsrange.type = FFI_TYPE_STRUCT;
  ffi_type_nsrange.elements = _ffi_type_nsrange_elements;

}

int
gst_sizeofCGFloat ()
{
  return sizeof (CGFloat);
}

void 
gst_SkipQualifiers(const char **typestr)
{
	char c = **typestr;
	while ((c >= '0' && c <= '9') || c == 'r' || c == 'n' || c == 'N' ||
		   c == 'o' || c == 'O' || c == 'R' || c == 'V')
	{
		(*typestr)++;
		c = **typestr;
	}
}

static ffi_type *
gst_FFITypeForObjCType(const char *typestr)
{
	gst_SkipQualifiers(&typestr);

	switch(*typestr)
	{
		case 'B':
		case 'c':
			return &ffi_type_schar;
		case 'C':
			return &ffi_type_uchar;
		case 's':
			return &ffi_type_sshort;
		case 'S':
			return &ffi_type_ushort;
		case 'i':
			return &ffi_type_sint;
		case 'I':
			return &ffi_type_uint;
		case 'l':
			return &ffi_type_slong;
		case 'L':
			return &ffi_type_ulong;
		case 'q':
			return &ffi_type_sint64;
		case 'Q':
			return &ffi_type_uint64;
		case 'f': 
			return &ffi_type_float;
		case 'd':
			return &ffi_type_double;
		case ':': 
			return &ffi_type_pointer;
		case '{':
		{
#ifdef GNU_RUNTIME
			if (0 == strncmp(typestr, "{_NSRect", 8))
#else
			if (0 == strcmp(typestr, @encode(NSRect)))
#endif
			{
				return &ffi_type_nsrect;
			} 
			else if (0 == strncmp(typestr, "{_NSRange", 9))
			{
				return &ffi_type_nsrange;
			}
#ifdef GNU_RUNTIME
			else if (0 == strncmp(typestr, "{_NSPoint", 9))
#else
			else if (0 == strcmp(typestr, @encode(NSPoint)))
#endif
			{
				return &ffi_type_nspoint;
			}
#ifdef GNU_RUNTIME
			else if (0 == strncmp(typestr, "{_NSSize", 8))
#else
			else if (0 == strcmp(typestr, @encode(NSSize)))
#endif
			{
				return &ffi_type_nspoint;
			}
			[NSException raise: @"Send"  
			            format: @"ObjC to FFI type conversion not supported for"
			                    "arbitrary structs"];
		}
		case 'v':
			return &ffi_type_void;
		case '(':
		case '^':
		case '@':
		case '#':
		case '*':
			return &ffi_type_pointer;
	}
	[NSException raise: @"Send"
	            format: @"ObjC to FFI type conversion not supported for '%c'",
	                    *typestr];
	return NULL;
}

void 
gst_boxValue (void* value, OOP* dest, const char *objctype)
{
  gst_SkipQualifiers (&objctype);
  unsigned short tmpUS;
  unsigned int tmpUI;
  id object;

  switch(*objctype)
    {
    case 'c':
    case 'C':
      *dest = gst_proxy->charToOOP (*(char*)value);
      break;
    case 's':
      *dest = gst_proxy->intToOOP (*(short*)value);
      break;
    case 'S':
      tmpUS = *(unsigned short*)value;
      *dest = gst_proxy->intToOOP (tmpUS);
      break;
    case 'i':
      *dest = gst_proxy->intToOOP (*(int*)value);
      break;
    case 'I':
      tmpUI = *(unsigned int*)value;
      *dest = gst_proxy->intToOOP (tmpUI);
      break;
    case 'l': /*Fix me, unsigned long is not correct */
    case 'L':
      *dest = gst_proxy->intToOOP (*(long*)value);
      break;
      /* Not supported for i386 the time being */
#ifdef __x86_64__
    case 'q':
      *(long long*)dest = (long long)gst_proxy->intToOOP (*(unsigned long long*)value);
      break;
    case 'Q':
      *(unsigned long long*)dest = (unsigned long long)gst_proxy->intToOOP (*(unsigned long long*)value);
      break;
#endif
    case 'f':
      *dest = gst_proxy->floatToOOP (*(float*)value);
      break;
    case 'd':
      *dest = gst_proxy->floatToOOP (*(double*)value);
      break;
    case 'B':
      *dest = gst_proxy->boolToOOP (*(BOOL*)value);
      break;
    case ':':
      *dest = (SEL) gst_proxy->cObjectToOOP (*(SEL*)value);
      break;
    /*case '(': TODO */
    case '^':
    case '#':
    case '@':
      object = *(id*)value;
      if ([object class] == NSClassFromString (@"StProxy"))
	{
	  *dest = [object getStObject];
	}
      else if ([object isSmalltalk])
	{
	  *dest = [object stObject];
	}
      else
	{
	  *dest = gst_proxy->cObjectToOOP (object);
	}
      return;
    case 'v':
      *dest = NULL;
      return;
    case '*':
      *dest = gst_proxy->stringToOOP (*(char**)value);
      return;
    case '{':
      *dest = gst_proxy->cObjectToOOP (value);
      return;
    default:
      [NSException raise: @"Box" 
		  format: @"Unable to transmogriy object to "
	  "compound type: %s\n", objctype];
    }
}

void 
gst_unboxValue (OOP value, void *dest, const char *objctype)
{
  gst_SkipQualifiers (&objctype);
  gst_objc_object objcObject;
  switch(*objctype)
    {
    case 'c':
      *(char*)dest = gst_proxy->OOPToChar (value);
      break;
    case 'C':
      *(unsigned char*)dest = (unsigned char) gst_proxy->OOPToChar (value);
      break;
    case 's':
      *(short*)dest = (short) gst_proxy->OOPToInt (value);
      break;
    case 'S':
      *(unsigned short*)dest = (unsigned short) gst_proxy->OOPToInt (value);
      break;
    case 'i':
      *(int*)dest = (int) gst_proxy->OOPToInt (value);
      break;
    case 'I':
      *(unsigned int*)dest = (unsigned int) gst_proxy->OOPToInt (value);
      break;
    case 'l':
      *(long*)dest = (long) gst_proxy->OOPToInt (value);
      break;
    case 'L':
      *(unsigned long*)dest = (unsigned long) gst_proxy->OOPToInt (value);
      break;
      /* Not supported for i386 the time being */
#ifdef __x86_64__
    case 'q':
      *(long long*)dest = (long long)gst_proxy->OOPToInt (value);
      break;
    case 'Q':
      *(unsigned long long*)dest = (unsigned long long)gst_proxy->OOPToInt (value);
      break;
#endif
    case 'f':
      *(float*)dest = (float) gst_proxy->OOPToFloat (value);
      break;
    case 'd':
      *(double*)dest = gst_proxy->OOPToFloat (value);
      break;
    case 'B':
      *(BOOL*)dest = (BOOL) gst_proxy->OOPToBool (value);
      break;
    case ':':
      if (gst_proxy->objectIsKindOf (value, gst_proxy->stringClass))
	{
	  char * selector = gst_proxy->OOPToString (value);
	  *(SEL*)dest = sel_getUid(selector);
	}
      else
	{
	  *(SEL*)dest = (SEL) gst_proxy->OOPToCObject (value);
	}
      break;
    /*case '(': TODO */
    case '^':
    case '#':
    case '@':
      if (NULL == gstObjcObjectClass)
	{
	  gstObjcObjectClass = gst_proxy->classNameToOOP("Objc.ObjcObject");
	}
      objcObject = (gst_objc_object) OOP_TO_OBJ (value);
      if (gst_proxy->objectIsKindOf (value, gstObjcObjectClass))
	{
	  *(id*)dest = (id) gst_proxy->OOPToCObject (objcObject->objcPtr);
	}
      else if (gst_proxy->objectIsKindOf (value, gst_proxy->cObjectClass))
	{
	  *(id*)dest = (id) gst_proxy->OOPToCObject (value);
	}
      else if (objcObject->objClass == gst_proxy->stringClass)
	{
	  *(id*)dest = [[StString alloc] initWithSmalltalk: value];
	}
      else if (objcObject->objClass == gst_proxy->arrayClass)
	{
	  *(id*)dest = [[StArray alloc] initWithSmalltalk: value];
	}
      else
	{
	  *(id*)dest = [StProxy allocWith: value];
	}
      break;
    case 'v':
      *(id*)dest = NULL;
      break;
    case '*':
      *(char**)dest = gst_proxy->OOPToString (value);
      break;;
    case '{':
      {
	if (0 == strcmp(objctype, @encode(NSRect)))
	  {
	    NSRect* v = (NSRect*) gst_proxy->OOPToCObject (value);
	    *(NSRect*)dest = *v;
	    break;
	  }
	else if (0 == strcmp(objctype, @encode(NSRange)))
	  {
	    NSRange* v = (NSRange*) gst_proxy->OOPToCObject (value);
	    *(NSRange*)dest = *v;
	    break;
	  }
	else if (0 == strcmp(objctype, @encode(NSPoint)))
	  {
	    NSPoint* v = (NSPoint*) gst_proxy->OOPToCObject (value);
	    *(NSPoint*)dest = *v;
	    break;
	  }
	else if (0 == strcmp(objctype, @encode(NSSize)))
	  {
	    NSSize* v = (NSSize*) gst_proxy->OOPToCObject (value);
	    *(NSSize*)dest = *v;
	    break;
	  }
      }
    default:
      [NSException raise: @"Unbox" 
		  format: @"Unable to transmogriy object to"
	  "compound type: %s\n", objctype];
    }
}

/* Return the length in byte of 
   the return object for a message send */
int
gst_sendMessageReturnSize (id receiver, SEL selector)
{
  NSMethodSignature *sig = [receiver methodSignatureForSelector: selector];
  return [sig methodReturnLength];
}

char*
gst_sendMessageReturnType (id receiver, SEL selector)
{
    NSMethodSignature *sig = [receiver methodSignatureForSelector: selector];
    return (char*)[sig methodReturnType];
}

/* Perform a Objective-C message send */
void
gst_sendMessage(id receiver, SEL selector, int argc, OOP args, Class superClass, char* result)
{
  void *methodIMP;
  if (receiver == nil)
    {
      return;
    }

  NSMethodSignature *sig = [receiver methodSignatureForSelector: selector];
  if (nil == sig)
    {
      [NSException raise: @"Send"
		  format: @"Couldn't determine type for selector %s", sel_getName(selector)];
    }
  if (argc + 2 != [sig numberOfArguments])
    {
      [NSException raise: @"Send"
		  format: @"Tried to call %s with %d arguments", sel_getName(selector), argc];
    }

#ifdef GNU_RUNTIME
  if (superClass)
    {
      if (class_isMetaClass(object_getClass(receiver)))
	{
	  superClass = object_getClass(superClass);
	}
      struct objc_super sup = { receiver, superClass };
      methodIMP = objc_msg_lookup_super(&sup, selector);
    }
  else
    {
      methodIMP = objc_msg_lookup(receiver, selector);
    }
#else // NOT GNU_RUNTIME
  if (superClass)
    {
      struct objc_super sup = {receiver, superClass};
      receiver = (id)&sup;
      switch (*[sig methodReturnType])
	{
	case '{':
	  methodIMP = objc_msgSendSuper_stret;
	  break;
	default:
	  methodIMP = objc_msgSendSuper;
	}
    }
  else
    {
      switch (*[sig methodReturnType])
	{
	case '{':
	  methodIMP = objc_msgSend_stret;
	  break;
#ifdef __i386__
	case 'f':
	case 'd':
	case 'D':
	  methodIMP = objc_msgSend_fpret;
	  break;
#endif // __i386__
#ifdef __x86_64__
	case 'D':
	  methodIMP = objc_msgSend_fpret;
	  break;
#endif // __x86_64__
	default:
	  methodIMP = objc_msgSend;
	}
    }
#endif // GNU_RUNTIME

  const char *returnObjCType = [sig methodReturnType];
  ffi_type *ffi_ret_type = gst_FFITypeForObjCType(returnObjCType);
  ffi_type *ffi_types[argc + 2];
  unsigned int i;
  for (i = 0; i < (argc + 2); i++)
    {
      const char *objCType = [sig getArgumentTypeAtIndex: i];
      ffi_types[i] = gst_FFITypeForObjCType(objCType);
    }

  ffi_cif cif;
  if (FFI_OK != ffi_prep_cif(&cif,  FFI_DEFAULT_ABI, argc + 2, ffi_ret_type, ffi_types))
    {
      [NSException raise: @"Send"
		  format: @"Error preparing call signature"];
    }
  char unboxedArgumentsBuffer[[sig numberOfArguments]][[sig frameLength]];
  void *unboxedArguments[[sig numberOfArguments]];
  unboxedArguments[0] = &receiver;
  unboxedArguments[1] = &selector;
  // My be need to register OOP
  gst_object argsArray = (gst_object)OOP_TO_OBJ (args);
  for (i = 0; i < argc; i++)
    {
      const char *objCType = [sig getArgumentTypeAtIndex: i + 2];
      gst_unboxValue(ARRAY_OOP_AT(argsArray, i+1), unboxedArgumentsBuffer[i + 2], objCType);
      unboxedArguments[i + 2] = unboxedArgumentsBuffer[i + 2];
    }

  //char msgSendRet[[sig methodReturnLength]];
  ffi_call(&cif, methodIMP, result, unboxedArguments);
  
  //return gst_boxValue(msgSendRet, [sig methodReturnType]);
}

static void
gst_closureTrampolineMethod (ffi_cif* cif, void* result, void** args, void* userdata)
{
  objc_ffi_closure* closure = userdata;
  NSMethodSignature* sig = closure->sig;
  OOP argsOOP[[sig numberOfArguments]+1];
  OOP selector = gst_proxy->symbolToOOP(sel_getName(*((SEL*)args[1])));
  OOP resultOOP;
  OOP receiver;
  int i;
  id objcReceiver = *((id*)args[0]);


  Ivar var = class_getInstanceVariable([objcReceiver class], "stObject");

  ptrdiff_t diff = ivar_getOffset(var);
  receiver = *(OOP*)((ptrdiff_t)objcReceiver+diff);


  for (i = 0; i < [sig numberOfArguments]-2; i++)
    {
      gst_boxValue (args[i+2], argsOOP+i, [sig getArgumentTypeAtIndex: i+2]);
    }
  argsOOP[i] = NULL;
  GST_LOCK_PROXY;
  resultOOP = gst_proxy->vmsgSend (receiver, selector, argsOOP);
  GST_UNLOCK_PROXY;
  gst_unboxValue (resultOOP, result, [sig methodReturnType]);

}

void
gst_addMethodIntern (Class cls, SEL selector, const char * typeStr)
{
  objc_ffi_closure* closure;
  void* code;
  int i;
  NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes: typeStr];
  int argc = [sig numberOfArguments];

  [sig retain];
  closure = (objc_ffi_closure*)ffi_closure_alloc (sizeof (objc_ffi_closure)  + sizeof(ffi_type *) * (argc - 1), &code);
  for (i = 0; i < argc; i++)
    {
      const char *objCType = [sig getArgumentTypeAtIndex: i];
      closure->arg_types[i] = gst_FFITypeForObjCType(objCType);
    }

  
  closure->return_type = gst_FFITypeForObjCType([sig methodReturnType]);
  closure->sig = sig;
  ffi_prep_cif (&closure->cif, FFI_DEFAULT_ABI, argc, closure->return_type, closure->arg_types);
  ffi_prep_closure_loc (&closure->closure, &closure->cif, gst_closureTrampolineMethod, closure, code);
  
  BOOL result = class_addMethod (cls, selector, (IMP)code, typeStr);
  if (NO == result)
    {
      [NSException raise: @"Closure"
		  format: @"Fail adding method %s", selector];
    }
}

void
gst_addMethod(char * selector, Class cls, const char * typeStr)
{
  char* typesEncoding[10];
  NSMethodSignature* sig;
  SEL cmd = sel_getUid (selector);
  if (NULL != typeStr)
    {
      gst_addMethodIntern (cls, cmd, typeStr);
      
    }
  else
    {
#ifdef GNU_RUNTIME
      int i;
      char ** buffer = typesEncoding;
      int exist = sel_copyTypes_np (selector, buffer, sizeof(typesEncoding));
      if (exist > sizeof(typesEncoding))
	{
	  buffer = calloc (exist, sizeof(char*));
	  sel_copyTypes_np (selector, buffer, exist);
	}
      
      for (i = 0; i < exist; i++)
	{
	  sig = [NSMethodSignature signatureWithObjCTypes: buffer[i]];
	  gst_addMethodIntern (cls, cmd, buffer[i]);
	  
	}
      if (exist > sizeof(typesEncoding))
	{
	  free (buffer);
	}
#else
      Method mth = class_getInstanceMethod (cls, sel_registerName (selector));
      if (mth == NULL)
	{
	  [NSException raise: @"Closure"
		  format: @"Fail adding method %s, unable to get type encoding", selector];
	}
      gst_addMethodIntern (cls, cmd, method_getTypeEncoding(mth));
#endif
    }
}

BOOL
gst_isSmalltalk (id self, SEL _cmd)
{
  return YES;
}

OOP
gst_stObject (id self, SEL _cmd)
{
  Ivar var = class_getInstanceVariable ([self class], "stObject");

  ptrdiff_t diff = ivar_getOffset(var);
  return *(OOP*)((ptrdiff_t)self+diff);
}

void
gst_makeSmalltalk (Class cls)
{
  BOOL result = class_addMethod (cls, @selector(isSmalltalk), (IMP)gst_isSmalltalk, "C@:");
  if (NO == result)
    {
      [NSException raise: @"Closure"
		  format: @"Fail adding method isSmalltalk"];
    }
  result = class_addMethod (cls, @selector(stObject), (IMP)gst_stObject, "^c@:");
  if (NO == result)
    {
      [NSException raise: @"Closure"
		  format: @"Fail adding method stObject"];
    }
}

void
gst_retain(id object)
{
#ifdef __APPLE__
  CFRetain(object);
#else
  [object retain];
#endif
}

void
gst_release(id object)
{
#ifdef __APPLE__
  CFRelease(object);
#else
  [object release];
#endif
}

void
gst_rectFill (NSRect * rect)
{
  NSRectFill (NSMakeRect (rect->origin.x, rect->origin.y, rect->size.width, rect->size.height));
}

void
gst_setIvarOOP(id receiver, const char * name, OOP value)
{
  Ivar var = class_getInstanceVariable ([receiver class], name);

  ptrdiff_t diff = ivar_getOffset(var);
  *(OOP*)((ptrdiff_t)receiver+diff) = value;

}

