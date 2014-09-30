//
//  MMMSwitchThumb.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "MMMSwitchThumb.h"

@interface MMMSwitchThumb ()

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation MMMSwitchThumb

#pragma mark - Initializers

// Ignore any frame we receive
- (instancetype)initWithFrame:(CGRect)frame
{
    return self = [super initWithFrame:CGRectZero] ? self : nil;
}

#pragma mark - Public Methods

- (void)configureLayout
{
    NSAssert(self.superview, @"'updateLayout' cannot be called whilst superview is nil.");
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor blueColor];
    
    // Thumb's height should always match that of its parent
    self.heightConstraint = [NSLayoutConstraint
                             constraintWithItem:self
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.superview
                             attribute:NSLayoutAttributeHeight
                             multiplier:1.0f
                             constant:0.0f];
    [self.superview addConstraint:self.heightConstraint];
    
    // Thumb's width should start out matching its height (it will stretch on touchDown)
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint
                                           constraintWithItem:self
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                           attribute:NSLayoutAttributeHeight
                                           multiplier:1.0f
                                           constant:0.0f];
    [self addConstraint:widthConstraint];
    
    // Thumb's centerY should always match that of its parent
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint
                                             constraintWithItem:self
                                             attribute:NSLayoutAttributeCenterY
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.superview
                                             attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0f
                                             constant:0.0f];
    [self.superview addConstraint:centerYConstraint];
    
    // Thumb's leading edge should start out matching its parent (it will move on switch on/off)
    NSLayoutConstraint *leadingEdgeConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self
                                                 attribute:NSLayoutAttributeLeading
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self.superview
                                                 attribute:NSLayoutAttributeLeading
                                                 multiplier:1.0f
                                                 constant:0.0f];
    [self.superview addConstraint:leadingEdgeConstraint];
    
    [self layoutIfNeeded];
    
<<<<<<< Updated upstream
=======
    self.layoutHasBeenConfigured = YES;
}

- (void)growThumbFromRightSide:(BOOL)onRightSide
{
    [self adjustThumbFromRightSide:onRightSide thumbGrowing:YES];
}

- (void)shrinkThumbFromRightSide:(BOOL)onRightSide
{
    [self adjustThumbFromRightSide:onRightSide thumbGrowing:NO];
}

- (void)adjustThumbFromRightSide:(BOOL)onRightSide
                        thumbGrowing:(BOOL)growing
{
    self.widthConstraint.constant = growing ? (CGRectGetWidth(self.frame)*kDefaultThumbGrowthFactor) : 0.0f;
    
    [UIView animateWithDuration:kDefaultThumbGrowShrinkAnimationDuration
                     animations:^{ [self layoutIfNeeded]; }];
}

- (void)setOn:(BOOL)on
{
    BOOL wantsRightSide = on;
    if (wantsRightSide)
    {
        [self.superview addConstraint:self.trailingEdgeConstraint];
        [self.superview removeConstraint:self.leadingEdgeConstraint];
    }
    else
    {
        [self.superview addConstraint:self.leadingEdgeConstraint];
        [self.superview removeConstraint:self.trailingEdgeConstraint];
    }
    
    _on = on;
}

- (void)addCornerRadiusUpdateAnimationWithDuration:(NSTimeInterval)duration
{
    NSLog(@"addCornerRadiusUpdateAnimationWithDuration");
    
    CABasicAnimation *thumbAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    thumbAnimation.fromValue = @(self.layer.cornerRadius);
    thumbAnimation.toValue = @(floorf(CGRectGetHeight(self.frame)/2.0f));
    thumbAnimation.duration = duration;
    [CATransaction setCompletionBlock:^{ [self updateCornerRadius]; }];
    [self.layer addAnimation:thumbAnimation forKey:@"thumbCornerRadiusAnimation"];
}

#pragma mark - Auto Layout Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // Ensure things are the way they're already supposed to be
    // (These are usually no-ops, except when switch is resizing)
    [self setOn:self.isOn];
>>>>>>> Stashed changes
    [self updateCornerRadius];
}

-(void) growThumbWithJustification:(MMMSwitchThumbJustification) justification {
//    if (self.isTracking)
//        return;
//    
//    CGRect thumbFrame = self.frame;
//    
//    CGFloat deltaWidth = self.frame.size.width * (kThumbTrackingGrowthRatio - 1);
//    thumbFrame.size.width += deltaWidth;
//    if (justification == MMMSwitchThumbJustifyRight) {
//        thumbFrame.origin.x -= deltaWidth;
//    }
//    [self setFrame: thumbFrame];
}
-(void) shrinkThumbWithJustification:(MMMSwitchThumbJustification) justification {
//    if (!self.isTracking)
//        return;
//    
//    CGRect thumbFrame = self.frame;
//    
//    CGFloat deltaWidth = self.frame.size.width * (1 - 1 / (kThumbTrackingGrowthRatio));
//    thumbFrame.size.width -= deltaWidth;
//    if (justification == MMMSwitchThumbJustifyRight) {
//        thumbFrame.origin.x += deltaWidth;
//    }
//    [self setFrame: thumbFrame];
//    
}

@end
