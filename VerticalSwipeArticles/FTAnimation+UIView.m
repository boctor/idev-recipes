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

#import "FTAnimation+UIView.h"
#import "FTUtils.h"
#import "FTUtils+NSObject.h"

@implementation UIView (FTAnimationAdditions)

#pragma mark - Sliding Animations

- (void)slideInFrom:(FTAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate 
      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *slideInAnim = [[FTAnimationManager sharedManager] slideInAnimationFor:self direction:direction 
                                                                            duration:duration delegate:delegate 
                                                                       startSelector:startSelector stopSelector:stopSelector];
  [self.layer addAnimation:slideInAnim forKey:kFTAnimationSlideIn];
}

- (void)slideInFrom:(FTAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate {
  [self slideInFrom:direction duration:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)slideOutTo:(FTAnimationDirection)direction duration:(NSTimeInterval)duration 
          delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *slideOutAnim = [[FTAnimationManager sharedManager] slideOutAnimationFor:self direction:direction 
                                                                              duration:duration delegate:delegate 
                                                                         startSelector:startSelector stopSelector:stopSelector];
  [self.layer addAnimation:slideOutAnim forKey:kFTAnimationSlideOut];
}

- (void)slideOutTo:(FTAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate {
  [self slideOutTo:direction duration:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)slideInFrom:(FTAnimationDirection)direction inView:(UIView*)enclosingView duration:(NSTimeInterval)duration delegate:(id)delegate 
      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
	CAAnimation *slideInAnim = [[FTAnimationManager sharedManager] slideInAnimationFor:self direction:direction inView:(UIView*)enclosingView
																			  duration:duration delegate:delegate 
																		 startSelector:startSelector stopSelector:stopSelector];
	[self.layer addAnimation:slideInAnim forKey:kFTAnimationSlideIn];
}

- (void)slideOutTo:(FTAnimationDirection)direction inView:(UIView*)enclosingView duration:(NSTimeInterval)duration 
          delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
	CAAnimation *slideOutAnim = [[FTAnimationManager sharedManager] slideOutAnimationFor:self direction:direction inView:(UIView*)enclosingView
																				duration:duration delegate:delegate 
																		   startSelector:startSelector stopSelector:stopSelector];
	[self.layer addAnimation:slideOutAnim forKey:kFTAnimationSlideOut];
}


#pragma mark - Back In/Out Animations

- (void)backOutTo:(FTAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
    startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *backOutAnim = [[FTAnimationManager sharedManager] backOutAnimationFor:self withFade:fade direction:direction 
                                                                            duration:duration delegate:delegate 
                                                                       startSelector:startSelector stopSelector:stopSelector];
  [self.layer addAnimation:backOutAnim forKey:kFTAnimationBackOut];
}

- (void)backOutTo:(FTAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate {
  [self backOutTo:direction withFade:fade duration:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)backInFrom:(FTAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *backInAnim = [[FTAnimationManager sharedManager] backInAnimationFor:self withFade:fade direction:direction 
                                                                          duration:duration delegate:delegate 
                                                                     startSelector:startSelector stopSelector:stopSelector];
  [self.layer addAnimation:backInAnim forKey:kFTAnimationBackIn];
}

- (void)backInFrom:(FTAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate {
  [self backInFrom:direction withFade:fade duration:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)backOutTo:(FTAnimationDirection)direction inView:(UIView*)enclosingView withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
    startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
	CAAnimation *backOutAnim = [[FTAnimationManager sharedManager] backOutAnimationFor:self withFade:fade direction:direction inView:enclosingView
																			  duration:duration delegate:delegate 
																		 startSelector:startSelector stopSelector:stopSelector];
	[self.layer addAnimation:backOutAnim forKey:kFTAnimationBackOut];
}

- (void)backInFrom:(FTAnimationDirection)direction inView:(UIView*)enclosingView withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
	CAAnimation *backInAnim = [[FTAnimationManager sharedManager] backInAnimationFor:self withFade:fade direction:direction inView:enclosingView
																			duration:duration delegate:delegate 
																	   startSelector:startSelector stopSelector:stopSelector];
	[self.layer addAnimation:backInAnim forKey:kFTAnimationBackIn];
}

#pragma mark - Fade Animations

- (void)fadeIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *anim = [[FTAnimationManager sharedManager] fadeAnimationFor:self duration:duration delegate:delegate 
                                                             startSelector:startSelector stopSelector:stopSelector fadeOut:NO];
  [self.layer addAnimation:anim forKey:kFTAnimationFadeIn];
}

- (void)fadeIn:(NSTimeInterval)duration delegate:(id)delegate {
  [self fadeIn:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)fadeOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *anim = [[FTAnimationManager sharedManager] fadeAnimationFor:self duration:duration delegate:delegate 
                                                             startSelector:startSelector stopSelector:stopSelector fadeOut:YES];
  [self.layer addAnimation:anim forKey:kFTAnimationFadeOut];
}

- (void)fadeOut:(NSTimeInterval)duration delegate:(id)delegate {
  [self fadeOut:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)fadeBackgroundColorIn:(NSTimeInterval)duration delegate:(id)delegate 
                startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *anim = [[FTAnimationManager sharedManager] fadeBackgroundColorAnimationFor:self duration:duration 
                                                                                 delegate:delegate startSelector:startSelector 
                                                                             stopSelector:stopSelector fadeOut:NO];
  [self.layer addAnimation:anim forKey:kFTAnimationFadeBackgroundIn];
}

- (void)fadeBackgroundColorIn:(NSTimeInterval)duration delegate:(id)delegate {
  [self fadeBackgroundColorIn:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)fadeBackgroundColorOut:(NSTimeInterval)duration delegate:(id)delegate 
                 startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *anim = [[FTAnimationManager sharedManager] fadeBackgroundColorAnimationFor:self duration:duration 
                                                                                 delegate:delegate startSelector:startSelector 
                                                                             stopSelector:stopSelector fadeOut:YES];
  [self.layer addAnimation:anim forKey:kFTAnimationFadeBackgroundOut];
}

- (void)fadeBackgroundColorOut:(NSTimeInterval)duration delegate:(id)delegate {
  [self fadeBackgroundColorOut:duration delegate:delegate startSelector:nil stopSelector:nil];
}

#pragma mark - Popping Animations

- (void)popIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *anim = [[FTAnimationManager sharedManager] popInAnimationFor:self duration:duration delegate:delegate 
                                                              startSelector:startSelector stopSelector:stopSelector];
  [self.layer addAnimation:anim forKey:kFTAnimationPopIn];
}

- (void)popIn:(NSTimeInterval)duration delegate:(id)delegate {
  [self popIn:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)popOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *anim = [[FTAnimationManager sharedManager] popOutAnimationFor:self duration:duration delegate:delegate 
                                                               startSelector:startSelector stopSelector:stopSelector];
  [self.layer addAnimation:anim forKey:kFTAnimationPopOut];
}

- (void)popOut:(NSTimeInterval)duration delegate:(id)delegate {
  [self popOut:duration delegate:delegate startSelector:nil stopSelector:nil];
}

#pragma mark - Fall In and Fly Out

- (void)fallIn:(NSTimeInterval)duration delegate:(id)delegate {
  [self fallIn:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)fallIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *anim = [[FTAnimationManager sharedManager] fallInAnimationFor:self duration:duration delegate:delegate 
                                                               startSelector:startSelector stopSelector:stopSelector];
  [self.layer addAnimation:anim forKey:kFTAnimationFallIn];
}

- (void)fallOut:(NSTimeInterval)duration delegate:(id)delegate {
  [self fallOut:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)fallOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *anim = [[FTAnimationManager sharedManager] fallOutAnimationFor:self duration:duration delegate:delegate 
                                                                startSelector:startSelector stopSelector:stopSelector];
  [self.layer addAnimation:anim forKey:kFTAnimationFallOut];
}

- (void)flyOut:(NSTimeInterval)duration delegate:(id)delegate {
  [self flyOut:duration delegate:delegate startSelector:nil stopSelector:nil];
}

- (void)flyOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector {
  CAAnimation *anim = [[FTAnimationManager sharedManager] flyOutAnimationFor:self duration:duration delegate:delegate
                                                               startSelector:startSelector stopSelector:stopSelector];
  [self.layer addAnimation:anim forKey:kFTAnimationFlyOut];
}

@end
