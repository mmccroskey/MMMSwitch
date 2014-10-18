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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchWidthConstraint;
@property (weak, nonatomic) IBOutlet MMMSwitch *theSwitch;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateLabelVerticalSpacingConstraint;


@end

@implementation DescriptiveStateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
//    CGFloat switchHeight = CGRectGetHeight(self.theSwitch.frame);
//    CGFloat labelHeight = CGRectGetHeight(self.stateLabel.frame);
//    self.stateLabelVerticalSpacingConstraint.constant = floorf((viewHeight - switchHeight - labelHeight)/2.0f);
    
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
    
//    [self performSelector:@selector(increaseWidth) withObject:nil afterDelay:3.0f];.
}

- (void)increaseWidth
{
    self.switchWidthConstraint.constant *= 1.2;
    [self.view layoutIfNeeded];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection
              withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    self.theSwitch.alpha = 0.0f;
//    [UIView animateWithDuration:0.1f animations:^{ self.theSwitch.alpha = 0.0f; }];
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        [UIView animateWithDuration:0.1f animations:^{ self.theSwitch.alpha = 1.0f; }];
    }];
}

@end
