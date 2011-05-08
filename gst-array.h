#import "gst-objc-ext.h"

@interface StArray : NSArray
{
  OOP stArray;
}
- (StArray*)initWithSmalltalk: (OOP)stValue;
- (OOP)getSmalltalk;
- (NSUInteger)count;
- (id) objectAtIndex: (NSUInteger)index;
@end
