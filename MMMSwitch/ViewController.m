//
//  ViewController.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "ViewController.h"
#import "MMMSwitch.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchWidthConstraint;
@property (weak, nonatomic) IBOutlet MMMSwitch *theSwitch;
@property (weak, nonatomic) IBOutlet UIView *colorSquare;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.theSwitch.stateDidChangeHandler = ^(MMMSwitchState newState)
    {
        CGFloat colorLevel;
        
        switch (newState)
        {
            case MMMSwitchStateOff:
                colorLevel = (0.0f/5.0f);
                NSLog(@"The switch is off");
                break;
                
            case MMMSwitchStateSelectedUnpressedOff:
                colorLevel = (1.0f/5.0f);
                NSLog(@"The switch is selected, unpressed, and off");
                break;
                
            case MMMSwitchStateSelectedPressedOff:
                colorLevel = (2.0f/5.0f);
                NSLog(@"The switch is selected, pressed, and off");
                break;
                
            case MMMSwitchStateSelectedUnpressedOn:
                colorLevel = (3.0f/5.0f);
                NSLog(@"The switch is selected, unpressed, and on");
                break;
                
            case MMMSwitchStateSelectedPressedOn:
                colorLevel = (4.0f/5.0f);
                NSLog(@"The switch is selected, pressed, and on");
                break;
                
            case MMMSwitchStateOn:
                colorLevel = (5.0f/5.0f);
                NSLog(@"The switch is on");
                break;
                
            default:
                break;
        }
        
        [UIView animateWithDuration:0.1f animations:^
        {
            self.colorSquare.backgroundColor = [UIColor colorWithRed:colorLevel green:colorLevel blue:colorLevel alpha:1.0f];
        }];
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
