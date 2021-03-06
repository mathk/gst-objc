#import "gst-objc.h"
#import <Foundation/Foundation.h>


@interface StProxy : NSObject  <SmalltalkProxy> {
  OOP stObject;
}
+ (StProxy*) allocWith: (OOP)stObject;
- (StProxy*) initWith:  (OOP)stObj;
- (OOP) getStObject;
- (void) forwardInvocation: (NSInvocation*) anInvocation;
- (BOOL) isStProxy;
@end

