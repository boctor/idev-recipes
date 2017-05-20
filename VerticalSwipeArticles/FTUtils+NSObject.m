/*
 The MIT License
 
 Copyright (c) 2009 Free Time Studios and Nathan Eror
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

#import "FTUtils+NSObject.h"

@implementation NSObject (FTUtilsAdditions)

- (void)performSelector:(SEL)selector andReturnTo:(void *)returnData withArguments:(void **)arguments {
  NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  [invocation setSelector:selector];
  
  NSUInteger argCount = [methodSignature numberOfArguments];
  
  for (int i=2; i < argCount; i++) {
    void *arg = arguments[i-2];
    [invocation setArgument:arg atIndex:i];
  }
  
  [invocation invokeWithTarget:self];
  if(returnData != NULL) {
    [invocation getReturnValue:returnData];
  }
}

- (void)performSelector:(SEL)selector withArguments:(void **)arguments {
  [self performSelector:selector andReturnTo:NULL withArguments:arguments];
}

- (void)performSelectorIfExists:(SEL)selector andReturnTo:(void *)returnData withArguments:(void **)arguments {
  if([self respondsToSelector:selector]) {
    [self performSelector:selector andReturnTo:returnData withArguments:arguments];
  }
}

- (void)performSelectorIfExists:(SEL)selector withArguments:(void **)arguments {
  [self performSelectorIfExists:selector andReturnTo:NULL withArguments:arguments];
}

@end

@implementation NSArray (FTUtilsAdditions)

- (NSArray *)reversedArray {
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
  NSEnumerator *enumerator = [self reverseObjectEnumerator];
  for (id element in enumerator) {
    [array addObject:element];
  }
  return [NSArray arrayWithArray:array];
}

@end

@implementation NSMutableArray (FTUtilsAdditions)

- (void)reverse {
  NSUInteger i = 0;
  NSUInteger j = [self count] - 1;
  while (i < j) {
    [self exchangeObjectAtIndex:i withObjectAtIndex:j];
    i++;
    j--;
  }
}

@end
