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
    
    self.switches = @[self.orangeSwitch, self.redSwitch, self.purpleSwitch, self.blueSwitch];
    self.currentSwitch = 0;
    
    self.orangeSwitch.onTrackTintColor = self.orangeSwitch.trackBorderColor = [UIColor orangeColor];
    self.redSwitch.onTrackTintColor = self.redSwitch.trackBorderColor = [UIColor redColor];
    self.purpleSwitch.onTrackTintColor = self.purpleSwitch.trackBorderColor = [UIColor purpleColor];
    self.blueSwitch.onTrackTintColor = self.blueSwitch.trackBorderColor = [UIColor blueColor];
    
    self.largeSwitchWidth = 160.0f;
    self.smallSwitchWidth = 100.0f;
    
    [self.orangeSwitch setOn:YES];
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
        
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.25f target:self selector:@selector(animate) userInfo:nil repeats:YES];
        [self.animationTimer fire];
    }
}

- (void)stopAnimating
{
    if (self.animationTimer)
    {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        
        [self.orangeSwitch setOn:YES animated:YES];
        [self.redSwitch setOn:NO animated:YES];
        [self.purpleSwitch setOn:NO animated:YES];
        [self.blueSwitch setOn:NO animated:YES];

        [self.orangeSwitch setWidth:self.largeSwitchWidth withAnimationDuration:0.2f];
        [self.redSwitch setWidth:self.smallSwitchWidth withAnimationDuration:0.2f];
        [self.purpleSwitch setWidth:self.smallSwitchWidth withAnimationDuration:0.2f];
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
    return (self.currentSwitch == 3) ? 0 : (self.currentSwitch+1);
}

@end
