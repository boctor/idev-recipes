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

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum _FTAnimationDirection {
  kFTAnimationTop = 0,
  kFTAnimationRight,
  kFTAnimationBottom,
  kFTAnimationLeft,
  kFTAnimationTopLeft,
  kFTAnimationTopRight,
  kFTAnimationBottomLeft,
  kFTAnimationBottomRight
} FTAnimationDirection;

#pragma mark String Constants

extern NSString *const kFTAnimationName;
extern NSString *const kFTAnimationType;
extern NSString *const kFTAnimationTypeIn;
extern NSString *const kFTAnimationTypeOut;

extern NSString *const kFTAnimationSlideIn;
extern NSString *const kFTAnimationSlideOut;
extern NSString *const kFTAnimationBackOut;
extern NSString *const kFTAnimationBackIn;
extern NSString *const kFTAnimationFadeOut;
extern NSString *const kFTAnimationFadeIn;
extern NSString *const kFTAnimationFadeBackgroundOut;
extern NSString *const kFTAnimationFadeBackgroundIn;
extern NSString *const kFTAnimationPopIn;
extern NSString *const kFTAnimationPopOut;
extern NSString *const kFTAnimationFallIn;
extern NSString *const kFTAnimationFallOut;
extern NSString *const kFTAnimationFlyOut;

extern NSString *const kFTAnimationTargetViewKey;

#pragma mark Inline Functions

/**
 Find a `CGPoint` that will cause the *viewFrame* to be placed at the edge or corner of 
 the *enclosingViewFrame* in the specified *direction*.
 
 @return A center point which will place the given view at the edge or corner of the *enclosingViewFrame*
 
 @param enclosingViewFrame The view whose edge or corner will be used to calculate the point
 @param viewFrame The rect of the view to be moved
 @param viewCenter The center of the view to be moved
 @param direction The edge or corner of the *enclosingView* used to calculate the point
*/
static inline CGPoint FTAnimationOutOfViewCenterPoint(CGRect enclosingViewFrame, CGRect viewFrame, CGPoint viewCenter, FTAnimationDirection direction) {
	switch (direction) {
		case kFTAnimationBottom: {
			CGFloat extraOffset = viewFrame.size.height / 2;
			return CGPointMake(viewCenter.x, enclosingViewFrame.size.height + extraOffset);
			break;
		}
		case kFTAnimationTop: {
			CGFloat extraOffset = viewFrame.size.height / 2;
			return CGPointMake(viewCenter.x, enclosingViewFrame.origin.y - extraOffset);
			break;
		}
		case kFTAnimationLeft: {
			CGFloat extraOffset = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.origin.x - extraOffset, viewCenter.y);
			break;
		}
		case kFTAnimationRight: {
			CGFloat extraOffset = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.size.width + extraOffset, viewCenter.y);
			break;
		}
		case kFTAnimationBottomLeft: {
			CGFloat extraOffsetHeight = viewFrame.size.height / 2;
			CGFloat extraOffsetWidth = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.origin.x - extraOffsetWidth, enclosingViewFrame.size.height + extraOffsetHeight);
			break;
		}
		case kFTAnimationTopLeft: {
			CGFloat extraOffsetHeight = viewFrame.size.height / 2;
			CGFloat extraOffsetWidth = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.origin.x - extraOffsetWidth, enclosingViewFrame.origin.y - extraOffsetHeight);
			break;
		}
		case kFTAnimationBottomRight: {
			CGFloat extraOffsetHeight = viewFrame.size.height / 2;
			CGFloat extraOffsetWidth = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.size.width + extraOffsetWidth, enclosingViewFrame.size.height + extraOffsetHeight);
			break;
		}
		case kFTAnimationTopRight: {
			CGFloat extraOffsetHeight = viewFrame.size.height / 2;
			CGFloat extraOffsetWidth = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.size.width + extraOffsetWidth, enclosingViewFrame.origin.y - extraOffsetHeight);
			break;
		}
	}
	return CGPointZero;
}

/**
 Find a `CGPoint` that will cause the *viewFrame* to be completely offscreen in a specified *direction*.
 
 @return A center point which will place the given view rect offscreen
 
 @param viewFrame The view rect to be placed offscreen
 @param viewCenter The center of the view to be placed offscreen
 @param direction The edge or corner of the screen the view rect will be placed. 
*/
static inline CGPoint FTAnimationOffscreenCenterPoint(CGRect viewFrame, CGPoint viewCenter, FTAnimationDirection direction) {
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
    CGFloat swap = screenRect.size.height;
    screenRect.size.height = screenRect.size.width;
    screenRect.size.width = swap;
  } 
  switch (direction) {
    case kFTAnimationBottom: {
      CGFloat extraOffset = viewFrame.size.height / 2;
      return CGPointMake(viewCenter.x, screenRect.size.height + extraOffset);
      break;
    }
    case kFTAnimationTop: {
      CGFloat extraOffset = viewFrame.size.height / 2;
      return CGPointMake(viewCenter.x, screenRect.origin.y - extraOffset);
      break;
    }
    case kFTAnimationLeft: {
      CGFloat extraOffset = viewFrame.size.width / 2;
      return CGPointMake(screenRect.origin.x - extraOffset, viewCenter.y);
      break;
    }
    case kFTAnimationRight: {
      CGFloat extraOffset = viewFrame.size.width / 2;
      return CGPointMake(screenRect.size.width + extraOffset, viewCenter.y);
      break;
    }
    default:
      break;
  }
	return FTAnimationOutOfViewCenterPoint([[UIScreen mainScreen] bounds], viewFrame, viewCenter, direction);
}

/**
 The FTAnimationManager class is the heart of the FTUtils Core Animation utilities. It is
 meant to be used as a singleton. Developers should avoid creating mulitple instances
 and should get a reference to an instance via the sharedManager class method.
*/
@interface FTAnimationManager : NSObject {
@private
  CGFloat overshootThreshold_;
}

/**
 The maximum value (in points) that the bouncing animations will travel past their
 end value before coming to rest. The default is 10.0.
*/
@property(assign) CGFloat overshootThreshold;

///---------------------------------------------------------------------------
/// @name Accessing the animation manager
///---------------------------------------------------------------------------
/**
 Get a reference to the FTAnimationManager singleton creating it if necessary.

 @return The singleton.
*/
+ (FTAnimationManager *)sharedManager;

///---------------------------------------------------------------------------
/// @name Controlling animation timing
///---------------------------------------------------------------------------

/**
 Wraps a `CAAnimation` in a `CAAnimationGroup` which will delay the start of 
 the animation once it is added to a `CALayer`.
 
 @param animation The animation to be delayed
 @param delayTime The duration (in seconds) of the delay
*/
- (CAAnimationGroup *)delayStartOfAnimation:(CAAnimation *)animation withDelay:(CFTimeInterval)delayTime;

/**
 Wraps a `CAAnimation` in a `CAAnimationGroup` which will delay the firing of the 
 `animationDidStop:finished:` delegate method once the animation has stopped.
 
 @param animation The animation to be delayed
 @param delayTime The duration (in seconds) of the delay
 */
- (CAAnimationGroup *)pauseAtEndOfAnimation:(CAAnimation *)animation withDelay:(CFTimeInterval)delayTime;

/**
 Chains a sequence of animation objects to be run sequentially.
 
 @warning *Important:* The animation chaining only works with animations created 
 with one of the FTAnimationManager animations. If you want to sequence your own
 `CAAnimation` objects, you must wrap each of them with the 
 animationGroupFor:withView:duration:delegate:startSelector:stopSelector:name:type:
 method.
 
 @param animations An array of animations to be run sequentially
 @param run If `YES`, the sequence begins immediately after this method returns. If
 `NO`, you must add the returned `CAAnimation` object to a `CALayer` to begin the 
 sequence.
*/
- (CAAnimation *)chainAnimations:(NSArray *)animations run:(BOOL)run;

/**
 Groups a list of `CAAnimations` and associates them with _view_. All animations
 created by FTAnimationManager are ultimately created by this method.
 
 @param animations A list of animations to group together.
 @param view The target view for the _animations_.
 @param duration The duration (in seconds) of the returned animation group.
 @param delegate An optional delegate to send animation start and stop messages to.
 @param startSelector An optional selector to be called on _delegate_ when the animation starts.
 @param stopSelector An optional selector to be called on _delegate_ when the animation stops.
 @param name A unique name used as a key internally to store and retrieve this animation object.
 @param type Either kFTAnimationTypeIn or kFTAnimationTypeOut to denote whether this animation 
 is designed to show or hide its associated _view_.
*/
- (CAAnimationGroup *)animationGroupFor:(NSArray *)animations withView:(UIView *)view 
                               duration:(NSTimeInterval)duration delegate:(id)delegate 
                          startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector 
                                   name:(NSString *)name type:(NSString *)type;

///---------------------------------------------------------------------------
/// @name Creating animation objects
///---------------------------------------------------------------------------

/**
 Slides a view in from offscreen
*/
- (CAAnimation *)slideInAnimationFor:(UIView *)view direction:(FTAnimationDirection)direction 
                            duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;
/**
 Slides a view offscreen
*/
- (CAAnimation *)slideOutAnimationFor:(UIView *)view direction:(FTAnimationDirection)direction 
                             duration:(NSTimeInterval)duration delegate:(id)delegate 
                        startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Slides a view in from offscreen
*/
- (CAAnimation *)slideInAnimationFor:(UIView *)view direction:(FTAnimationDirection)direction inView:(UIView*)enclosingView
                            duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Slides a view offscreen
*/
- (CAAnimation *)slideOutAnimationFor:(UIView *)view direction:(FTAnimationDirection)direction inView:(UIView*)enclosingView
                             duration:(NSTimeInterval)duration delegate:(id)delegate 
                        startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Backs a view offscreen
*/
- (CAAnimation *)backOutAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(FTAnimationDirection)direction 
                            duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Backs a view in from offscreen
*/
- (CAAnimation *)backInAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(FTAnimationDirection)direction 
                           duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;
/**
 Backs a view offscreen
*/
- (CAAnimation *)backOutAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(FTAnimationDirection)direction inView:(UIView*)enclosingView
                            duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;
/**
 Backs a view in from offscreen
*/
- (CAAnimation *)backInAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(FTAnimationDirection)direction inView:(UIView*)enclosingView
                           duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Aniamtes the `alpha` of the _view_.
*/
- (CAAnimation *)fadeAnimationFor:(UIView *)view duration:(NSTimeInterval)duration 
                         delegate:(id)delegate startSelector:(SEL)startSelector 
                     stopSelector:(SEL)stopSelector fadeOut:(BOOL)fadeOut;

/**
 Animates the `backgroundColor` of the _view_.
*/
- (CAAnimation *)fadeBackgroundColorAnimationFor:(UIView *)view duration:(NSTimeInterval)duration 
                                        delegate:(id)delegate startSelector:(SEL)startSelector 
                                    stopSelector:(SEL)stopSelector fadeOut:(BOOL)fadeOut;

/**
 Pops a view in from offscreen
*/
- (CAAnimation *)popInAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Pops a view offscreen
*/
- (CAAnimation *)popOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/** 
 Shrinks and fades out view.
*/
- (CAAnimation *)fallInAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/** 
 Shrinks and fades in view which starts scaled to double of its original size.
*/
- (CAAnimation *)fallOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

/**
 Scales up and fades out a view.
*/
- (CAAnimation *)flyOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;


@end

/**
 This category on `CAAnimation` allows for using individual selectors
 on arbitrary objects to respond the `CAAnimationDelegate` calls.
 
 @warning *Important:* You must not set the `CAAnimation` `delegate` property
 when using a start or stop selector. If you call setStartSelector:withTarget: or
 setStopSelector:withTarget: the `CAAnimation`'s `delegate` will be overwritten.
*/
@interface CAAnimation (FTAnimationAdditions)

/**
 Called right before the animation starts. This has the same effect as 
 implementing the `animationDidStart:` delegate method.
 
 The selector should accept a single argument of type `CAAnimation`.
 
 @param selector The selector to call on _target_.
 @param target An object to send the `animationDidStart:` message to.
*/
- (void)setStartSelector:(SEL)selector withTarget:(id)target;

/**
 Called right before the animation stops. This has the same effect as 
 implementing the `animationDidStop:finished:` delegate method.
 
 The selector should accept a two arguments. The first argument is the
 `CAAnimation` object sending the message and the second is a `BOOL` 
 indicating whether the animation ran to completion.
 
 @param selector The selector to call on _target_.
 @param target An object to send the `animationDidStart:finished:` message to.
*/
- (void)setStopSelector:(SEL)selector withTarget:(id)target;

@end
