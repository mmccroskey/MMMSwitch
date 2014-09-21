//
//  MMMSwitchTrack.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "MMMSwitchTrack.h"
#import <QuartzCore/QuartzCore.h>

#define notSupportedMessage "This initializer is not supported by this class; please use 'initWithOnTintColor:offTintColor:superview' instead."

@implementation MMMSwitchTrack

#pragma mark - Supported Initializers

- (id)initWithOnTintColor:(UIColor*)onTintColor
             offTintColor:(UIColor*)offTintColor
                superview:(UIView*)superview
{
    if (self = [super init])
    {
        _onTintColor = onTintColor;
        _offTintColor = offTintColor;
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [superview addSubview:self];
        [superview sendSubviewToBack:self];
        
        NSArray *edges = @[@(NSLayoutAttributeLeading), @(NSLayoutAttributeTop), @(NSLayoutAttributeTrailing), @(NSLayoutAttributeBottom)];
        for (NSNumber *attributeNumber in edges)
        {
            NSLayoutAttribute attribute = (NSLayoutAttribute)attributeNumber.integerValue;
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                          attribute:attribute
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:superview
                                                                          attribute:attribute
                                                                         multiplier:1.0f
                                                                           constant:0.0f];
            [superview addConstraint:constraint];
        }
        
        // "Activate" the background color
        [self setOn:self.isOn];
    
        
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

- (void)updateConstraints
{
    [super updateConstraints];
    [self updateCornerRadius];
}

- (void)updateCornerRadius
{
    self.layer.cornerRadius = (self.frame.size.height/2.0f);
}

- (void)setOn:(BOOL)on
{
    self.backgroundColor = on ? self.onTintColor : self.offTintColor;
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (animated)
    {
        __weak id weakSelf = self;
        //First animate the color switch
        [UIView animateWithDuration: 0.25f
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [weakSelf setOn: on
                                    animated: NO];
                         }
                         completion:nil];
    }
    else
    {
        [self setOn:on];
    }
}


@end
