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
#import "FTUtils.h"
#import "FTUtils+NSObject.h"


NSString *const kFTAnimationName = @"kFTAnimationName";
NSString *const kFTAnimationType = @"kFTAnimationType";
NSString *const kFTAnimationTypeIn = @"kFTAnimationTypeIn";
NSString *const kFTAnimationTypeOut = @"kFTAnimationTypeOut";

NSString *const kFTAnimationSlideOut = @"kFTAnimationNameSlideOut";
NSString *const kFTAnimationSlideIn = @"kFTAnimationNameSlideIn";
NSString *const kFTAnimationBackOut = @"kFTAnimationNameBackOut";
NSString *const kFTAnimationBackIn = @"kFTAnimationNameBackIn";
NSString *const kFTAnimationFadeOut = @"kFTAnimationFadeOut";
NSString *const kFTAnimationFadeIn = @"kFTAnimationFadeIn";
NSString *const kFTAnimationFadeBackgroundOut = @"kFTAnimationFadeBackgroundOut";
NSString *const kFTAnimationFadeBackgroundIn = @"kFTAnimationFadeBackgroundIn";
NSString *const kFTAnimationPopIn = @"kFTAnimationPopIn";
NSString *const kFTAnimationPopOut = @"kFTAnimationPopOut";
NSString *const kFTAnimationFallIn = @"kFTAnimationFallIn";
NSString *const kFTAnimationFallOut = @"kFTAnimationFallOut";
NSString *const kFTAnimationFlyOut = @"kFTAnimationFlyOut";

NSString *const kFTAnimationCallerDelegateKey = @"kFTAnimationCallerDelegateKey";
NSString *const kFTAnimationCallerStartSelectorKey = @"kFTAnimationCallerStartSelectorKey";
NSString *const kFTAnimationCallerStopSelectorKey = @"kFTAnimationCallerStopSelectorKey";
NSString *const kFTAnimationTargetViewKey = @"kFTAnimationTargetViewKey";
NSString *const kFTAnimationIsChainedKey = @"kFTAnimationIsChainedKey";
NSString *const kFTAnimationNextAnimationKey = @"kFTAnimationNextAnimationKey";
NSString *const kFTAnimationPrevAnimationKey = @"kFTAnimationPrevAnimationKey";
NSString *const kFTAnimationWasInteractionEnabledKey = @"kFTAnimationWasInteractionEnabledKey";

@interface FTAnimationManager ()

- (CGPoint)overshootPointFor:(CGPoint)point withDirection:(FTAnimationDirection)direction threshold:(CGFloat)threshold;

@end


@implementation FTAnimationManager

@synthesize overshootThreshold = overshootThreshold_;

- (CAAnimationGroup *)delayStartOfAnimation:(CAAnimation *)animation withDelay:(CFTimeInterval)delayTime {
  animation.fillMode = kCAFillModeBoth;
  animation.beginTime = delayTime;
  UIView *targetView = [animation valueForKey:kFTAnimationTargetViewKey];
  NSString *name = [animation valueForKey:kFTAnimationName];
  NSString *type = [animation valueForKey:kFTAnimationType];
  id delegate = [animation valueForKey:kFTAnimationCallerDelegateKey];
  NSString *startSelectorString = [animation valueForKey:kFTAnimationCallerStartSelectorKey];
  NSString *stopSelectorString = [animation valueForKey:kFTAnimationCallerStopSelectorKey];
  SEL startSelector = nil;
  SEL stopSelector = nil;
  if(startSelectorString != nil) {
    startSelector = NSSelectorFromString(startSelectorString);
  }
  if(stopSelectorString != nil) {
    stopSelector = NSSelectorFromString(stopSelectorString);
  }
  CAAnimationGroup *group = [[FTAnimationManager sharedManager] 
                             animationGroupFor:[NSArray arrayWithObject:animation] 
                             withView:targetView duration:animation.duration + delayTime 
                             delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                             name:name type:type];
  return group;
}

- (CAAnimationGroup *)pauseAtEndOfAnimation:(CAAnimation *)animation withDelay:(CFTimeInterval)delayTime {
  animation.fillMode = kCAFillModeForwards;
  UIView *targetView = [animation valueForKey:kFTAnimationTargetViewKey];
  NSString *name = [animation valueForKey:kFTAnimationName];
  NSString *type = [animation valueForKey:kFTAnimationType];
  id delegate = [animation valueForKey:kFTAnimationCallerDelegateKey];
  NSString *startSelectorString = [animation valueForKey:kFTAnimationCallerStartSelectorKey];
  NSString *stopSelectorString = [animation valueForKey:kFTAnimationCallerStopSelectorKey];
  SEL startSelector = nil;
  SEL stopSelector = nil;
  if(startSelectorString != nil) {
    startSelector = NSSelectorFromString(startSelectorString);
  }
  if(stopSelectorString != nil) {
    stopSelector = NSSelectorFromString(stopSelectorString);
  }
  CAAnimationGroup *group = [[FTAnimationManager sharedManager] 
                             animationGroupFor:[NSArray arrayWithObject:animation] 
                             withView:targetView duration:animation.duration + delayTime 
                             delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                             name:name type:type];
  return group;
}

#pragma mark -
#pragma mark Chained Animations

- (CAAnimation *)chainAnimations:(NSArray *)animations run:(BOOL)run {
  CAAnimation *head = nil;
  CAAnimation *prev = nil;
  
  for(CAAnimation *anim in animations) {
    if(!head) {
      head = anim;
    } else {
      [prev setValue:anim forKey:kFTAnimationNextAnimationKey];
    }
    [anim setValue:prev forKey:kFTAnimationPrevAnimationKey];
    [anim setValue:[NSNumber numberWithBool:YES] forKey:kFTAnimationIsChainedKey];
    prev = anim;
  }
  if(run) {
    UIView *target = [head valueForKey:kFTAnimationTargetViewKey];
    [target.layer addAnimation:head forKey:[head valueForKey:kFTAnimationName]];
  }
  return head;
}

#pragma mark -
#pragma mark Utility Methods

- (CAAnimationGroup *)animationGroupFor:(NSArray *)animations withView:(UIView *)view 
                               duration:(NSTimeInterval)duration delegate:(id)delegate 
                          startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector
                                   name:(NSString *)name type:(NSString *)type {
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.animations = [NSArray arrayWithArray:animations];
  group.delegate = self;
  group.duration = duration;
  group.removedOnCompletion = NO;
  if([type isEqualToString:kFTAnimationTypeOut]) {
    group.fillMode = kCAFillModeBoth;
  }
  group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [group setValue:view forKey:kFTAnimationTargetViewKey];
  [group setValue:delegate forKey:kFTAnimationCallerDelegateKey];
  if(!startSelector) {
    startSelector = @selector(animationDidStart:);
  }
  [group setValue:NSStringFromSelector(startSelector) forKey:kFTAnimationCallerStartSelectorKey];
  if(!stopSelector) {
    stopSelector = @selector(animationDidStop:finished:);
  }
  [group setValue:NSStringFromSelector(stopSelector) forKey:kFTAnimationCallerStopSelectorKey];
  [group setValue:name forKey:kFTAnimationName];
  [group setValue:type forKey:kFTAnimationType];
  return group;
}

#pragma mark -
#pragma mark Slide Animation Builders
- (CAAnimation *)slideInAnimationFor:(UIView *)view direction:(FTAnimationDirection)direction 
                            duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.fromValue = [NSValue valueWithCGPoint:FTAnimationOffscreenCenterPoint(view.frame, view.center, direction)];
  animation.toValue = [NSValue valueWithCGPoint:view.center];
  return [self animationGroupFor:[NSArray arrayWithObject:animation] withView:view duration:duration 
                        delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                            name:kFTAnimationSlideIn type:kFTAnimationTypeIn];
}

- (CAAnimation *)slideOutAnimationFor:(UIView *)view direction:(FTAnimationDirection)direction 
                             duration:(NSTimeInterval)duration delegate:(id)delegate 
                        startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.fromValue = [NSValue valueWithCGPoint:view.center];
  animation.toValue = [NSValue valueWithCGPoint:FTAnimationOffscreenCenterPoint(view.frame, view.center, direction)];
  return [self animationGroupFor:[NSArray arrayWithObject:animation] withView:view duration:duration 
                        delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                            name:kFTAnimationSlideOut type:kFTAnimationTypeOut];
}


#pragma mark -

- (CAAnimation *)slideInAnimationFor:(UIView *)view direction:(FTAnimationDirection)direction inView:(UIView*)enclosingView
                            duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.fromValue = [NSValue valueWithCGPoint:FTAnimationOutOfViewCenterPoint(enclosingView.bounds, view.frame, view.center, direction)];
	animation.toValue = [NSValue valueWithCGPoint:view.center];
	return [self animationGroupFor:[NSArray arrayWithObject:animation] withView:view duration:duration 
						  delegate:delegate startSelector:startSelector stopSelector:stopSelector 
							  name:kFTAnimationSlideIn type:kFTAnimationTypeIn];
}

- (CAAnimation *)slideOutAnimationFor:(UIView *)view direction:(FTAnimationDirection)direction inView:(UIView*)enclosingView
                             duration:(NSTimeInterval)duration delegate:(id)delegate 
                        startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector{
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.fromValue = [NSValue valueWithCGPoint:view.center];
	animation.toValue = [NSValue valueWithCGPoint:FTAnimationOutOfViewCenterPoint(view.superview.bounds, view.frame, view.center, direction)];
	return [self animationGroupFor:[NSArray arrayWithObject:animation] withView:view duration:duration 
						  delegate:delegate startSelector:startSelector stopSelector:stopSelector 
							  name:kFTAnimationSlideOut type:kFTAnimationTypeOut];
}


#pragma mark -
#pragma mark Bounce Animation Builders

- (CGPoint)overshootPointFor:(CGPoint)point withDirection:(FTAnimationDirection)direction threshold:(CGFloat)threshold {
  CGPoint overshootPoint;
  if(direction == kFTAnimationTop || direction == kFTAnimationBottom) {
    overshootPoint = CGPointMake(point.x, point.y + ((direction == kFTAnimationBottom ? -1 : 1) * threshold));
  } else if (direction == kFTAnimationLeft || direction == kFTAnimationRight){
    overshootPoint = CGPointMake(point.x + ((direction == kFTAnimationRight ? -1 : 1) * threshold), point.y);
  } else if (direction == kFTAnimationTopLeft){
	  overshootPoint = CGPointMake(point.x + threshold, point.y + threshold);
  } else if (direction == kFTAnimationTopRight){
	  overshootPoint = CGPointMake(point.x - threshold, point.y + threshold);
  } else if (direction == kFTAnimationBottomLeft){
	  overshootPoint = CGPointMake(point.x + threshold, point.y - threshold);
  } else if (direction == kFTAnimationBottomRight){
	  overshootPoint = CGPointMake(point.x - threshold, point.y - threshold);
  }

  return overshootPoint;
}

- (CAAnimation *)backOutAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(FTAnimationDirection)direction 
                            duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CGPoint path[3] = {
    view.center,
    [self overshootPointFor:view.center withDirection:direction threshold:overshootThreshold_],
    FTAnimationOffscreenCenterPoint(view.frame, view.center, direction)
  };
  
  CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  CGMutablePathRef thePath = CGPathCreateMutable();
  CGPathAddLines(thePath, NULL, path, 3);
  animation.path = thePath;
  CGPathRelease(thePath);
  NSArray *animations;
  if(fade) {
    CAAnimation *fade = [self fadeAnimationFor:view duration:duration * .5f delegate:nil startSelector:nil stopSelector:nil fadeOut:YES];
    fade.beginTime = duration * .5f;
    fade.fillMode = kCAFillModeForwards;
    animations = [NSArray arrayWithObjects:animation, fade, nil];
  } else {
    animations = [NSArray arrayWithObject:animation];
  }
  return [self animationGroupFor:animations withView:view duration:duration 
                        delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                            name:kFTAnimationBackOut type:kFTAnimationTypeOut];
}

- (CAAnimation *)backInAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(FTAnimationDirection)direction 
                           duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CGPoint path[3] = {
    FTAnimationOffscreenCenterPoint(view.frame, view.center, direction),
    [self overshootPointFor:view.center withDirection:direction threshold:(overshootThreshold_ * 1.15)],
    view.center
  };
  
  CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  CGMutablePathRef thePath = CGPathCreateMutable();
  CGPathAddLines(thePath, NULL, path, 3);
  animation.path = thePath;
  CGPathRelease(thePath);
  NSArray *animations;
  if(fade) {
    CAAnimation *fade = [self fadeAnimationFor:view duration:duration * .5f delegate:nil startSelector:nil stopSelector:nil fadeOut:NO];
    fade.fillMode = kCAFillModeForwards;
    
    animations = [NSArray arrayWithObjects:animation, fade, nil];
  } else {
    animations = [NSArray arrayWithObject:animation];
  }
  return [self animationGroupFor:animations withView:view duration:duration 
                        delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                            name:kFTAnimationBackIn type:kFTAnimationTypeIn];
}


#pragma mark -

- (CAAnimation *)backOutAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(FTAnimationDirection)direction inView:(UIView*)enclosingView
                            duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
	CGPoint path[3] = {
		view.center,
		[self overshootPointFor:view.center withDirection:direction threshold:overshootThreshold_],
		FTAnimationOutOfViewCenterPoint(enclosingView.bounds, view.frame, view.center, direction)
	};
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathAddLines(thePath, NULL, path, 3);
	animation.path = thePath;
	CGPathRelease(thePath);
	NSArray *animations;
	if(fade) {
		CAAnimation *fade = [self fadeAnimationFor:view duration:duration * .5f delegate:nil startSelector:nil stopSelector:nil fadeOut:YES];
		fade.beginTime = duration * .5f;
		fade.fillMode = kCAFillModeForwards;
		animations = [NSArray arrayWithObjects:animation, fade, nil];
	} else {
		animations = [NSArray arrayWithObject:animation];
	}
	return [self animationGroupFor:animations withView:view duration:duration 
						  delegate:delegate startSelector:startSelector stopSelector:stopSelector 
							  name:kFTAnimationBackOut type:kFTAnimationTypeOut];
}


- (CAAnimation *)backInAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(FTAnimationDirection)direction inView:(UIView*)enclosingView
                           duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
	CGPoint path[3] = {
		FTAnimationOutOfViewCenterPoint(enclosingView.bounds, view.frame, view.center, direction),
		[self overshootPointFor:view.center withDirection:direction threshold:(overshootThreshold_ * 1.15)],
		view.center
	};
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathAddLines(thePath, NULL, path, 3);
	animation.path = thePath;
	CGPathRelease(thePath);
	NSArray *animations;
	if(fade) {
		CAAnimation *fade = [self fadeAnimationFor:view duration:duration * .5f delegate:nil startSelector:nil stopSelector:nil fadeOut:NO];
		fade.fillMode = kCAFillModeForwards;
		
		animations = [NSArray arrayWithObjects:animation, fade, nil];
	} else {
		animations = [NSArray arrayWithObject:animation];
	}
	return [self animationGroupFor:animations withView:view duration:duration 
						  delegate:delegate startSelector:startSelector stopSelector:stopSelector 
							  name:kFTAnimationBackIn type:kFTAnimationTypeIn];
}

#pragma mark -
#pragma mark Fade Animation Builders

- (CAAnimation *)fadeAnimationFor:(UIView *)view duration:(NSTimeInterval)duration 
                         delegate:(id)delegate startSelector:(SEL)startSelector 
                     stopSelector:(SEL)stopSelector fadeOut:(BOOL)fadeOut {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  
  NSString *name, *type;
  if(fadeOut) {
    animation.fromValue = [NSNumber numberWithFloat:1.f];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    name = kFTAnimationFadeOut;
    type = kFTAnimationTypeOut;
  } else {
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:1.f];
    name = kFTAnimationFadeIn;
    type = kFTAnimationTypeIn;
  }
  CAAnimationGroup *group = [self animationGroupFor:[NSArray arrayWithObject:animation] withView:view duration:duration 
                                           delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                                               name:name type:type];
  group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  return group;
  
}


- (CAAnimation *)fadeBackgroundColorAnimationFor:(UIView *)view duration:(NSTimeInterval)duration 
                                        delegate:(id)delegate startSelector:(SEL)startSelector 
                                    stopSelector:(SEL)stopSelector fadeOut:(BOOL)fadeOut {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
  
  NSString *name, *type;
  if(fadeOut) {
    animation.fromValue = (id)view.layer.backgroundColor;
    animation.toValue = (id)[[UIColor clearColor] CGColor];
    name = kFTAnimationFadeBackgroundOut;
    type = kFTAnimationTypeOut;
  } else {
    animation.fromValue = (id)[[UIColor clearColor] CGColor];
    animation.toValue = (id)view.layer.backgroundColor;
    name = kFTAnimationFadeBackgroundIn;
    type = kFTAnimationTypeIn;
  }
  CAAnimationGroup *group = [self animationGroupFor:[NSArray arrayWithObject:animation] withView:view duration:duration 
                                           delegate:delegate startSelector:startSelector stopSelector:stopSelector
                                               name:name type:type];
  group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  return group;
}

#pragma mark -
#pragma mark Pop Animation Builders

- (CAAnimation *)popInAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
  scale.duration = duration;
  scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
                  [NSNumber numberWithFloat:1.2f],
                  [NSNumber numberWithFloat:.85f],
                  [NSNumber numberWithFloat:1.f],
                  nil];
  
  CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fadeIn.duration = duration * .4f;
  fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
  fadeIn.toValue = [NSNumber numberWithFloat:1.f];
  fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  fadeIn.fillMode = kCAFillModeForwards;
  
  CAAnimationGroup *group = [self animationGroupFor:[NSArray arrayWithObjects:scale, fadeIn, nil] withView:view duration:duration 
                                           delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                                               name:kFTAnimationPopIn type:kFTAnimationTypeIn];
  group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  return group;
}

- (CAAnimation *)popOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
  scale.duration = duration;
  scale.removedOnCompletion = NO;
  scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                  [NSNumber numberWithFloat:1.2f],
                  [NSNumber numberWithFloat:.75f],
                  nil];
  
  CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fadeOut.duration = duration * .4f;
  fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
  fadeOut.toValue = [NSNumber numberWithFloat:0.f];
  fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  fadeOut.beginTime = duration * .6f;
  fadeOut.fillMode = kCAFillModeBoth;
  
  return [self animationGroupFor:[NSArray arrayWithObjects:scale, fadeOut, nil] withView:view duration:duration 
                        delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                            name:kFTAnimationPopOut type:kFTAnimationTypeOut];
}

#pragma mark -
#pragma mark Fall In and Fly Out Builders

- (CAAnimation *)fallInAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  
  CABasicAnimation *fall = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  fall.fromValue = [NSNumber numberWithFloat:2.f];
  fall.toValue = [NSNumber numberWithFloat:1.f];
  fall.duration = duration;
  
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fade.fromValue = [NSNumber numberWithFloat:0.f];
  fade.toValue = [NSNumber numberWithFloat:1.f];
  fade.duration = duration;
  
  CAAnimationGroup *group = [self animationGroupFor:[NSArray arrayWithObjects:fall, fade, nil] withView:view duration:duration 
                                           delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                                               name:kFTAnimationFallIn type:kFTAnimationTypeIn];
  return group;
}

- (CAAnimation *)fallOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  
  CABasicAnimation *fall = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  fall.fromValue = [NSNumber numberWithFloat:1.f];
  fall.toValue = [NSNumber numberWithFloat:.15f];
  fall.duration = duration;
  
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fade.fromValue = [NSNumber numberWithFloat:1.f];
  fade.toValue = [NSNumber numberWithFloat:0.f];
  fade.duration = duration;
  
  CAAnimationGroup *group = [self animationGroupFor:[NSArray arrayWithObjects:fall, fade, nil] withView:view duration:duration 
                                           delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                                               name:kFTAnimationFallOut type:kFTAnimationTypeOut];
  return group;
}


- (CAAnimation *)flyOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  
  CABasicAnimation *fly = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  fly.toValue = [NSNumber numberWithFloat:2.f];
  fly.duration = duration;
  
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fade.toValue = [NSNumber numberWithFloat:0.f];
  fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  
  CAAnimationGroup *group = [self animationGroupFor:[NSArray arrayWithObjects:fly, fade, nil] withView:view duration:duration 
                                           delegate:delegate startSelector:startSelector stopSelector:stopSelector 
                                               name:kFTAnimationFlyOut type:kFTAnimationTypeOut];
  return group;
}


#pragma mark -
#pragma mark Animation Delegate Methods

- (void)animationDidStart:(CAAnimation *)theAnimation {
  UIView *targetView = [theAnimation valueForKey:kFTAnimationTargetViewKey];
  [theAnimation setValue:[NSNumber numberWithBool:targetView.userInteractionEnabled] forKey:kFTAnimationWasInteractionEnabledKey];
  [targetView setUserInteractionEnabled:NO];
  
  if([[theAnimation valueForKey:kFTAnimationType] isEqualToString:kFTAnimationTypeIn]) {
    [targetView setHidden:NO];
  }
  
  //Check for chaining and forward the delegate call if necessary
  NSObject *callerDelegate = [theAnimation valueForKey:kFTAnimationCallerDelegateKey];
  SEL startSelector = NSSelectorFromString([theAnimation valueForKey:kFTAnimationCallerStartSelectorKey]);
  
  FT_CALL_DELEGATE_WITH_ARG(callerDelegate, startSelector, theAnimation)
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished {
  UIView *targetView = [theAnimation valueForKey:kFTAnimationTargetViewKey];
  BOOL wasInteractionEnabled = [[theAnimation valueForKey:kFTAnimationWasInteractionEnabledKey] boolValue];
  [targetView setUserInteractionEnabled:wasInteractionEnabled];
  
  if([[theAnimation valueForKey:kFTAnimationType] isEqualToString:kFTAnimationTypeOut]) {
    [targetView setHidden:YES];
  }
  [targetView.layer removeAnimationForKey:[theAnimation valueForKey:kFTAnimationName]];
  
  //Forward the delegate call
  id callerDelegate = [theAnimation valueForKey:kFTAnimationCallerDelegateKey];
  SEL stopSelector = NSSelectorFromString([theAnimation valueForKey:kFTAnimationCallerStopSelectorKey]);
  
  if([theAnimation valueForKey:kFTAnimationIsChainedKey]) {
    CAAnimation *next = [theAnimation valueForKey:kFTAnimationNextAnimationKey];
    if(next) {
      //Add the next animation to its layer
      UIView *nextTarget = [next valueForKey:kFTAnimationTargetViewKey];
      [nextTarget.layer addAnimation:next forKey:[next valueForKey:kFTAnimationName]];
    }
  }
  
  void *arguments[] = { &theAnimation, &finished };
  [callerDelegate performSelectorIfExists:stopSelector withArguments:arguments];
}

#pragma mark Singleton

static FTAnimationManager *sharedAnimationManager = nil;

+ (FTAnimationManager *)sharedManager {
  @synchronized(self) {
    if (sharedAnimationManager == nil) {
      sharedAnimationManager = [[self alloc] init];
    }
  }
  return sharedAnimationManager;
}

- (id)init {
  self = [super init];
  if (self != nil) {
    overshootThreshold_ = 10.f;
  }
  return self;
}

@end

#pragma mark -

@implementation CAAnimation (FTAnimationAdditions)

- (void)setStartSelector:(SEL)selector withTarget:(id)target {
  [self setValue:target forKey:kFTAnimationCallerDelegateKey];
  [self setValue:NSStringFromSelector(selector) forKey:kFTAnimationCallerStartSelectorKey];
}

- (void)setStopSelector:(SEL)selector withTarget:(id)target {
  [self setValue:target forKey:kFTAnimationCallerDelegateKey];
  [self setValue:NSStringFromSelector(selector) forKey:kFTAnimationCallerStopSelectorKey];
}

@end

