
#import "gst-objc-ext.h"
#import <Foundation/Foundation.h>


@interface StProxy : NSObject {
  OOP stObject;
}
+ (StProxy*) allocWith: (OOP)stObject;
- (StProxy*) initWith:  (OOP)stObj;
- (OOP) getStObject;
- (void) forwardInvocation: (NSInvocation*) anInvocation; 
@end

