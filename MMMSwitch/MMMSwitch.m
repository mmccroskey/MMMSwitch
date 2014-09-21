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

#define notSupportedMessage "This initializer is not supported by this class; please use 'init' instead."

#define kDefaultOffTrackTintColor [UIColor orangeColor];
#define kDefaultOnTrackTintColor  [UIColor greenColor];

static void * KVOContext = &KVOContext;

@interface MMMSwitch () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) MMMSwitchTrack *track;
@property (strong, nonatomic) MMMSwitchThumb *thumb;

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;

@end

@implementation MMMSwitch

#pragma mark - Supported Initializers

- (instancetype)init
{
    if (self =  [super init])
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self =  [super initWithCoder:aDecoder])
    {
        [self configure];
    }
    
    return self;
}

#pragma mark - Unsupported Initializers

- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable(notSupportedMessage)))
{
    NSAssert(false,[NSString stringWithCString:notSupportedMessage encoding:NSUTF8StringEncoding]);
    return nil;
}

+ (instancetype)new __attribute__((unavailable(notSupportedMessage)))
{
    NSAssert(false,[NSString stringWithCString:notSupportedMessage encoding:NSUTF8StringEncoding]);
    return nil;
}

#pragma mark - Public Methods

- (void)setOn:(BOOL)on
{
    self.backgroundColor = on ? self.onTrackTintColor : self.offTrackTintColor;
    
    _on = on;
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (animated)
    {
        __weak id weakSelf = self;
        //First animate the color switch
        [UIView animateWithDuration: 0.25f
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [weakSelf setOn: on
                                    animated: NO];
                             NSLog(@"Inside animation block, setting thumb to %d", on);
                             [[(MMMSwitch*)weakSelf thumb] setOn:on];
                             [[(MMMSwitch*)weakSelf thumb] layoutIfNeeded];
                         }
                         completion:nil];
    }
    else
    {
        [self setOn:on];
        [self.thumb setOn:on];
    }
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
//    self.clipsToBounds = YES;
    self.offTrackTintColor = kDefaultOffTrackTintColor;
    self.onTrackTintColor = kDefaultOnTrackTintColor;
    
    self.thumb = [[MMMSwitchThumb alloc] initWithSuperview:self];
//    self.track = [[MMMSwitchTrack alloc] initWithOnTintColor:self.onTrackTintColor
//                                                offTintColor:self.offTrackTintColor
//                                                   superview:self];
    
//    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
//    self.tapRecognizer.delegate = self;
//    [self addGestureRecognizer:self.tapRecognizer];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan)];
    self.panRecognizer.delegate = self;
//    [self addGestureRecognizer:self.panRecognizer];
    
    [self updateCornerRadius];
    
    [self setOn:NO];
}

- (void)updateCornerRadius
{
    self.layer.cornerRadius = floorf(CGRectGetHeight(self.frame)/2.0f);
}

#pragma mark - Gesture Recognizer Callback Methods

- (void)didTap
{
    NSLog(@"Tap occurred");
    [self.track setOn:!self.track.isOn animated:YES];
}

- (void)didPan
{
    NSLog(@"Pan occurred");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch down occurred");
    [self.thumb growThumbFromRightSide:self.isOn];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"on? %d", self.isOn);
    
    UITouch *touch = touches.anyObject;
    CGFloat xPos = [touch locationInView:self].x;
    BOOL onRightSide = (xPos > (CGRectGetWidth(self.frame)/2.0f));
    NSLog(@"onRightSide? %d", onRightSide);
    if (onRightSide && !(self.isOn))
    {
        NSLog(@"onRightSide and off");
        [self setOn:YES animated:YES];
    }
    else if (!(onRightSide) && self.isOn)
    {
        NSLog(@"onLeftSide and on");
        [self setOn:NO animated:YES];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch cancel occurred");
    [self.thumb shrinkThumbFromRightSide:self.isOn];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch up occurred");
    [self.thumb shrinkThumbFromRightSide:self.isOn];
}

@end
