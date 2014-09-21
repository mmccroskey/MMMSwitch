//
//  MMMSwitch.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "MMMSwitch.h"
#import "MMMSwitchTrack.h"
#import "MMMSwitchThumb.h"

#define kDefaultOffTrackTintColor [UIColor orangeColor];
#define kDefaultOnTrackTintColor  [UIColor greenColor];
#define kDefaultTrackBorderColor  [UIColor darkGrayColor];
#define kDefaultOnOffAnimationDuration 0.25f

@interface MMMSwitch ()

@property (strong, nonatomic) MMMSwitchTrack *track;
@property (strong, nonatomic) MMMSwitchThumb *thumb;

@end

@implementation MMMSwitch

#pragma mark - Initializers

- (instancetype)init
{
    if (self = [super init])
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self configure];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)setOn:(BOOL)on
{
    self.backgroundColor = on ? self.onTrackTintColor : self.offTrackTintColor;
    
    _on = on;
    
    if (self.didChangeHandler)
    {
        self.didChangeHandler(_on);
    }
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (animated)
    {
        __weak id weakSelf = self;
        [UIView animateWithDuration:kDefaultOnOffAnimationDuration animations:^
        {
            [weakSelf setOn:on animated:NO];
            [[(MMMSwitch*)weakSelf thumb] setOn:on];
            [[(MMMSwitch*)weakSelf thumb] layoutIfNeeded];
        }];
    }
    else
    {
        [self setOn:on];
        [self.thumb setOn:on];
    }
}

- (void)setTrackBorderColor:(UIColor *)trackBorderColor
{
    _trackBorderColor = trackBorderColor;
    self.layer.borderColor = _trackBorderColor.CGColor;
}

#pragma mark - Auto Layout Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateCornerRadius];
}

#pragma mark - Configuration Methods

- (void)configure
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.offTrackTintColor = kDefaultOffTrackTintColor;
    self.onTrackTintColor = kDefaultOnTrackTintColor;
    self.trackBorderColor = kDefaultTrackBorderColor;
    
    self.layer.borderWidth = 1.0f;
    
    self.thumb = [[MMMSwitchThumb alloc] initWithSuperview:self];
    
    [self updateCornerRadius];
    
    [self setOn:NO];
}

- (void)updateCornerRadius
{
    self.layer.cornerRadius = floorf(CGRectGetHeight(self.frame)/2.0f);
}

#pragma mark - Touch Capture and Recognition Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.thumb growThumbFromRightSide:self.isOn];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGFloat xPos = [touch locationInView:self].x;
    BOOL onRightSide = (xPos > (CGRectGetWidth(self.frame)/2.0f));
    if (onRightSide && !(self.isOn))
    {
        [self setOn:YES animated:YES];
    }
    else if (!(onRightSide) && self.isOn)
    {
        [self setOn:NO animated:YES];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.thumb shrinkThumbFromRightSide:self.isOn];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.thumb shrinkThumbFromRightSide:self.isOn];
}

@end
