//
//  MMMSwitchThumb.h
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMSwitchThumb : UIView

@property (nonatomic, assign, getter=isOn) BOOL on;

@property (strong, nonatomic) UIColor *thumbColor;


- (instancetype)initWithSuperview:(UIView*)superview;

- (void)configureLayoutRelativeToSuperview:(UIView*)superview;

- (void)growThumbFromRightSide:(BOOL)onRightSide;
- (void)shrinkThumbFromRightSide:(BOOL)onRightSide;

@end
