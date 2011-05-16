#import "gst-objc.h"

@interface StArray : NSArray <SmalltalkProxy>
{
  OOP stArray;
}
- (StArray*)initWithSmalltalk: (OOP)stValue;
- (BOOL)isStProxy;
- (OOP)getStObject;
- (NSUInteger)count;
- (id) objectAtIndex: (NSUInteger)index;
@end
