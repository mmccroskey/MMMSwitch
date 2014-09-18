//
//  MMMRoundedView.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/16/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "MMMRoundedView.h"

@implementation MMMRoundedView

#pragma mark - Public Methods

- (void)refreshCornerRadii
{
    [self refreshCornerRadiiWithAnimationDuration:0];
}

- (void)refreshCornerRadiiWithAnimationDuration:(NSTimeInterval)animationDuration
{
    if (!(animationDuration > 0))
    {
        [self updateCornerRadius];
    }
    else
    {
        NSLog(@"Setting up CATransaction");
        [CATransaction begin];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(cornerRadius))];
        animation.fromValue = @(self.layer.cornerRadius);
        animation.toValue = @(floorf(CGRectGetHeight(self.frame)/2.0f));
        animation.duration = animationDuration;
        [CATransaction setCompletionBlock:^{ [self updateCornerRadius]; }];
        [self.layer addAnimation:animation forKey:nil];
        [CATransaction commit];
    }
}

- (void)updateCornerRadius
{
    self.layer.cornerRadius = floorf(CGRectGetHeight(self.frame)/2.0f);
}

#pragma mark - Auto Layout Methods

- (void)layoutSubviews
{
    NSLog(@"layoutSubviews");
    [super layoutSubviews];
    [self updateCornerRadius];
}

- (void)updateConstraints
{
    NSLog(@"updateConstraints");
    [super updateConstraints];
//    [self updateCornerRadius];
}

@end
