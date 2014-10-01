
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

@interface MMMSwitchThumb()

@property (assign, nonatomic) BOOL layoutHasBeenConfigured;

@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *leadingEdgeConstraint;
@property (strong, nonatomic) NSLayoutConstraint *trailingEdgeConstraint;

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
    
    // When the switch is off, thumb's leading edge should match its parent
    // (We'll start off this way)
    self.leadingEdgeConstraint = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superview
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1.0f
                                                               constant:0.0f];
    [superview addConstraint:self.leadingEdgeConstraint];
    
    // When the switch is on, thumb's trailing edge should match its parent
    // (We'll switch to this one when switch turns on)
    self.trailingEdgeConstraint = [NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeTrailing
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:superview
                                                               attribute:NSLayoutAttributeTrailing
                                                              multiplier:1.0f
                                                                constant:0.0f];
    
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
    self.layer.cornerRadius = (floorf(CGRectGetHeight(self.frame))/2.0f);
}

@end
