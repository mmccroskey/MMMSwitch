//
//  MMMSwitch.h
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMSwitch : UIControl

typedef NS_ENUM(NSUInteger, MMMSwitchState)
{
    MMMSwitchStateOff,
    MMMSwitchStateSelectedUnpressedOff,
    MMMSwitchStateSelectedPressedOff,
    MMMSwitchStateSelectedUnpressedOn,
    MMMSwitchStateSelectedPressedOn,
    MMMSwitchStateOn
};

typedef void(^MMMSwitchStateDidChangeHandler)(MMMSwitchState newState);

@property (nonatomic, strong) UIColor *offTrackTintColor;
@property (nonatomic, strong) UIColor *onTrackTintColor;
@property (nonatomic, strong) UIColor *trackBorderColor;
@property (nonatomic, strong) UIColor *thumbColor;

@property (nonatomic, assign, getter=isOn) BOOL on;
@property (nonatomic, assign) MMMSwitchState currentState;

// Custom completion block initiated by value change (on/off)
@property(nonatomic, copy) MMMSwitchStateDidChangeHandler stateDidChangeHandler;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
