/*
 The MIT License
 
 Copyright (c) 2011 Free Time Studios and Nathan Eror
 
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

#if NS_BLOCKS_AVAILABLE

typedef void (^FTGestureActionBlock)(id recognizer);

/**
 This category defines methods and properties which allow the use of blocks 
 for working with `UIGestureRecognizer` and its subclasses.
 
 For more information on working with gestures in iOS, see Apple's 
 [Event Handling Guide for iOS][1].
 
 [1]:http://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Introduction/Introduction.html
 */
@interface UIGestureRecognizer(FTBlockAdditions)

#pragma mark - Creating a block based Gesture Recognizer

///---------------------------------------------------------------------------
/// @name Creating a block based Gesture Recognizer
///---------------------------------------------------------------------------

/**
 Creates an autoreleased instance of a `UIGestureRecognizer` subclass with
 its actionBlock set to `nil`.
 
 @warning *Important:* Until the actionBlock is set, the returned object will do nothing.
 
 @return An instance of a `UIGestureRecognizer` subclass.
 @see actionBlock
 */
+ (id)recognizer;

/**
 Creates an autoreleased instance of a `UIGestureRecognizer` subclass which
 uses _action_ to handle gesture actions.
 
 @return An instance of a `UIGestureRecognizer` subclass.
 @param action A block which will handle the gesture actions.
 @see actionBlock
 */
+ (id)recognizerWithActionBlock:(FTGestureActionBlock)action;

#pragma mark - Setting and getting the action handler blocks

///---------------------------------------------------------------------------
/// @name Setting and getting the action handler blocks
///---------------------------------------------------------------------------

/**
 A block to be executed when a `UIGestureRecognizer` action is fired. 
 
 The block is passed a single parameter which is the `UIGestureRecognizer`
 instance for this property.
 */
@property (copy) FTGestureActionBlock actionBlock;

/**
 A property indicating that the block should *not* be called when
 the recognizer fires.
 
 Useful if you need to temporarily disable an action but you still 
 want the block to be around later on.
*/
@property (nonatomic, assign) BOOL disabled;

@end

#endif