#import "gst-string.h"

@implementation StString
- (NSUInteger)length
{
  return strlen (gst_proxy->OOPToString (stString));
}

- (unichar)characterAtIndex: (NSUInteger)index
{
  char * string = gst_proxy->OOPToString (stString);
  unichar returnValue = (unichar)string[index];
  return returnValue;
}

- (void)getCharacters: (unichar *)buffer range: (NSRange)aRange
{
  char * string = gst_proxy->OOPToString (stString);
  int currentLocation;
  for (currentLocation = aRange.location; currentLocation < aRange.location+aRange.length; currentLocation++)
    {
      unsigned short u = string[currentLocation];
      if (u == 0)
	break;
      buffer[currentLocation - aRange.location] = u;
    }
}

- (OOP)getSmalltalk
{
  return stString;
}

- (StString*)initWithSmalltalk: (OOP)stValue
{
  stString = stValue;
  return self;
}
@end
