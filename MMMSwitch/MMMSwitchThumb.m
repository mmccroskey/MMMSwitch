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
                                                 toItem:superview
                                                 attribute:NSLayoutAttributeCenterY
                                                 multiplier:1.0f
                                                 constant:0.0f];
        [superview addConstraint:centerYConstraint];
        
        // Thumb's leading edge should start out matching its parent (it will move on switch on/off)
        NSLayoutConstraint *leadingEdgeConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:superview
                                                     attribute:NSLayoutAttributeLeading
                                                     multiplier:1.0f
                                                     constant:0.0f];
        [superview addConstraint:leadingEdgeConstraint];
        
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
