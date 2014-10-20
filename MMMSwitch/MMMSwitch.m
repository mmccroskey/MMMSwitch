//
//  MMMSwitch.m
//  MMMSwitch
//
// Copyright (c) 2014 Matthew McCroskey (http://matthewmccroskey.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MMMSwitch.h"


#pragma mark - MMMSwitchThumb Class


#define kDefaultThumbColor [UIColor whiteColor];
#define kDefaultThumbGrowShrinkAnimationDuration 0.1f
#define kDefaultThumbGrowthFactor 0.1f

@interface MMMSwitchThumb : UIView

@property (nonatomic, assign, getter=isOn) BOOL on;

@property (strong, nonatomic) UIColor *thumbColor;

@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *leadingEdgeConstraint;
@property (strong, nonatomic) NSLayoutConstraint *trailingEdgeConstraint;

- (instancetype)initWithSuperview:(UIView*)superview;

- (void)grow;
- (void)shrink;

@end

@implementation MMMSwitchThumb

- (instancetype)initWithSuperview:(UIView*)superview
{
    if (self = [super init])
    {
        NSAssert(superview, @"This method requires that superview not be nil.");
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.backgroundColor = kDefaultThumbColor;
        
        // Thumb inherits its borders from the switch as a whole
        self.layer.borderWidth = superview.layer.borderWidth;
        self.layer.borderColor = superview.layer.borderColor;
        
        [superview addSubview:self];
        
        // Thumb's height should always match that of its parent
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint
                                                constraintWithItem:self
                                                attribute:NSLayoutAttributeHeight
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:superview
                                                attribute:NSLayoutAttributeHeight
                                                multiplier:1.0f
                                                constant:0.0f];
        [superview addConstraint:heightConstraint];
        
        // Thumb's width should start out matching its height (it will stretch on touchDown)
        self.widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1.0f
                                                             constant:0.0f];
        [self addConstraint:self.widthConstraint];
        
        // Thumb's centerY should always match that of its parent
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self
                                                 attribute:NSLayoutAttributeCenterY
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:superview
                                                 attribute:NSLayoutAttributeCenterY
                                                 multiplier:1.0f
                                                 constant:0.0f];
        [superview addConstraint:centerYConstraint];
        
        // When the switch is off, thumb's leading edge should match its parent
        // (We'll start off this way)
        self.leadingEdgeConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:superview
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
        [superview addConstraint:self.leadingEdgeConstraint];
        
        // When the switch is on, thumb's trailing edge should match its parent
        // (We'll switch to this one when switch turns on)
        self.trailingEdgeConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:superview
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0f
                                                                    constant:0.0f];
        // NOTE that we don't add this constraint yet
        
        [self updateCornerRadius];
        
        [self layoutIfNeeded];
    }
    
    return self;
}

#pragma mark - MMMSwitchThumb: "Public" Methods

- (void)grow
{
    [self adjustThumbByGrowing:YES];
}

- (void)shrink
{
    [self adjustThumbByGrowing:NO];
}

- (void)adjustThumbByGrowing:(BOOL)growing
{
    self.widthConstraint.constant = growing ? (CGRectGetWidth(self.frame)*kDefaultThumbGrowthFactor) : 0.0f;
    
    [UIView animateWithDuration:kDefaultThumbGrowShrinkAnimationDuration
                     animations:^{ [self layoutIfNeeded]; }];
}

- (void)setOn:(BOOL)on
{
    BOOL wantsRightSide = on;
    if (wantsRightSide)
    {
        [self.superview removeConstraint:self.leadingEdgeConstraint];
        [self.superview addConstraint:self.trailingEdgeConstraint];
    }
    else
    {
        [self.superview removeConstraint:self.trailingEdgeConstraint];
        [self.superview addConstraint:self.leadingEdgeConstraint];
    }
    
    _on = on;
}

#pragma mark - MMMSwitchThumb: Auto Layout Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Ensure things are the way they're already supposed to be
    // (These are usually no-ops, except when switch is resizing)
    [self setOn:self.isOn];
    [self updateCornerRadius];
}

#pragma mark - MMMSwitchThumb: Private Methods

- (void)updateCornerRadius
{
    // Make sure the thumb is still circular
    self.layer.cornerRadius = (floorf(CGRectGetHeight(self.frame))/2.0f);
}

@end


#pragma mark - MMMSwitch Class


#define kDefaultOffTrackTintColor [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
#define kDefaultOnTrackTintColor  [UIColor greenColor];
#define kDefaultTrackBorderColor  [UIColor darkGrayColor];
#define kDefaultOnOffAnimationDuration 0.25f
#define kDefaultWidthChangeAnimationMultiplier 0.01f

static void * KVOContext = &KVOContext;

@interface MMMSwitch ()

@property (strong, nonatomic) MMMSwitchThumb *thumb;
@property (strong, nonatomic) UITouch *currentTouch;
@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;

@end

@implementation MMMSwitch

#pragma mark - MMMSwitch: Life-Cycle and KVO Methods

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:NSStringFromSelector(@selector(currentState))
                 context:KVOContext];
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
              context:KVOContext];
    
    self.currentState = MMMSwitchStateOff;
    
    void (^setUpAutoLayout)(void) = ^(void)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Kill all existing size constraints
        for (NSLayoutConstraint *constraint in self.constraints)
        {
            BOOL firstAttributeWidth = (constraint.firstAttribute == NSLayoutAttributeWidth);
            BOOL secondAttributeWidth = (constraint.secondAttribute == NSLayoutAttributeWidth);
            BOOL anAttributeIsWidth = (firstAttributeWidth || secondAttributeWidth);
            
            BOOL firstAttributeHeight = (constraint.firstAttribute == NSLayoutAttributeHeight);
            BOOL secondAttributeHeight = (constraint.secondAttribute == NSLayoutAttributeHeight);
            BOOL anAttributeIsHeight = (firstAttributeHeight || secondAttributeHeight);
            
            if (anAttributeIsWidth || anAttributeIsHeight)
            {
                [self removeConstraint:constraint];
            }
        }
        
        // Create width constraint based on current width
        self.widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f
                                                             constant:self.frame.size.width];
        [self addConstraint:self.widthConstraint];
        
        // Make sure height is always 3/5ths of width
        NSLayoutConstraint *heightAspectRatioConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                                       attribute:NSLayoutAttributeHeight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self
                                                                                       attribute:NSLayoutAttributeWidth
                                                                                      multiplier:(3.0f/5.0f)
                                                                                        constant:0.0f];
        [self addConstraint:heightAspectRatioConstraint];
        
        [self layoutIfNeeded];
    };
    
    setUpAutoLayout();
    
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
    BOOL contextMatches = (context == KVOContext);
    BOOL objectMatches = ([object isEqual:self]);
    BOOL keyPathMatches = ([keyPath isEqualToString:NSStringFromSelector(@selector(currentState))]);
    if (contextMatches && objectMatches && keyPathMatches)
    {
        // If the user has set a stateDidChangeHandler...
        if (self.stateDidChangeHandler)
        {
            // ...then call it with the latest state every time the state changes
            id newValue = change[NSKeyValueChangeNewKey];
            if ([newValue isKindOfClass:[NSNumber class]])
            {
                MMMSwitchState newState = [(NSNumber*)newValue integerValue];
                self.stateDidChangeHandler(newState);
            }
        }
    }
}

#pragma mark - MMMSwitch: Public Methods

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
                [self.thumb shrink];
                
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

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    [self setWidth:width animated:NO];
}

- (void)setWidth:(CGFloat)width animated:(BOOL)animated
{
    void (^widthChangeBlock)() = ^()
    {
        self.widthConstraint.constant = width;
        [self layoutIfNeeded];
    };
    
    if (animated)
    {
        CGFloat currentWidth = CGRectGetWidth(self.frame);
        CGFloat widthChange = abs(roundf(currentWidth - width));
        CGFloat heightChange = (widthChange*3.0f/5.0f);
        CGFloat cornerRadiusChange = floorf(heightChange/2.0f);
        CGFloat animationDuration = kDefaultWidthChangeAnimationMultiplier * widthChange;
        
        // Co-animate the cornerRadius of the switch
        CABasicAnimation *switchAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(cornerRadius))];
        switchAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        switchAnimation.fromValue = [NSNumber numberWithFloat:self.layer.cornerRadius];
        switchAnimation.toValue = [NSNumber numberWithFloat:self.layer.cornerRadius+cornerRadiusChange];
        switchAnimation.duration = animationDuration;
        [self.layer addAnimation:switchAnimation forKey:NSStringFromSelector(@selector(cornerRadius))];
        self.layer.cornerRadius += cornerRadiusChange;
        
        // Co-animate the cornerRadius of the thumb
        CABasicAnimation *trackAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(cornerRadius))];
        trackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        trackAnimation.fromValue = [NSNumber numberWithFloat:self.thumb.layer.cornerRadius];
        trackAnimation.toValue = [NSNumber numberWithFloat:self.thumb.layer.cornerRadius+cornerRadiusChange];
        trackAnimation.duration = animationDuration;
        [self.thumb.layer addAnimation:trackAnimation forKey:NSStringFromSelector(@selector(cornerRadius))];
        self.thumb.layer.cornerRadius += cornerRadiusChange;
        
        // Co-animate the width itself
        [UIView animateWithDuration:animationDuration animations:widthChangeBlock];
    }
    else
    {
        widthChangeBlock();
    }
}

#pragma mark - MMMSwitch: Auto Layout Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateCornerRadius];
}

#pragma mark - MMMSwitch: Configuration Methods

- (void)updateCornerRadius
{
    // Make sure the switch looks like a pill
    self.layer.cornerRadius = floorf(CGRectGetHeight(self.frame)/2.0f);
}

#pragma mark - MMMSwitch: Touch Capture and Recognition Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // This is used in conjunction with its inverse in
    // touchesEnded below to determine when the user began
    // to move the switch and then lifted their finger part-way
    self.currentTouch = [touches anyObject];
    
    self.currentState = self.isOn ? MMMSwitchStateSelectedPressedOn : MMMSwitchStateSelectedPressedOff;
    
    // User has touched down, so make the thumb fatter
    [self.thumb grow];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Grab the current touch
    UITouch *touch = touches.anyObject;
    
    // Determine whether user's finger was previously outside the switch
    CGFloat oldXPos = [touch previousLocationInView:self].x;
    CGFloat oldYPos = [touch previousLocationInView:self].y;
    BOOL oldXPosOutOfBounds = (oldXPos <= 0 || oldXPos > CGRectGetWidth(self.frame));
    BOOL oldYPosOutOfBounds = (oldYPos <= 0 || oldYPos > CGRectGetHeight(self.frame));
    BOOL wasOutsideOfSelf = (oldXPosOutOfBounds || oldYPosOutOfBounds);
    
    // Determine whether user's finger is currently outside the switch
    CGFloat newXPos = [touch locationInView:self].x;
    CGFloat newYPos = [touch locationInView:self].y;
    BOOL newXPosOutOfBounds = (newXPos <= 0 || newXPos > CGRectGetWidth(self.frame));
    BOOL newYPosOutOfBounds = (newYPos <= 0 || newYPos > CGRectGetHeight(self.frame));
    BOOL isOutsideOfSelf = (newXPosOutOfBounds || newYPosOutOfBounds);
    
    // Determine whether the user's finger is currently on the right side of the switch
    BOOL onRightSide = (newXPos > (CGRectGetWidth(self.frame)/2.0f));
    
    if (wasOutsideOfSelf && !(isOutsideOfSelf))
    {
        // It used to be outside and now it's inside
        
        // The user's finger just moved inside the switch, so make the thumb fat
        [self.thumb grow];
        
        self.currentState = onRightSide ? MMMSwitchStateSelectedPressedOn : MMMSwitchStateSelectedPressedOff;
    }
    else if (!(wasOutsideOfSelf) && isOutsideOfSelf)
    {
        // It used to be inside and now it's outside
        
        // The user's finger just moved outside the switch, so make the thumb circular (aka not fat)
        [self.thumb shrink];
        
        self.currentState = onRightSide ? MMMSwitchStateSelectedUnpressedOn : MMMSwitchStateSelectedUnpressedOff;
    }
    
    if (onRightSide && !(self.isOn))
    {
        // User's finger just reached position indicating the switch should be on
        
        [self setOn:YES animated:YES];
        
        self.currentState = isOutsideOfSelf ? MMMSwitchStateSelectedUnpressedOn : MMMSwitchStateSelectedPressedOn;
    }
    else if (!(onRightSide) && self.isOn)
    {
        // User's finger just reached position indicating the switch should be off
        
        [self setOn:NO animated:YES];
        
        self.currentState = isOutsideOfSelf ? MMMSwitchStateSelectedUnpressedOff : MMMSwitchStateSelectedPressedOff;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.thumb shrink];
    
    self.currentState = self.isOn ? MMMSwitchStateOn : MMMSwitchStateOff;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Convenience variables for use below
    UITouch *endingTouch = touches.anyObject;
    CGPoint windowEndTouchLocation = [endingTouch locationInView:self.window];
    CGFloat accuracyBuffer = 1.0f;
    
    // Determine whether or not the user touched up outside of the switch
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
        // The user touched up outside of the switch
        
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
            
            [self.thumb shrink];
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
