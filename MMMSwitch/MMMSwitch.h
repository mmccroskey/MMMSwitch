//
//  MMMSwitch.h
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMSwitch : UIControl

typedef void(^MMMSwitchDidChangeHandler)(BOOL isOn);

@property(nonatomic, strong) UIColor *offTrackTintColor;
@property(nonatomic, strong) UIColor *onTrackTintColor;

@property(nonatomic, getter=isOn) BOOL on;

// Custom completion block initiated by value change (on/off)
@property(nonatomic, copy) MMMSwitchDidChangeHandler didChangeHandler;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)updateCornerRadiiWithAnimationOfDuration:(NSTimeInterval)duration;

@end
