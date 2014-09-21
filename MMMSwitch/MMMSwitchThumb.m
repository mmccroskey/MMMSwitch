//
//  MMMSwitchThumb.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "MMMSwitchThumb.h"

#define kDefaultThumbColor  [UIColor whiteColor];
#define kDefaultThumbGrowShrinkAnimationDuration 0.1f
#define kDefaultThumbGrowthFactor 0.1f
#define kMagicAlignmentAdjustment 1.0f

@interface MMMSwitchThumb()

@property (assign, nonatomic) BOOL layoutHasBeenConfigured;

@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *leadingEdgeConstraint;

@property (assign, nonatomic) BOOL stretched;
@property (assign, nonatomic) BOOL onRightSide;

@end

@implementation MMMSwitchThumb

- (instancetype)initWithSuperview:(UIView*)superview
{
    if (self = [super init])
    {
        [self configureLayoutRelativeToSuperview:superview];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return (self = [super initWithFrame:CGRectZero]);
}

#pragma mark - Public Methods

- (void)configureLayoutRelativeToSuperview:(UIView*)superview
{
    NSAssert(superview, @"This method requires that superview not be nil.");
    NSAssert(!self.layoutHasBeenConfigured, @"Layout can only be configured once per instance.");
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backgroundColor = kDefaultThumbColor;
    self.layer.borderWidth = superview.layer.borderWidth;
    self.layer.borderColor = superview.layer.borderColor;
    
    [superview addSubview:self];
    
    // Thumb's height should always match that of its parent
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint
                                            constraintWithItem:self
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:superview
                                            attribute:NSLayoutAttributeHeight
                                            multiplier:1.0f
                                            constant:0.0f];
    [superview addConstraint:heightConstraint];
    
    // Thumb's width should start out matching its height (it will stretch on touchDown)
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0f
                                                         constant:0.0f];
    [self addConstraint:self.widthConstraint];
    
    // Thumb's centerY should always match that of its parent
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint
                                             constraintWithItem:self
                                             attribute:NSLayoutAttributeCenterY
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:superview
                                             attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0f
                                             constant:0.0f];
    [superview addConstraint:centerYConstraint];
    
    // Thumb's leading edge should start out matching its parent (it will move on switch on/off)
    self.leadingEdgeConstraint = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superview
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1.0f
                                                               constant:0.0f];
    [superview addConstraint:self.leadingEdgeConstraint];
    
    [self updateCornerRadius];
    
    [self layoutIfNeeded];
    
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
    self.widthConstraint.constant = growing ? [self stretchedWidth] : 0.0f;
    
    // When the thumb changes size, its left side remains fixed
    // while its right side grows. This looks correct when the
    // thumb is on the left side of the switch, but this causes
    // the thumb to over-shoot or under-shoot its proper location
    // when on the right side of the switch. Thus, when animating
    // the thumb's width while it's on the right side of the switch
    // we need to simultaneously tweak its x-location to compensate
    if (onRightSide && self.isOn)
    {
        [self adjustLeadingEdgeForRightSideWithGrowthState:growing];
    }
    
    [UIView animateWithDuration:kDefaultThumbGrowShrinkAnimationDuration
                     animations:^{ [self layoutIfNeeded]; }
                     completion:^(BOOL finished)
                     {
                         self.stretched = growing;
                         self.onRightSide = onRightSide;
                     }];
}

- (void)setOn:(BOOL)on
{
    BOOL wantsRightSide = on;
    if (wantsRightSide)
    {
        CGFloat superWidth = CGRectGetWidth(self.superview.frame);
        CGFloat selfWidth  = CGRectGetWidth(self.frame);
        self.leadingEdgeConstraint.constant = (superWidth - selfWidth);
    }
    else
    {
        self.leadingEdgeConstraint.constant = 0.0f;
    }
    
    _on = on;
}

#pragma mark - Auto Layout Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // Ensure things are the way they're already supposed to be
    // (These are usually no-ops, except when switch is resizing)
    [self setOn:self.isOn];
    [self updateCornerRadius];
}

#pragma mark - Private Methods

- (void)updateCornerRadius
{
    NSLog(@"updateCornerRadius");
    
    self.layer.cornerRadius = (floorf(CGRectGetHeight(self.frame))/2.0f);
}

- (CGFloat)stretchedWidth
{
    return (CGRectGetWidth(self.frame)*kDefaultThumbGrowthFactor);
}

- (void)adjustLeadingEdgeForRightSideWithGrowthState:(BOOL)growing
{
    CGFloat superWidth = CGRectGetWidth(self.superview.frame);
    CGFloat selfWidth = CGRectGetWidth(self.frame);
    CGFloat extraWidth  = (selfWidth * kDefaultThumbGrowthFactor);
    CGFloat normalWidth = (superWidth - selfWidth);
    CGFloat growingWidth = (normalWidth + extraWidth - kMagicAlignmentAdjustment);
    CGFloat shrinkingWidth = (normalWidth - extraWidth);
    self.leadingEdgeConstraint.constant = growing ? shrinkingWidth : growingWidth;
}

@end
