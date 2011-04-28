#import "objc-proxy.h"

@implementation StProxy

+ (StProxy*) allocWith: (OOP)stObject
{
  return [[self alloc] initWith: stObject];
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
  for (i = 0; i < [sig numberOfArguments]; i++)
    {
      [anInvocation getArgument: (void*)argumentBuffer atIndex: i];
      gst_boxValue (argumentBuffer, args+i, [sig getArgumentTypeAtIndex: i]);
    }
  args[i] = NULL;

  OOP returnOOP = gst_proxy->vmsgSend (stObject, selector, args);
  gst_unboxValue (returnOOP, (void*)returnBuffer, [sig methodReturnType]);
  [anInvocation setReturnValue: (void*)returnBuffer];
}

@end
