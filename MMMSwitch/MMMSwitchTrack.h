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
@property (nonatomic, strong) UIColor *contrastColor;
@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;

- (id)initWithOnColor:(UIColor*) onColor
             offColor:(UIColor*) offColor
        contrastColor:(UIColor*) contrastColor;

- (void)setOn:(BOOL) on
     animated:(BOOL) animated;

@end
