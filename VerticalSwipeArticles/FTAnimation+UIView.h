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

#import "FTAnimationManager.h"

/**
 This category provides extra methods on `UIView` which make it very easy to use
 the FTAnimationManager pre-built animations.
*/
@interface UIView (FTAnimationAdditions)

///---------------------------------------------------------------------------
/// @name Sliding the view on and off the screen
///---------------------------------------------------------------------------

/**
 Slides the view in from the *direction* edge or corner of the screen.
 
 @param direction The edge or corner of the screen where animation will originate.
 @param duration The duration (in seconds) of the animation.
 @param delegate The *delegate* will be forwarded the standard `CAAnimationDelegate`
 methods.
*/
- (void)slideInFrom:(FTAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate;

/**
 Slides the view in from a specified edge or corner of the screen.
 
 @param direction The edge or corner of the screen where animation will originate.
 @param duration The duration (in seconds) of the animation.
 @param delegate An object on which to send the *startSelector* and *stopSelector*
 messages. The animation framework _does not_ retain *delegate*. If it is `nil`, 
 neither message will be sent.
 @param startSelector A selector to be messaged on *delegate* right before the start 
 of the animation. This parameter can be `nil`.
 @param startSelector A selector to be messaged on *delegate* after the animation has
 finished normally or been cancelled. This parameter can be `nil`.
*/
- (void)slideInFrom:(FTAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate 
      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Slides the view out to the *direction* edge or corner of the screen.
 
 @param direction The edge or corner of the screen where animation will end.
 @param duration The duration (in seconds) of the animation.
 @param delegate The *delegate* will be forwarded the standard `CAAnimationDelegate`
 methods.
*/
- (void)slideOutTo:(FTAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate;

/**
 Slides the view out to a specified edge or corner of the screen.
 
 @param direction The edge or corner of the screen where animation will end.
 @param duration The duration (in seconds) of the animation.
 @param delegate An object on which to send the *startSelector* and *stopSelector*
 messages. The animation framework _does not_ retain *delegate*. If it is `nil`, 
 neither message will be sent.
 @param startSelector A selector to be messaged on *delegate* right before the start 
 of the animation. This parameter can be `nil`.
 @param startSelector A selector to be messaged on *delegate* after the animation has
 finished normally or been cancelled. This parameter can be `nil`.
*/
- (void)slideOutTo:(FTAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate 
     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/** Slides the view in from the *direction* edge or corner of the *enclosingView*. */
- (void)slideInFrom:(FTAnimationDirection)direction inView:(UIView*)enclosingView duration:(NSTimeInterval)duration delegate:(id)delegate 
      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/** Slides the view out of the *enclosingView* to the *direction* edge or corner. */
- (void)slideOutTo:(FTAnimationDirection)direction inView:(UIView*)enclosingView duration:(NSTimeInterval)duration 
          delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Backs the view out to a specified edge or corner of the screen. The view will make a
 slight movement in the opposite *direction* before sliding offscreen.
 
 @param direction The edge or corner of the screen where animation will end.
 @param duration The duration (in seconds) of the animation.
 @param delegate The *delegate* will be forwarded the standard `CAAnimationDelegate`
 methods.
*/
- (void)backOutTo:(FTAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate;

/**
 Backs the view out to a specified edge or corner of the screen. The view will make a
 slight movement in the opposite *direction* before sliding offscreen.
 
 @param direction The edge or corner of the screen where animation will originate.
 @param duration The duration (in seconds) of the animation.
 @param delegate An object on which to send the *startSelector* and *stopSelector*
 messages. The animation framework _does not_ retain *delegate*. If it is `nil`, 
 neither message will be sent.
 @param startSelector A selector to be messaged on *delegate* right before the start 
 of the animation. This parameter can be `nil`.
 @param startSelector A selector to be messaged on *delegate* after the animation has
 finished normally or been cancelled. This parameter can be `nil`.
*/
- (void)backOutTo:(FTAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
    startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Backs the view in from a specified edge or corner of the screen. The view will make a
 slight movement in the opposite *direction* before sliding onscreen.
 
 @param direction The edge or corner of the screen where animation will end.
 @param duration The duration (in seconds) of the animation.
 @param delegate The *delegate* will be forwarded the standard `CAAnimationDelegate`
 methods.
*/
- (void)backInFrom:(FTAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate;

/**
 Backs the view in from a specified edge or corner of the screen. The view will make a
 slight movement in the opposite *direction* before sliding onscreen.
 
 @param direction The edge or corner of the screen where animation will originate.
 @param duration The duration (in seconds) of the animation.
 @param delegate An object on which to send the *startSelector* and *stopSelector*
 messages. The animation framework _does not_ retain *delegate*. If it is `nil`, 
 neither message will be sent.
 @param startSelector A selector to be messaged on *delegate* right before the start 
 of the animation. This parameter can be `nil`.
 @param startSelector A selector to be messaged on *delegate* after the animation has
 finished normally or been cancelled. This parameter can be `nil`.
*/
- (void)backInFrom:(FTAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/** 
 Backs the view off of a specified edge or corner of the *enclosingView*. The view will
 make a slight movement in the opposite *direction* before sliding off of the *enclosingView*.
*/
- (void)backOutTo:(FTAnimationDirection)direction inView:(UIView*)enclosingView withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
    startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/** 
 Backs the view in from a specified edge or corner of the *enclosingView*. The view will
 make a slight movement in the opposite *direction* before sliding over the *enclosingView*.
*/
- (void)backInFrom:(FTAnimationDirection)direction inView:(UIView*)enclosingView withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

///---------------------------------------------------------------------------
/// @name Fading the view in and out
///---------------------------------------------------------------------------

/**
 Causes the view to fade in from invisible to fully opaque.
 
 @param direction The edge or corner of the screen where animation will end.
 @param duration The duration (in seconds) of the animation.
 @param delegate The *delegate* will be forwarded the standard `CAAnimationDelegate`
 methods.
*/
- (void)fadeIn:(NSTimeInterval)duration delegate:(id)delegate;

/**
 Causes the view to fade in from invisible to fully opaque.
 
 @param duration The duration (in seconds) of the animation.
 @param delegate An object on which to send the *startSelector* and *stopSelector*
 messages. The animation framework _does not_ retain *delegate*. If it is `nil`, 
 neither message will be sent.
 @param startSelector A selector to be messaged on *delegate* right before the start 
 of the animation. This parameter can be `nil`.
 @param startSelector A selector to be messaged on *delegate* after the animation has
 finished normally or been cancelled. This parameter can be `nil`.
*/
- (void)fadeIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Causes the view to fade out until it is invisible.
 
 @param direction The edge or corner of the screen where animation will end.
 @param duration The duration (in seconds) of the animation.
 @param delegate The *delegate* will be forwarded the standard `CAAnimationDelegate`
 methods.
*/
- (void)fadeOut:(NSTimeInterval)duration delegate:(id)delegate;

/**
 Causes the view to fade out until it is invisible.
 
 @param duration The duration (in seconds) of the animation.
 @param delegate An object on which to send the *startSelector* and *stopSelector*
 messages. The animation framework _does not_ retain *delegate*. If it is `nil`, 
 neither message will be sent.
 @param startSelector A selector to be messaged on *delegate* right before the start 
 of the animation. This parameter can be `nil`.
 @param startSelector A selector to be messaged on *delegate* after the animation has
 finished normally or been cancelled. This parameter can be `nil`.
*/
- (void)fadeOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Causes the background color of the view to fade in from invisible to completely
 opaque.
 
 @param direction The edge or corner of the screen where animation will end.
 @param duration The duration (in seconds) of the animation.
 @param delegate The *delegate* will be forwarded the standard `CAAnimationDelegate`
 methods.
*/
- (void)fadeBackgroundColorIn:(NSTimeInterval)duration delegate:(id)delegate;

/**
 Causes the background color of the view to fade in from invisible to completely
 opaque.
 
 @param duration The duration (in seconds) of the animation.
 @param delegate An object on which to send the *startSelector* and *stopSelector*
 messages. The animation framework _does not_ retain *delegate*. If it is `nil`, 
 neither message will be sent.
 @param startSelector A selector to be messaged on *delegate* right before the start 
 of the animation. This parameter can be `nil`.
 @param startSelector A selector to be messaged on *delegate* after the animation has
 finished normally or been cancelled. This parameter can be `nil`.
*/
- (void)fadeBackgroundColorIn:(NSTimeInterval)duration delegate:(id)delegate 
                startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Causes the background color of the view to fade out until it is invisible.
 
 @param direction The edge or corner of the screen where animation will end.
 @param duration The duration (in seconds) of the animation.
 @param delegate The *delegate* will be forwarded the standard `CAAnimationDelegate`
 methods.
*/
- (void)fadeBackgroundColorOut:(NSTimeInterval)duration delegate:(id)delegate;

/**
 Causes the background color of the view to fade out until it is invisible.
 
 @param duration The duration (in seconds) of the animation.
 @param delegate An object on which to send the *startSelector* and *stopSelector*
 messages. The animation framework _does not_ retain *delegate*. If it is `nil`, 
 neither message will be sent.
 @param startSelector A selector to be messaged on *delegate* right before the start 
 of the animation. This parameter can be `nil`.
 @param startSelector A selector to be messaged on *delegate* after the animation has
 finished normally or been cancelled. This parameter can be `nil`.
*/
- (void)fadeBackgroundColorOut:(NSTimeInterval)duration delegate:(id)delegate 
                 startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;


///---------------------------------------------------------------------------
/// @name Scaling the view up and down
///---------------------------------------------------------------------------

/** 
 Pops the view in from the center of the screen similar to the animation of a `UIAlertView`. 
 The view will start invisible and small in the center of the screen, and it will be animated
 to its final size with a rubber band bounce at the end.
*/
- (void)popIn:(NSTimeInterval)duration delegate:(id)delegate;

/** 
 Pops the view in from the center of the screen similar to the animation of a `UIAlertView`. 
 The view will start invisible and small in the center of the screen, and it will be animated
 to its final size with a rubber band bounce at the end.
*/
- (void)popIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/** 
 This is the reverse of the *popIn* animation. The view will scale to a slightly larger size
 before shrinking to nothing in the middle of the screen.
*/
- (void)popOut:(NSTimeInterval)duration delegate:(id)delegate;

/** 
 This is the reverse of the *popIn* animation. The view will scale to a slightly larger size
 before shrinking to nothing in the middle of the screen.
*/
- (void)popOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 The view will fade in and shrink from double its size down to its regular size. This makes
 it appear as though the view is falling onto the screen from the user's vantage point.
*/
- (void)fallIn:(NSTimeInterval)duration delegate:(id)delegate;

/**
 The view will fade in and shrink from double its size down to its regular size. This makes
 it appear as though the view is falling onto the screen from the user's vantage point.
*/
- (void)fallIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;
/**
 The view will shrink to nothing in the middle of the screen and disappear.
*/
- (void)fallOut:(NSTimeInterval)duration delegate:(id)delegate;

/**
 The view will shrink to nothing in the middle of the screen and disappear.
 */
- (void)fallOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/** 
 The view will scale up to twice its size while fading to invisible.
*/
- (void)flyOut:(NSTimeInterval)duration delegate:(id)delegate;

/** 
 The view will scale up to twice its size while fading to invisible.
 */
- (void)flyOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

@end
