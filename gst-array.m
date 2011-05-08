#import "gst-array.h"

@implementation StArray
- (OOP)getSmalltalk
{
  return stArray;
}

- (StArray*)initWithSmalltalk: (OOP)stValue
{
  stArray = stValue;
  return self;
}

- (NSUInteger)count
{
  return gst_proxy->basicSize(stArray);
}

- (id) objectAtIndex: (NSUInteger)index
{
  if (index >= [self count])
    [NSRangeException raise: @"StArray"
		     format: @"Index is out of bound: %d", index];

  OOP value = arrayOOPAt(stArray, index+1);
  id returnValue;
  /* No primitive type is suported for the time being */
  gst_unboxValue(value, &returnValue, "@");
  return returnValue;
}
@end
