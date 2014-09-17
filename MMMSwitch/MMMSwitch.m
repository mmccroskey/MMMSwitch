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

#pragma mark - KVO Methods

- (void)dealloc
{
    [self       removeObserver:self forKeyPath:NSStringFromSelector(@selector(frame))];
    [self.layer removeObserver:self forKeyPath:NSStringFromSelector(@selector(bounds))];
    [self.layer removeObserver:self forKeyPath:NSStringFromSelector(@selector(transform))];
    [self.layer removeObserver:self forKeyPath:NSStringFromSelector(@selector(position))];
    [self.layer removeObserver:self forKeyPath:NSStringFromSelector(@selector(zPosition))];
    [self.layer removeObserver:self forKeyPath:NSStringFromSelector(@selector(anchorPoint))];
    [self.layer removeObserver:self forKeyPath:NSStringFromSelector(@selector(anchorPointZ))];
    [self.layer removeObserver:self forKeyPath:NSStringFromSelector(@selector(frame))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == KVOContext)
    {
//        BOOL selfFrame = [keyPath isEqualToString:NSStringFromSelector(@selector(frame))];
        BOOL bounds = [keyPath isEqualToString:NSStringFromSelector(@selector(bounds))];
        BOOL transform = [keyPath isEqualToString:NSStringFromSelector(@selector(transform))];
        BOOL position = [keyPath isEqualToString:NSStringFromSelector(@selector(position))];
        BOOL zPosition = [keyPath isEqualToString:NSStringFromSelector(@selector(zPosition))];
        BOOL anchorPoint = [keyPath isEqualToString:NSStringFromSelector(@selector(anchorPoint))];
        BOOL anchorPointZ = [keyPath isEqualToString:NSStringFromSelector(@selector(anchorPointZ))];
        BOOL frame = [keyPath isEqualToString:NSStringFromSelector(@selector(frame))];
        if (bounds || transform || position || zPosition || anchorPoint || anchorPointZ || frame)
        {
            NSLog(@"frame changed");
//            [CATransaction begin];
//            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(cornerRadius))];
//            animation.fromValue = @(self.layer.cornerRadius);
//            animation.toValue = @(floorf(CGRectGetHeight(self.frame)/2.0f));
//            animation.duration = 6.0f;
//            [CATransaction setCompletionBlock:^{ [self updateLayout]; }];
//            [self.layer addAnimation:animation forKey:nil];
//            [CATransaction commit];
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

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

#pragma mark - Auto Layout Methods

//- (void)layoutSubviews
//{
//    [self updateLayout];
//}
//
//- (void)updateConstraints
//{
//    [super updateConstraints];
//    [self updateLayout];
//}



#pragma mark - Private Methods

- (void)configure
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.thumb = [[MMMSwitchThumb alloc] init];
    [self addSubview:self.thumb];
    [self.thumb configureLayout];
    
    [self addObserver:self
           forKeyPath:NSStringFromSelector(@selector(frame))
              options:NSKeyValueObservingOptionNew
              context:KVOContext];
    
    [self.layer addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(bounds))
                    options:NSKeyValueObservingOptionNew
                    context:KVOContext];
    
    [self.layer addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(transform))
                    options:NSKeyValueObservingOptionNew
                    context:KVOContext];
    
    [self.layer addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(position))
                    options:NSKeyValueObservingOptionNew
                    context:KVOContext];
    
    [self.layer addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(zPosition))
                    options:NSKeyValueObservingOptionNew
                    context:KVOContext];
    
    [self.layer addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(anchorPoint))
                    options:NSKeyValueObservingOptionNew
                    context:KVOContext];
    
    [self.layer addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(anchorPointZ))
                    options:NSKeyValueObservingOptionNew
                    context:KVOContext];
    
    [self.layer addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(frame))
                    options:NSKeyValueObservingOptionNew
                    context:KVOContext];
    
    [self updateLayout];
}

- (void)updateLayout
{
    self.layer.cornerRadius = floorf(CGRectGetHeight(self.frame)/2.0f);
}

@end
