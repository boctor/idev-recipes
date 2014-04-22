//
//  AllAroundPullView.m
//
//  Created by r_plus on 9/2/12
//  Copyright (c) 2012 r_plus All rights reserved.
//
//  https://github.com/r-plus/AllAroundPullView
//
//  based on twobitlabs modified version of PullToRefreshView by Grant Paul (chpwn)
//

#import "AllAroundPullView.h"

@interface AllAroundPullView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CALayer *arrowImage;
@property (nonatomic, assign) AllAroundPullViewState state;
@property (nonatomic, assign) UIEdgeInsets originalInset;
@property (nonatomic, copy) void (^allAroundPullViewActionHandler)(AllAroundPullView *view);

- (void)startTimer;
- (void)dismissView;
- (BOOL)isScrolledToVisible;
- (BOOL)isScrolledOverThreshold;
- (void)parkVisible;
- (void)hide;
- (id)initWithScrollView:(UIScrollView *)scroll position:(AllAroundPullViewPosition)position;

@end

@implementation AllAroundPullView
{
    AllAroundPullViewState _state;
    AllAroundPullViewPosition _position;
}

static const CGFloat kViewHeight = 60.0;
static const CGFloat kSidePullViewWidth = 60.0;

// dynamic ON/OFF set.
- (void)hideAllAroundPullViewIfNeed:(BOOL)disable
{
    self.arrowImage.opacity = disable ? 0.0 : 1.0;
    self.state = disable ? AllAroundPullViewStateNone : AllAroundPullViewStateNormal;
}

- (void)showActivity:(BOOL)shouldShow animated:(BOOL)animated
{
    if (shouldShow)
        [self.activityView startAnimating];
    else
        [self.activityView stopAnimating];
    
    [UIView animateWithDuration:(animated ? 0.1 : 0.0) animations:^{
        self.arrowImage.opacity = (shouldShow ? 0.0 : 1.0);
    }];
}

- (void)setImageFlipped:(BOOL)flipped
{
    if (self.isSideView) {
        BOOL isLeft = (self.position == AllAroundPullViewPositionLeft);
        [UIView animateWithDuration:0.1 animations:^{
            self.arrowImage.transform = (flipped ^ isLeft ? CATransform3DMakeRotation(M_PI / 2.0, 0.0, 0.0, 1.0) : CATransform3DMakeRotation(M_PI / 2.0 * 3.0, 0.0, 0.0, 1.0));
        }];
    } else {
        BOOL isBottom = (self.position == AllAroundPullViewPositionBottom);
        [UIView animateWithDuration:0.1 animations:^{
            self.arrowImage.transform = (flipped ^ isBottom ? CATransform3DMakeRotation(M_PI * 2, 0.0, 0.0, 1.0) : CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0));
        }];
    }
}

- (id)initWithScrollView:(UIScrollView *)scroll position:(AllAroundPullViewPosition)position action:(void (^)(AllAroundPullView *view))actionHandler
{
    self.allAroundPullViewActionHandler = actionHandler;
    return [self initWithScrollView:scroll position:position];
}

- (void)layoutSubviews
{
    CGFloat visibleBottom = self.position == AllAroundPullViewPositionBottom ? kViewHeight : self.frame.size.height;
    CGFloat visibleLeft = self.position == AllAroundPullViewPositionLeft ? kSidePullViewWidth : self.frame.size.width;
    if (self.isSideView)
        self.arrowImage.position = CGPointMake(visibleLeft - kSidePullViewWidth + 30.0, self.frame.size.height / 2.0);
    else
        self.arrowImage.position = CGPointMake(self.frame.size.width / 2.0, visibleBottom - kViewHeight + 30.0);
}

- (id)initWithScrollView:(UIScrollView *)scroll position:(AllAroundPullViewPosition)position
{
    CGFloat offset;
    CGRect frame;
    
    switch (position) {
        case AllAroundPullViewPositionTop:
        case AllAroundPullViewPositionBottom:
            offset = (position == AllAroundPullViewPositionBottom) ? scroll.contentSize.height : 0.0 - scroll.bounds.size.height;
            frame = CGRectMake(0.0, offset, scroll.bounds.size.width, scroll.bounds.size.height);
            break;
        case AllAroundPullViewPositionLeft:
        case AllAroundPullViewPositionRight:
            offset = (position == AllAroundPullViewPositionLeft) ? -kSidePullViewWidth : scroll.contentSize.width;
            frame = CGRectMake(offset, 0.0, kSidePullViewWidth, scroll.frame.size.height);
            break;
    }
    
    if ((self = [super initWithFrame:frame])) {
        _position = position;
        self.scrollView = scroll;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        self.autoresizingMask = self.isSideView ? UIViewAutoresizingFlexibleHeight : UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        _threshold = 60.0;
        self.arrowImage = [[CALayer alloc] init];
        UIImage *arrow = [UIImage imageNamed:@"arrow.png"];
        self.arrowImage.contents = (id) arrow.CGImage;
        CGRect arrowAndActivityFrame;
        if (self.isSideView) {
            CGFloat sideArrowPositionOffset = (self.position == AllAroundPullViewPositionLeft) ? kSidePullViewWidth - 10.0 : self.frame.size.width - 15.0;
            arrowAndActivityFrame = CGRectMake(sideArrowPositionOffset - kSidePullViewWidth + 30.0, self.frame.size.height / 2.0 - 30.0, arrow.size.width, arrow.size.height);
        } else {
            CGFloat arrowPositionOffset = (self.position == AllAroundPullViewPositionBottom) ? kViewHeight : self.frame.size.height;
            arrowAndActivityFrame = CGRectMake(self.frame.size.width / 2.0 - arrow.size.width / 2.0, arrowPositionOffset - kViewHeight + 5.0, arrow.size.width, arrow.size.height);
        }
        self.arrowImage.frame = arrowAndActivityFrame;
        self.arrowImage.contentsGravity = kCAGravityResizeAspect;
        [self setImageFlipped:NO];
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
            self.arrowImage.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:self.arrowImage];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.autoresizingMask = self.isSideView ? (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin) : (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        self.activityView.frame = arrowAndActivityFrame;
        [self addSubview:self.activityView];
        
        self.state = AllAroundPullViewStateNormal;
    }
    return self;
}

- (void)updatePositionWhenContentsSizeIsChanged
{
    if (self.position == AllAroundPullViewPositionBottom)
        self.frame = CGRectMake(0.0, self.scrollView.contentSize.height, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    else if (self.position == AllAroundPullViewPositionRight) {
        CGRect rect = self.frame;
        rect.origin.x = self.scrollView.contentSize.width;
        self.frame = rect;
    }
}

- (void)updatePosition
{
    if (self.isSideView) {
        CGRect rect = self.frame;
        rect.origin.y = self.scrollView.contentOffset.y;
        self.frame = rect;
    } else {
        CGRect frame = self.frame;
        frame.origin.x = self.scrollView.contentOffset.x;
        self.frame = frame;
    }
}

#pragma mark -
#pragma mark Setters

- (void)setState:(AllAroundPullViewState)state_
{
    _state = state_;
    
    switch (_state) {
        case AllAroundPullViewStateReady:
            [self showActivity:NO animated:NO];
            [self setImageFlipped:YES];
            break;
        case AllAroundPullViewStateNormal:
            [self showActivity:NO animated:NO];
            [self setImageFlipped:NO];
            break;
        case AllAroundPullViewStateLoading:
            [self showActivity:YES animated:YES];
            [self setImageFlipped:NO];
            [self parkVisible];
            [self startTimer];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Getters

- (BOOL)isSideView
{
    if (self.position & (AllAroundPullViewPositionLeft | AllAroundPullViewPositionRight))
        return YES;
    else
        return NO;
}

#pragma mark -
#pragma mark UIScrollView

- (BOOL)isScrolledToVisible
{
    switch (self.position) {
        case AllAroundPullViewPositionTop:
        {
            BOOL scrolledAboveContent = self.scrollView.contentOffset.y < 0.0;
            return scrolledAboveContent && ![self isScrolledOverThreshold];
        }
        case AllAroundPullViewPositionBottom:
        {
            BOOL scrolledBelowContent = self.scrollView.contentOffset.y > (self.scrollView.contentSize.height - self.scrollView.frame.size.height);
            return scrolledBelowContent && ![self isScrolledOverThreshold];
        }
        case AllAroundPullViewPositionLeft:
        case AllAroundPullViewPositionRight:
            return ![self isScrolledOverThreshold];
    }
    
    return NO;
}

- (BOOL)isScrolledOverThreshold
{
    switch (self.position) {
        case AllAroundPullViewPositionTop:
            return self.scrollView.contentOffset.y <= -self.threshold;
        case AllAroundPullViewPositionBottom:
            if (self.scrollView.contentSize.height > self.scrollView.frame.size.height)
                return self.scrollView.contentOffset.y >= (self.scrollView.contentSize.height - self.scrollView.frame.size.height) + self.threshold;
            else
                return self.scrollView.contentOffset.y >= self.threshold;
        case AllAroundPullViewPositionLeft:
            return self.scrollView.contentOffset.x <= -self.threshold;
        case AllAroundPullViewPositionRight:
            return self.scrollView.contentOffset.x >= (self.scrollView.contentSize.width - self.scrollView.frame.size.width) + self.threshold;
    }
    
    return NO;
}

- (void)parkVisible
{
    self.originalInset = self.scrollView.contentInset;
    if (self.position == AllAroundPullViewPositionTop)
        self.scrollView.contentInset = UIEdgeInsetsMake(kViewHeight + self.originalInset.top, self.originalInset.left, self.originalInset.bottom, self.originalInset.right);
    else if (self.position == AllAroundPullViewPositionBottom)
        self.scrollView.contentInset = UIEdgeInsetsMake(self.originalInset.top, self.originalInset.left, kViewHeight + self.originalInset.bottom, self.originalInset.right);
}

- (void)hide
{
    if (!self.isSideView)
        self.scrollView.contentInset = self.originalInset;
}

- (void)handleDragWhileLoading
{
    if ([self isScrolledOverThreshold] || [self isScrolledToVisible]) {
        // allow scrolled portion of view to display
        if (self.position == AllAroundPullViewPositionBottom) {
            CGFloat visiblePortion = self.scrollView.contentOffset.y - (self.scrollView.contentSize.height - self.scrollView.frame.size.height);
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, MIN(visiblePortion, kViewHeight), 0);
        } else if (self.position == AllAroundPullViewPositionTop) {
            self.scrollView.contentInset = UIEdgeInsetsMake(MIN(-self.scrollView.contentOffset.y, kViewHeight), 0, 0, 0);
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
        [self updatePositionWhenContentsSizeIsChanged];
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.scrollView.isDragging) {
            if (_state == AllAroundPullViewStateReady) {
                if ([self isScrolledToVisible]) {
                    // dragging from "release to refresh" back down (didn't release at top)
                    [self setState:AllAroundPullViewStateNormal];
                }
            } else if (_state == AllAroundPullViewStateNormal) {
                // hit the upper limit, change to "release to refresh"
                if ([self isScrolledOverThreshold]) {
                    [self setState:AllAroundPullViewStateReady];
                }
            } else if (_state == AllAroundPullViewStateLoading) {
                [self handleDragWhileLoading];
            }
            if (_state != AllAroundPullViewStateNone) {
                [self updatePosition];
            }
        } else {
            if (_state == AllAroundPullViewStateReady) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self setState:AllAroundPullViewStateLoading];
                }];
                if (self.allAroundPullViewActionHandler)
                    self.allAroundPullViewActionHandler(self);
            }
        }
    }
}

- (void)finishedLoading
{
    if (_state == AllAroundPullViewStateLoading)
        [self dismissView];
}

- (void)dismissView
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setState:AllAroundPullViewStateNormal];
        [self hide];
    }];
}

#pragma mark -
#pragma mark Timeout

- (void)startTimer
{
    if (self.timeout > 0)
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:self.timeout];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end

/* vim: set tabstop=4 shiftwidth=4 softtabstop=4 expandtab ff=unix: */
