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
@property (weak, nonatomic) IBOutlet MMMSwitch *redSwitch;
@property (weak, nonatomic) IBOutlet MMMSwitch *orangeSwitch;
@property (weak, nonatomic) IBOutlet MMMSwitch *yellowSwitch;
@property (weak, nonatomic) IBOutlet MMMSwitch *greenSwitch;
@property (weak, nonatomic) IBOutlet MMMSwitch *blueSwitch;

@property (assign, nonatomic) CGFloat largeSwitchWidth;
@property (assign, nonatomic) CGFloat smallSwitchWidth;

@property (strong, nonatomic) NSArray *switches;
@property (assign, nonatomic) NSInteger currentSwitch;
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
    
    self.switches = @[self.redSwitch, self.orangeSwitch, self.yellowSwitch, self.greenSwitch, self.blueSwitch];
    self.currentSwitch = 0;
    
    self.redSwitch.onTrackTintColor = self.redSwitch.trackBorderColor = [UIColor redColor];
    self.orangeSwitch.onTrackTintColor = self.orangeSwitch.trackBorderColor = [UIColor orangeColor];
    self.yellowSwitch.onTrackTintColor = self.yellowSwitch.trackBorderColor = [UIColor yellowColor];
    self.greenSwitch.onTrackTintColor = self.greenSwitch.trackBorderColor = [UIColor greenColor];
    self.blueSwitch.onTrackTintColor = self.blueSwitch.trackBorderColor = [UIColor blueColor];
    
    self.largeSwitchWidth = 160.0f;
    self.smallSwitchWidth = 100.0f;
    
    [self.redSwitch setOn:YES];
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
        
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(animate) userInfo:nil repeats:YES];
        [self.animationTimer fire];
    }
}

- (void)stopAnimating
{
    if (self.animationTimer)
    {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        
        [self.redSwitch setOn:YES animated:YES];
        [self.orangeSwitch setOn:NO animated:YES];
        [self.yellowSwitch setOn:NO animated:YES];
        [self.greenSwitch setOn:NO animated:YES];
        [self.blueSwitch setOn:NO animated:YES];

        [self.redSwitch setWidth:self.largeSwitchWidth withAnimationDuration:0.2f];
        [self.orangeSwitch setWidth:self.smallSwitchWidth withAnimationDuration:0.2f];
        [self.yellowSwitch setWidth:self.smallSwitchWidth withAnimationDuration:0.2f];
        [self.greenSwitch setWidth:self.smallSwitchWidth withAnimationDuration:0.2f];
        [self.blueSwitch setWidth:self.smallSwitchWidth withAnimationDuration:0.2f];
        
        self.currentSwitch = 0;
        
        self.view.userInteractionEnabled = YES;
    }
}

- (void)animate
{
    // Turn off the current switch and make it smaller
    MMMSwitch *currentSwitch = self.switches[[self currentSwitch]];
    [currentSwitch setOn:NO animated:YES];
    [currentSwitch setWidth:self.smallSwitchWidth withAnimationDuration:1.0f];
     
    // Turn on the next switch and make it bigger
    MMMSwitch *nextSwitch = self.switches[[self nextSwitch]];
    [nextSwitch setOn:YES animated:YES];
    [nextSwitch setWidth:self.largeSwitchWidth withAnimationDuration:1.0f];
    
    self.currentSwitch = [self nextSwitch];
}

- (NSInteger)nextSwitch
{
    return (self.currentSwitch == 4) ? 0 : (self.currentSwitch+1);
}

@end
