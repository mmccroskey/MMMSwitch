//
//  MMMSwitchThumb.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "MMMSwitchThumb.h"

#define notSupportedMessage "This initializer is not supported by this class; please use 'initWithSuperview' instead."

#define kDefaultThumbColor  [UIColor whiteColor];
#define kDefaultBorderColor [UIColor darkGrayColor];
#define kDefaultBorderWidth 1.0f;

@interface MMMSwitchThumb()

@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *leadingEdgeConstraint;

@end

@implementation MMMSwitchThumb

- (instancetype)initWithSuperview:(UIView*)superview
{
    if (self = [super init])
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.backgroundColor = kDefaultThumbColor;
        
        UIColor *borderColor = kDefaultBorderColor;
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = kDefaultBorderWidth;
        
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
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

#pragma mark - Unsupported Initializers

- (instancetype)init __attribute__((unavailable(notSupportedMessage)))
{
    NSAssert(false,[NSString stringWithCString:notSupportedMessage encoding:NSUTF8StringEncoding]);
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable(notSupportedMessage)))
{
    NSAssert(false,[NSString stringWithCString:notSupportedMessage encoding:NSUTF8StringEncoding]);
    return nil;
}

+ (instancetype)new __attribute__((unavailable(notSupportedMessage)))
{
    NSAssert(false,[NSString stringWithCString:notSupportedMessage encoding:NSUTF8StringEncoding]);
    return nil;
}

#pragma mark - Public Methods

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
    self.widthConstraint.constant = growing ? (CGRectGetWidth(self.frame)*0.1f) : 0.0f;
    
    // If we're shrinking and the thumb is on the right side,
    // then it will shrink *away* from the right edge of the switch,
    // so we need to nudge it to the right at the same time to compensate
    if (!(growing) && onRightSide)
    {
        NSLog(@"Shrinking thumb on the right side");
        self.leadingEdgeConstraint.constant += (CGRectGetWidth(self.frame)*0.1f);
    }
    
    [UIView animateWithDuration:0.1f animations:^{ [self layoutIfNeeded]; }];
}

- (void)setOn:(BOOL)on
{
    NSLog(@"thumb: being set to ON?: %d", on);
    if (_on == on) { return; }
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
    [self updateCornerRadius];
}

#pragma mark - Private Methods

- (void)updateCornerRadius
{
    self.layer.cornerRadius = (floorf(CGRectGetHeight(self.frame))/2.0f);
}

@end
