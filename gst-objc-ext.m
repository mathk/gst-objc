#include <ffi.h>
#import "gst-objc-ext.h"
#import "LKObject.h"

ffi_type *_ffi_type_nspoint_elements[] = {
	&ffi_type_float, &ffi_type_float, NULL
};
ffi_type ffi_type_nspoint = {
	0, 0, FFI_TYPE_STRUCT, _ffi_type_nspoint_elements
};
ffi_type *_ffi_type_nsrect_elements[] = {
	&ffi_type_nspoint, &ffi_type_nspoint, NULL
};
ffi_type ffi_type_nsrect = {
	0, 0, FFI_TYPE_STRUCT, _ffi_type_nsrect_elements
};
#if NSUIntegerMax == ULONG_MAX
ffi_type *_ffi_type_nsrange_elements[] = {
	&ffi_type_ulong, &ffi_type_ulong, NULL
};
#else
ffi_type *_ffi_type_nsrange_elements[] = {
	&ffi_type_uint, &ffi_type_uint, NULL
};
#endif
ffi_type ffi_type_nsrange = {
	0, 0, FFI_TYPE_STRUCT, _ffi_type_nsrange_elements
};

@implementation NSView (gst)
- (NSRect *) gstBounds
{
  NSRect * rect = malloc (sizeof (NSRect));
  NSRect returnRect = [self bounds];

  rect->origin.x = returnRect.origin.x;
  rect->origin.y = returnRect.origin.y;
  rect->size.width = returnRect.size.width;
  rect->size.height = returnRect.size.height;
  return rect;
}
@end


void gst_SkipQualifiers(const char **typestr)
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
			if (0 == strncmp(typestr, "{_NSRect", 8))
			{
				return &ffi_type_nsrect;
			} 
			else if (0 == strncmp(typestr, "{_NSRange", 9))
			{
				return &ffi_type_nsrange;
			}
			else if (0 == strncmp(typestr, "{_NSPoint", 9))
			{
				return &ffi_type_nspoint;
			}
			else if (0 == strncmp(typestr, "{_NSSize", 8))
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
      /* Not supported for the time being
    case 'q':
      *(long long*)dest = gst_proxy->OOPToChar (value)(long long)value;
      break;
    case 'Q':
      *(unsigned long long*)dest = gst_proxy->OOPToChar (value)(unsigned long long)value;
      break;
      */
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
      if ([object class] == NSClassFromString ("StProxy"))
	{
	  *dest = [object getStObject];
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
      *dest = gst_proxy->stringToOOP (*(char**)value);;
      return;
    case '{':
      {
	*dest = gst_proxy->cObjectToOOP (value);
      }
    default:
      [NSException raise: @"Box" 
		  format: @"Unable to transmogriy object to"
	  "compound type: %s\n", objctype];
    }
}

void 
gst_unboxValue (OOP value, void *dest, const char *objctype)
{
  gst_SkipQualifiers (&objctype);
  
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
      /* Not supported for the time being
    case 'q':
      *(long long*)dest = gst_proxy->OOPToChar (value)(long long)value;
      break;
    case 'Q':
      *(unsigned long long*)dest = gst_proxy->OOPToChar (value)(unsigned long long)value;
      break;
      */
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
      *(SEL*)dest = (SEL) gst_proxy->OOPToCObject (value);
      break;
    /*case '(': TODO */
    case '^':
    case '#':
    case '@':
      if (gst_proxy->objectIsKindOf (value, gst_proxy->cObjectClass))
	{
	  *(id*)dest = (id) gst_proxy->OOPToCObject (value);
	}
      else
	{
	  *(id*)dest = [StProxy allocWith: value];
	}
      return;
    case 'v':
      *(id*)dest = NULL;
      return;
    case '*':
      *(char**)dest = gst_proxy->OOPToString (value);;
      return;
    case '{':
      {
	if (0 == strncmp(objctype, "{_NSRect", 8))
	  {
	    NSRect* v = (NSRect*) gst_proxy->OOPToCObject (value);
	    *(NSRect*)dest = *v;
	    break;
	  }
	else if (0 == strncmp(objctype, "{_NSRange", 9))
	  {
	    NSRange* v = (NSRange*) gst_proxy->OOPToCObject (value);
	    *(NSRange*)dest = *v;
	    break;
	  }
	else if (0 == strncmp(objctype, "{_NSPoint", 9))
	  {
	    NSPoint* v = (NSPoint*) gst_proxy->OOPToCObject (value);
	    *(NSPoint*)dest = *v;
	    break;
	  }
	else if (0 == strncmp(objctype, "{_NSSize", 8))
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
    return [sig methodReturnType];
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

NSString *
gst_toNSString(char * string)
{
  return [NSString stringWithUTF8String: string];
}

void
gst_rectFill (NSRect * rect)
{
  NSRectFill (NSMakeRect (rect->origin.x, rect->origin.y, rect->size.width, rect->size.height));
}


