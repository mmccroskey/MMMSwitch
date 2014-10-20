//
//  CustomColorsViewController.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 10/18/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "CustomColorsViewController.h"
#import "MMMSwitch.h"

@interface CustomColorsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *startStopButton;
@property (weak, nonatomic) IBOutlet MMMSwitch *orangeSwitch;
@property (weak, nonatomic) IBOutlet MMMSwitch *redSwitch;
@property (weak, nonatomic) IBOutlet MMMSwitch *purpleSwitch;
@property (weak, nonatomic) IBOutlet MMMSwitch *blueSwitch;

@property (strong, nonatomic) NSArray *switches;
@property (assign, nonatomic) NSInteger nextSwitchToAnimate;
@property (strong, nonatomic) NSTimer *animationTimer;

@end

@implementation CustomColorsViewController

- (void)dealloc
{
    [self stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.switches = @[self.orangeSwitch, self.redSwitch, self.purpleSwitch, self.blueSwitch];
    self.nextSwitchToAnimate = 0;
    
    self.orangeSwitch.onTrackTintColor = self.orangeSwitch.trackBorderColor = [UIColor orangeColor];
    self.redSwitch.onTrackTintColor = self.redSwitch.trackBorderColor = [UIColor redColor];
    self.purpleSwitch.onTrackTintColor = self.purpleSwitch.trackBorderColor = [UIColor purpleColor];
    self.blueSwitch.onTrackTintColor = self.blueSwitch.trackBorderColor = [UIColor blueColor];
    
    [self performSelector:@selector(grow) withObject:nil afterDelay:1.5f];
}

- (void)grow
{
    [self.redSwitch setWidth:self.redSwitch.width*2.0f animated:YES];
    [self performSelector:@selector(shrink) withObject:nil afterDelay:3.0f];
}

- (void)shrink
{
    [self.redSwitch setWidth:self.redSwitch.width/2.0f animated:NO];
}

- (IBAction)toggleAnimation:(id)sender
{
    if (self.animationTimer)
    {
        self.startStopButton.title = @"Start";
        [self stopAnimating];
    }
    else
    {
        self.startStopButton.title = @"Stop";
        [self startAnimating];
    }
}

- (void)startAnimating
{
    if (!self.animationTimer)
    {
        self.view.userInteractionEnabled = NO;
        
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(animate) userInfo:nil repeats:YES];
        [self.animationTimer fire];
    }
}

- (void)stopAnimating
{
    if (self.animationTimer)
    {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        
        [self.orangeSwitch setOn:NO animated:YES];
        [self.redSwitch setOn:NO animated:YES];
        [self.purpleSwitch setOn:NO animated:YES];
        [self.blueSwitch setOn:NO animated:YES];
        
        self.nextSwitchToAnimate = 0;
        
        self.view.userInteractionEnabled = YES;
    }
}

- (void)animate
{
    MMMSwitch *switchToAnimate = self.switches[self.nextSwitchToAnimate];
    [switchToAnimate setOn:!(switchToAnimate.isOn) animated:YES];
    
    self.nextSwitchToAnimate = (self.nextSwitchToAnimate == 3) ? 0 : (self.nextSwitchToAnimate + 1);
}

@end
