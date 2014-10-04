//
//  MMMSwitch.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "MMMSwitch.h"
#import "MMMSwitchThumb.h"

#define kDefaultOffTrackTintColor [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
#define kDefaultOnTrackTintColor  [UIColor greenColor];
#define kDefaultTrackBorderColor  [UIColor darkGrayColor];
#define kDefaultOnOffAnimationDuration 0.25f

static void * XXContext = &XXContext;

@interface MMMSwitch ()

@property (strong, nonatomic) MMMSwitchThumb *thumb;
@property (strong, nonatomic) UITouch *currentTouch;

@end

@implementation MMMSwitch

#pragma mark - Life-Cycle and KVO Methods

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:NSStringFromSelector(@selector(currentState))
                 context:XXContext];
}

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

- (void)configure
{
    [self addObserver:self
           forKeyPath:NSStringFromSelector(@selector(currentState))
              options:NSKeyValueObservingOptionNew
              context:XXContext];
    
    self.currentState = MMMSwitchStateOff;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.offTrackTintColor = kDefaultOffTrackTintColor;
    self.onTrackTintColor = kDefaultOnTrackTintColor;
    self.trackBorderColor = kDefaultTrackBorderColor;
    
    self.layer.borderWidth = 1.0f;
    
    self.thumb = [[MMMSwitchThumb alloc] initWithSuperview:self];
    
    [self updateCornerRadius];
    
    [self setOn:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    BOOL contextMatches = (context == XXContext);
    BOOL objectMatches = ([object isEqual:self]);
    BOOL keyPathMatches = ([keyPath isEqualToString:NSStringFromSelector(@selector(currentState))]);
    if (contextMatches && objectMatches && keyPathMatches)
    {
        if (self.stateDidChangeHandler)
        {
            id newValue = change[NSKeyValueChangeNewKey];
            if ([newValue isKindOfClass:[NSNumber class]])
            {
                MMMSwitchState newState = [(NSNumber*)newValue integerValue];
                self.stateDidChangeHandler(newState);
            }
        }
    }
}

#pragma mark - Public Methods

- (void)setTrackBorderColor:(UIColor *)trackBorderColor
{
    _trackBorderColor = trackBorderColor;
    self.layer.borderColor = _trackBorderColor.CGColor;
    self.thumb.layer.borderColor = self.layer.borderColor;
}

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
        [UIView animateWithDuration:kDefaultOnOffAnimationDuration animations:^
        {
            [weakSelf setOn:on animated:NO];
            [[(MMMSwitch*)weakSelf thumb] setOn:on];
            [[(MMMSwitch*)weakSelf thumb] layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished && !(self.currentTouch))
            {
                [self.thumb shrinkThumbFromRightSide:self.isOn];
                
                self.currentState = self.isOn ? MMMSwitchStateOn : MMMSwitchStateOff;
            }
        }];
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

- (void)updateCornerRadius
{
    self.layer.cornerRadius = floorf(CGRectGetHeight(self.frame)/2.0f);
}

#pragma mark - Touch Capture and Recognition Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentTouch = [touches anyObject];
    
    self.currentState = self.isOn ? MMMSwitchStateSelectedPressedOn : MMMSwitchStateSelectedPressedOff;
    
    [self.thumb growThumbFromRightSide:self.isOn];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    
    CGFloat oldXPos = [touch previousLocationInView:self].x;
    CGFloat oldYPos = [touch previousLocationInView:self].y;
    BOOL oldXPosOutOfBounds = (oldXPos <= 0 || oldXPos > CGRectGetWidth(self.frame));
    BOOL oldYPosOutOfBounds = (oldYPos <= 0 || oldYPos > CGRectGetHeight(self.frame));
    BOOL wasOutsideOfSelf = (oldXPosOutOfBounds || oldYPosOutOfBounds);
    
    CGFloat newXPos = [touch locationInView:self].x;
    CGFloat newYPos = [touch locationInView:self].y;
    BOOL newXPosOutOfBounds = (newXPos <= 0 || newXPos > CGRectGetWidth(self.frame));
    BOOL newYPosOutOfBounds = (newYPos <= 0 || newYPos > CGRectGetHeight(self.frame));
    BOOL isOutsideOfSelf = (newXPosOutOfBounds || newYPosOutOfBounds);
    
    BOOL onRightSide = (newXPos > (CGRectGetWidth(self.frame)/2.0f));
    
    if (wasOutsideOfSelf && !(isOutsideOfSelf))
    {
        // It used to be outside and now it's inside
        
        [self.thumb growThumbFromRightSide:self.isOn];
        
        self.currentState = onRightSide ? MMMSwitchStateSelectedPressedOn : MMMSwitchStateSelectedPressedOff;
    }
    else if (!(wasOutsideOfSelf) && isOutsideOfSelf)
    {
        // It used to be inside and now it's outside
        
        [self.thumb shrinkThumbFromRightSide:self.isOn];
        
        self.currentState = onRightSide ? MMMSwitchStateSelectedUnpressedOn : MMMSwitchStateSelectedUnpressedOff;
    }
    
    if (onRightSide && !(self.isOn))
    {
        [self setOn:YES animated:YES];
        
        self.currentState = isOutsideOfSelf ? MMMSwitchStateSelectedUnpressedOn : MMMSwitchStateSelectedPressedOn;
    }
    else if (!(onRightSide) && self.isOn)
    {
        [self setOn:NO animated:YES];
        
        self.currentState = isOutsideOfSelf ? MMMSwitchStateSelectedUnpressedOff : MMMSwitchStateSelectedPressedOff;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.thumb shrinkThumbFromRightSide:self.isOn];
    
    self.currentState = self.isOn ? MMMSwitchStateOn : MMMSwitchStateOff;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *endingTouch = touches.anyObject;
    
    CGPoint windowEndTouchLocation = [endingTouch locationInView:self.window];
    CGFloat accuracyBuffer = 1.0f;
    
    CGFloat windowEndTouchX = windowEndTouchLocation.x;
    CGFloat flooredWindowEndTouchX = (windowEndTouchX - accuracyBuffer);
    CGFloat ceiledWindowEndTouchX = (windowEndTouchX + accuracyBuffer);
    CGFloat windowWidth = CGRectGetWidth(self.window.frame);
    BOOL windowEndTouchXOutsideBounds = (flooredWindowEndTouchX < 0.0f || ceiledWindowEndTouchX > windowWidth);
    
    CGFloat windowEndTouchY = windowEndTouchLocation.y;
    CGFloat flooredWindowEndTouchY = (windowEndTouchY - accuracyBuffer);
    CGFloat ceiledWindowEndTouchY = (windowEndTouchY + accuracyBuffer);
    CGFloat windowHeight = CGRectGetHeight(self.window.frame);
    BOOL windowEndTouchYOutsideBounds = (flooredWindowEndTouchY < 0.0f || ceiledWindowEndTouchY > windowHeight);
    
    if (windowEndTouchXOutsideBounds || windowEndTouchYOutsideBounds)
    {
        self.currentState = self.isOn ? MMMSwitchStateOn : MMMSwitchStateOff;
        
        return;
    }
    else
    {
        CGPoint endTouchLocation = [endingTouch locationInView:self];
        CGFloat endTouchX = endTouchLocation.x;
        CGFloat endTouchY = endTouchLocation.y;
        CGFloat thumbXStart = CGRectGetMinX(self.thumb.frame);
        CGFloat thumbXEnd = CGRectGetMaxX(self.thumb.frame);
        CGFloat thumbYStart = CGRectGetMinY(self.thumb.frame);
        CGFloat thumbYEnd = CGRectGetMaxY(self.thumb.frame);
        CGFloat switchXStart = CGRectGetMinX(self.bounds);
        CGFloat switchXEnd = CGRectGetMaxX(self.bounds);
        CGFloat switchYStart = CGRectGetMinY(self.bounds);
        CGFloat switchYEnd = CGRectGetMaxY(self.bounds);
        BOOL touchInsideThumbX = (endTouchX > thumbXStart && endTouchX < thumbXEnd);
        BOOL touchInsideThumbY = (endTouchY > thumbYStart && endTouchY < thumbYEnd);
        BOOL touchInsideThumb = (touchInsideThumbX && touchInsideThumbY);
        BOOL touchInsideSwitchX = (endTouchX > switchXStart && endTouchX < switchXEnd);
        BOOL touchInsideSwitchY = (endTouchY > switchYStart && endTouchY < switchYEnd);
        BOOL touchInsideSwitch = (touchInsideSwitchX && touchInsideSwitchY);
        
        if (touchInsideThumb && touchInsideSwitch)
        {
            self.currentState = self.isOn ? MMMSwitchStateOn : MMMSwitchStateOff;
            
            [self.thumb shrinkThumbFromRightSide:self.isOn];
        }
        else if (!(touchInsideThumb) && touchInsideSwitch)
        {
            [self setOn:!self.isOn animated:YES];
        }
        else if (!(touchInsideSwitch) && !(touchInsideSwitch))
        {
            [self setOn:self.isOn animated:YES];
        }
    }
    
    self.currentTouch = nil;
}

@end
