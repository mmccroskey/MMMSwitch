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
