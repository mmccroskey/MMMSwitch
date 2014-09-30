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
<<<<<<< Updated upstream
//    [self.view layoutIfNeeded];
    [UIView animateWithDuration:10.0f
                     animations:^{
                         NSLog(@"animate!");
                         self.switchWidthConstraint.constant *= 1.2;
                         [self.view layoutIfNeeded];
                         [self.theSwitch refreshCornerRadiiWithAnimationDuration:10.0f];
                     }
                     completion:nil];
    
//    self.switchWidthConstraint.constant *= 1.2;
//    [self.view layoutIfNeeded];
//    [self.theSwitch refreshCornerRadiiWithAnimationDuration:0];
=======
    [self.theSwitch updateCornerRadiiWithAnimationOfDuration:3.0f];
//    [UIView animateWithDuration:3.0f animations:^
//    {
//        self.switchWidthConstraint.constant *= 1.2;
//        [self.view layoutIfNeeded];
//    }];
    
    self.switchWidthConstraint.constant *= 1.2f;
    [UIView animateKeyframesWithDuration:3.0f
                                   delay:0.0f
                                 options:0 animations:^
    {
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{ [self.view layoutIfNeeded]; }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{ [self.theSwitch updateCornerRadiiWithAnimationOfDuration:1.5f]; }];
    } completion:nil];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection
              withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"transitioning!!!");
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        NSLog(@"transition duration: %f", [context transitionDuration]);
        [self.theSwitch updateCornerRadiiWithAnimationOfDuration:[context transitionDuration]];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"animations complete");
    }];
>>>>>>> Stashed changes
}

@end
