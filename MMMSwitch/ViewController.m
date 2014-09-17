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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSelector:@selector(increaseWidth) withObject:nil afterDelay:3.0f];
}

- (void)increaseWidth
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:6.0f
                     animations:^{
                         NSLog(@"animate!");
                         self.switchWidthConstraint.constant *= 1.2;
                         [self.view layoutIfNeeded];
                         [self.theSwitch refreshCornerRadiiWithAnimationDuration:6.0f];
                     }
                     completion:nil];
    
//    self.switchWidthConstraint.constant *= 1.2;
//    [self.view layoutIfNeeded];
//    [self.theSwitch refreshCornerRadiiWithAnimationDuration:0];
}

@end
