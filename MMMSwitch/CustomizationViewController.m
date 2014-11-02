//
//  CustomizationViewController.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 10/26/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "CustomizationViewController.h"
#import "MMMSwitch.h"

@interface CustomizationViewController ()

@property (weak, nonatomic) IBOutlet MMMSwitch *customizableSwitch;

@property (weak, nonatomic) IBOutlet UIView *leftColorView;
@property (weak, nonatomic) IBOutlet UIView *rightColorView;

@property (weak, nonatomic) IBOutlet UISlider *colorSlider;
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;

@end

@implementation CustomizationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Make the color views circular
    self.leftColorView.layer.cornerRadius = floorf(CGRectGetWidth(self.leftColorView.frame)/2.0f);
    self.rightColorView.layer.cornerRadius = floorf(CGRectGetWidth(self.rightColorView.frame)/2.0f);
    
    // Initialize the state of the switch with the initial sliders' states
    [self updateSwitchColorForSliderPosition:self.colorSlider.value];
    [self updateSwitchSizeForSliderPosition:self.sizeSlider.value];
}

- (IBAction)colorSliderChanged:(UISlider *)sender
{
    [self updateSwitchColorForSliderPosition:sender.value];
}

- (IBAction)sizeSliderChanged:(UISlider *)sender
{
    [self updateSwitchSizeForSliderPosition:sender.value];
}

- (void)updateSwitchColorForSliderPosition:(CGFloat)position
{
    self.customizableSwitch.onTrackTintColor =
    self.customizableSwitch.trackBorderColor =
    [UIColor colorWithHue:position
               saturation:1.0f
               brightness:1.0f
                    alpha:1.0f];
}

- (void)updateSwitchSizeForSliderPosition:(CGFloat)position
{
    self.customizableSwitch.width = ((200*position)+100);
}

@end
