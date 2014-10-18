//
//  DescriptiveStateViewController.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "DescriptiveStateViewController.h"
#import "MMMSwitch.h"

@interface DescriptiveStateViewController ()

@property (weak, nonatomic) IBOutlet MMMSwitch *theSwitch;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@end

@implementation DescriptiveStateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.theSwitch.stateDidChangeHandler = ^(MMMSwitchState newState)
    {
        NSString *labelText;
        
        switch (newState)
        {
            case MMMSwitchStateOff:
                labelText = @"The switch is off";
                break;
                
            case MMMSwitchStateSelectedUnpressedOff:
                labelText = @"The switch is selected, unpressed, and off";
                break;
                
            case MMMSwitchStateSelectedPressedOff:
                labelText = @"The switch is selected, pressed, and off";
                break;
                
            case MMMSwitchStateSelectedUnpressedOn:
                labelText = @"The switch is selected, unpressed, and on";
                break;
                
            case MMMSwitchStateSelectedPressedOn:
                labelText = @"The switch is selected, pressed, and on";
                break;
                
            case MMMSwitchStateOn:
                labelText = @"The switch is on";
                break;
                
            default:
                break;
        }
        
        self.stateLabel.text = labelText;
    };
}

@end
