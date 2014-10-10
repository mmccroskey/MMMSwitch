//
//  MMMSwitch.h
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMSwitch : UIControl

/*
 
 At all times, the switch is in one of six states detailed below. Each state indicates:
 1. Whether the switch is currently in the off or on position (`Off` vs. `On`)
 2. Whether the user is in the middle of an interaction with the switch (`Selected` vs. `Unselected`)
 3. Whether the user is actually pressing the switch (`Pressed` vs. `Unpressed`)
 
 
 MMMSwitchStateOff - The switch is completely off, and the user
 is not interacting with it in any way
 
 MMMSwitchStateSelectedUnpressedOff - The user has touched down
 on the switch (either on the thumb or elsewhere), hasn't yet touched
 up, but has drug their finger off of the switch, and the switch is 
 in the off position
 
 MMMSwitchStateSelectedPressedOff - The user has touched down
 on the switch (either on the thumb or elsewhere), hasn't yet touched
 up, has kept their finger within the bounds of the switch (as opposed 
 to dragging it outside the bounds), and the switch is in the off position
 
 MMMSwitchStateSelectedUnpressedOn - The user has touched down
 on the switch (either on the thumb or elsewhere), hasn't yet touched
 up, but has drug their finger off of the switch, and the switch is
 in the on position
 
 MMMSwitchStateSelectedPressedOn - The user has touched down
 on the switch (either on the thumb or elsewhere), hasn't yet touched
 up, has kept their finger within the bounds of the switch (as opposed
 to dragging it outside the bounds), and the switch is in the on position
 
 MMMSwitchStateOn - The switch is completely on, and the user
 is not interacting with it in any way
 
 */
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

// Custom completion block initiated by value change
@property(nonatomic, copy) MMMSwitchStateDidChangeHandler stateDidChangeHandler;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
