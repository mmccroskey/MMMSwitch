//
//  MMMSwitchThumb.h
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMRoundedView.h"

typedef NS_ENUM(NSUInteger, MMMSwitchThumbJustification)
{
    MMMSwitchThumbJustificationLeft,
    MMMSwitchThumbJustificationRight
};

@interface MMMSwitchThumb : MMMRoundedView

@property (nonatomic, assign) BOOL isTracking;

- (void)configureLayout;
- (void)growThumbWithJustification:(MMMSwitchThumbJustification)justification;
- (void)shrinkThumbWithJustification:(MMMSwitchThumbJustification)justification;

@end
