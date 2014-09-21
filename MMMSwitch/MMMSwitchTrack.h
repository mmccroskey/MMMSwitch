//
//  MMMSwitchTrack.h
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMSwitchTrack : UIView

@property (nonatomic, getter=isOn) BOOL on;
@property (nonatomic, strong) UIColor *offTintColor;
@property (nonatomic, strong) UIColor *onTintColor;

- (id)initWithOnTintColor:(UIColor*)onTintColor
             offTintColor:(UIColor*)offTintColor
                superview:(UIView*)superview;

- (void)setOn:(BOOL) on
     animated:(BOOL) animated;

@end
