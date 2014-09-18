//
//  MMMRoundedView.h
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/16/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMRoundedView : UIControl

- (void)refreshCornerRadii;
- (void)refreshCornerRadiiWithAnimationDuration:(NSTimeInterval)animationDuration;
- (void)updateCornerRadius;

@end
