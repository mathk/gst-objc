#import "gst-objc-ext.h"

@interface StString : NSString
{
  OOP stString;
}
- (StString*)initWithSmalltalk: (OOP)stValue;
- (OOP)getSmalltalk;
- (NSUInteger)length;
- (unichar)characterAtIndex: (NSUInteger)index;
- (void)getCharacters: (unichar *)buffer range: (NSRange)aRange;
@end
