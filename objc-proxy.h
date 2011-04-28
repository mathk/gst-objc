#ifndef OBJC_PROXY_H
#define OBJC_PROXY_H

#import <Foundation/Foundation.h>
#include "gst-objc-ext.h"
#include <gstpub.h>

extern  VMProxy* gst_proxy;

@interface StProxy : NSObject {
  OOP stObject;
}
+ (StProxy*) allocWith: (OOP)stObject;
- (StProxy*) initWith:  (OOP)stObj;
- (OOP) getStObject;
- (void) forwardInvocation: (NSInvocation*) anInvocation; 
@end

#endif
