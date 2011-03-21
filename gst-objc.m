#include <gstpub.h>
#include <gst-objc-ext.h>
//#define _NATIVE_OBJC_EXCEPTIONS
//#include <Foundation/Foundation.h>
#ifdef __APPLE__
#include <objc/runtime.h>
#endif
//#include <ffi.h>
//#include <stdio.h>

/*
 * This was taken and adapt from gnustep LanguageKit
 */
/*NSString *LKInterpreterException = @"LKInterpreterException";
static id BoxValue(void *value, const char *typestr);
static void UnboxValue(id value, void *dest, const char *objctype);

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

void LKSkipQualifiers(const char **typestr)
{
	char c = **typestr;
	while ((c >= '0' && c <= '9') || c == 'r' || c == 'n' || c == 'N' ||
		   c == 'o' || c == 'O' || c == 'R' || c == 'V')
	{
		(*typestr)++;
		c = **typestr;
	}
}

static ffi_type *FFITypeForObjCType(const char *typestr)
{
	LKSkipQualifiers(&typestr);

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
			[NSException raise: LKInterpreterException  
			            format: @"ObjC to FFI type conversion not supported for"
			                    "arbitrary structs"];
		}
		case 'v':
			return &ffi_type_void;
		case '(':
		case '^':
			if (strncmp(typestr, @encode(LKObjectPtr), strlen(@encode(LKObjectPtr))) != 0)
			{
				break;
			}
		case '@':
		case '#':
			return &ffi_type_pointer;
	}
	[NSException raise: LKInterpreterException  
	            format: @"ObjC to FFI type conversion not supported for '%c'",
	                    *typestr];
	return NULL;
}


#ifdef GNUSTEP
id
objc_msgSend(id receiver, SEL _cmd, ...)
{
  NSMethodSignature *sig = [receiver methodSignatureForSelector: sel];
  if (nil == sig)
    {
      [NSException raise: LKInterpreterException
		  format: @"Couldn't determine type for selector %@", selName];
    }
  // to be continue
}
#endif // GNUSTEP*/

void
gst_initModule (VMProxy * proxy)
{
#ifdef __APPLE__
  proxy->dlOpen ("libobjc", false);
  proxy->dlOpen ("Cocoa.framework/Cocoa", false);
#else // __APPLE__
  proxy->dlOpen ("libgnustep-base", false);
 // proxy->defineCFunc ("objc_msgSend", );
#endif  // __APPLE__
  proxy->defineCFunc ("fillRedCB", fillRed);
  proxy->defineCFunc ("gstRectFill", gst_rectFill);
  NSLog (@"Load complete");
}

