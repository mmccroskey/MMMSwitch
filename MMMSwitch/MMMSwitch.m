//
//  MMMSwitch.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "MMMSwitch.h"
#import "MMMSwitchThumb.h"

#define notSupportedMessage "This initializer is not supported by this class; please use 'init' instead."

static void * KVOContext = &KVOContext;

@interface MMMSwitch ()

@property (strong, nonatomic) MMMSwitchThumb *thumb;

@property (assign, nonatomic) BOOL switchSizeBeingAnimated;

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

<<<<<<< Updated upstream
- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    
=======
- (void)updateCornerRadiiWithAnimationOfDuration:(NSTimeInterval)duration
{
    NSLog(@"Switch updateCornerRadiiWithAnimationOfDuration");
    
    self.switchSizeBeingAnimated = YES;
    
    [CATransaction begin];
    
    CABasicAnimation *switchAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    switchAnimation.fromValue = @(self.layer.cornerRadius);
    switchAnimation.toValue = @(floorf(CGRectGetHeight(self.frame)/2.0f));
//    switchAnimation.fromValue = @(120);
//    switchAnimation.toValue = @(180);
//    switchAnimation.fromValue = @(10);
//    switchAnimation.toValue = @(400);
    switchAnimation.duration = duration;
    [CATransaction setCompletionBlock:^
    {
        [self updateCornerRadius];
        self.switchSizeBeingAnimated = NO;
    }];
    [self.layer addAnimation:switchAnimation forKey:@"switchCornerRadiusAnimation"];
    
    [self.thumb addCornerRadiusUpdateAnimationWithDuration:duration];
    
    [CATransaction commit];
>>>>>>> Stashed changes
}

#pragma mark - Superclass Override Methods

- (void)refreshCornerRadiiWithAnimationDuration:(NSTimeInterval)animationDuration
{
<<<<<<< Updated upstream
    [super refreshCornerRadiiWithAnimationDuration:animationDuration];
    [self.thumb refreshCornerRadiiWithAnimationDuration:animationDuration];
=======
    [super layoutSubviews];
    
    NSLog(@"Switch layoutSubviews");
    
    if (!self.switchSizeBeingAnimated)
    {
        [self updateCornerRadius];
    }
>>>>>>> Stashed changes
}

#pragma mark - Private Methods

- (void)configure
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.thumb = [[MMMSwitchThumb alloc] init];
    [self addSubview:self.thumb];
    [self.thumb configureLayout];
    
    [self updateCornerRadius];
}

@end
