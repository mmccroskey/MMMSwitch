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

static void * KVOContext = &KVOContext;

@interface MMMSwitch ()

@property (strong, nonatomic) MMMSwitchTrack *track;
@property (strong, nonatomic) MMMSwitchThumb *thumb;

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

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    
}

- (void)refreshCornerRadii
{
    [self refreshCornerRadiiWithAnimationDuration:0];
}

- (void)refreshCornerRadiiWithAnimationDuration:(NSTimeInterval)animationDuration
{
    if (!(animationDuration > 0))
    {
        [self updateLayout];
    }
    else
    {
        [CATransaction begin];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(cornerRadius))];
        animation.fromValue = @(self.layer.cornerRadius);
        animation.toValue = @(floorf(CGRectGetHeight(self.frame)/2.0f));
        animation.duration = animationDuration;
        [CATransaction setCompletionBlock:^{ [self updateLayout]; }];
        [self.layer addAnimation:animation forKey:nil];
        [CATransaction commit];
    }
}

#pragma mark - Private Methods

- (void)configure
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.thumb = [[MMMSwitchThumb alloc] init];
    [self addSubview:self.thumb];
    [self.thumb configureLayout];
    
    [self updateLayout];
}

- (void)updateLayout
{
    self.layer.cornerRadius = floorf(CGRectGetHeight(self.frame)/2.0f);
}

@end
