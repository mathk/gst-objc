#import "objc-proxy.h"
#import "gst-objc-ext.h"

extern VMProxy* gst_proxy;

@implementation StProxy

+ (StProxy*) allocWith: (OOP)stObject
{
  return [[self alloc] initWith: stObject];
}

- (BOOL)isStProxy
{
  return YES;
}

- (OOP) getStObject
{
  return stObject;
}

- (StProxy*) initWith: (OOP)stObj
{
  stObject = stObj;
  return self;
}

- (void) forwardInvocation: (NSInvocation*) anInvocation
{
  OOP selector = gst_proxy->symbolToOOP(sel_getName([anInvocation selector]));
  NSMethodSignature* sig = [anInvocation methodSignature];
  if (sig == nil)
    {
      [NSException raise: @"Proxy" 
		  format: @"Couldn't determine type for selector %s", sel_getName([anInvocation selector])];
    }

  OOP args[[sig numberOfArguments] + 1];
  char argumentBuffer[[sig frameLength]];
  char returnBuffer[[sig frameLength]];
  int i;
  for (i = 0; i < [sig numberOfArguments]-2; i++)
    {
      [anInvocation getArgument: (void*)argumentBuffer atIndex: i+2];
      gst_boxValue (argumentBuffer, args+i, [sig getArgumentTypeAtIndex: i+2]);
    }
  args[i] = NULL;
  
  GST_LOCK_PROXY;
  OOP returnOOP = gst_proxy->vmsgSend (stObject, selector, args);
  GST_UNLOCK_PROXY;

  gst_unboxValue (returnOOP, (void*)returnBuffer, [sig methodReturnType]);
  [anInvocation setReturnValue: (void*)returnBuffer];
}

@end
