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

#pragma mark - Superclass Override Methods

- (void)refreshCornerRadiiWithAnimationDuration:(NSTimeInterval)animationDuration
{
    [super refreshCornerRadiiWithAnimationDuration:animationDuration];
    [self.thumb refreshCornerRadiiWithAnimationDuration:animationDuration];
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
