#import "gst-array.h"

@implementation StArray
- (BOOL)isStProxy
{
  return YES;
}

- (OOP)getStObject
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

  gst_object array = (gst_object)OOP_TO_OBJ (stArray);
  OOP value = ARRAY_OOP_AT(array, index+1);
  id returnValue;
  /* No primitive type is suported for the time being */
  gst_unboxValue(value, &returnValue, "@");
  return returnValue;
}
@end
