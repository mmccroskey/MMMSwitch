//
//  MMMSwitch.h
//  MMMSwitch
//
// Copyright (c) 2014 Matthew McCroskey (http://matthewmccroskey.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) MMMSwitchState currentState;

// Custom completion block initiated by value change
@property(nonatomic, copy) MMMSwitchStateDidChangeHandler stateDidChangeHandler;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)setWidth:(CGFloat)width withAnimationDuration:(CGFloat)animationDuration;

@end
