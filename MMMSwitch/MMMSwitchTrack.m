//
//  MMMSwitchTrack.m
//  MMMSwitch
//
//  Created by Matthew McCroskey on 9/14/14.
//  Copyright (c) 2014 MMM. All rights reserved.
//

#import "MMMSwitchTrack.h"

//Size of knob with respect to the control - Must be a multiple of 2
#define kThumbOffset 1

//Appearance - Animations
#define kDefaultAnimationContrastResizeLength 0.25f           //Length of time for the thumb to grow on press down

@interface MMMSwitchTrack ()

@property (nonatomic, strong) UIView *contrastView;
@property (nonatomic, strong) UIView *onView;

@end

@implementation MMMSwitchTrack

- (void)updateConstraints
{
    [super updateConstraints];
    [self configureLayout];
}

- (void)configureLayout
{
    CGRect frame = CGRectZero;
    if (self.superview)
    {
        frame = self.superview.frame;
    }
    
    // Give self its rounded edges
    CGFloat cornerRadius = frame.size.height/2.0f;
    [self.layer setCornerRadius: cornerRadius];
    
    // Give the contrast view its rounded edges
    CGRect contrastRect = frame;
    contrastRect.size.width = frame.size.width - 2*kThumbOffset;
    contrastRect.size.height = frame.size.height - 2*kThumbOffset;
    CGFloat contrastRadius = contrastRect.size.height/2.0f;
    self.contrastView.layer.cornerRadius = contrastRadius;
    
    // Give the on view its rounded edges
    self.onView.layer.cornerRadius = cornerRadius;
}

-(id) initWithOnColor:(UIColor*) onColor
             offColor:(UIColor*) offColor
        contrastColor:(UIColor*) contrastColor {
    if (self = [super init]) {
        _onTintColor = onColor;
        _tintColor = offColor;
        
        [self setBackgroundColor: _tintColor];
        
        _contrastView = [[UIView alloc] init];
        [_contrastView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_contrastView setBackgroundColor: contrastColor];
        [self addSubview: _contrastView];
        
        _onView = [[UIView alloc] init];
        [_onView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_onView setBackgroundColor: _onTintColor];
        [self addSubview: _onView];
        
        // Constrain _contrastView and _onView to take up the entirety of self
        NSArray *views = @[_onView, _contrastView];
        NSArray *edges = @[@(NSLayoutAttributeLeading), @(NSLayoutAttributeTop), @(NSLayoutAttributeTrailing), @(NSLayoutAttributeBottom)];
        for (UIView *currentView in views) {
            for (NSNumber *attributeNumber in edges) {
                NSLayoutAttribute attribute = (NSLayoutAttribute)attributeNumber.integerValue;
                NSLayoutConstraint *constraint
                = [NSLayoutConstraint constraintWithItem:currentView
                                               attribute:attribute
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self
                                               attribute:attribute
                                              multiplier:1.0f
                                                constant:0.0f];
                [self addConstraint:constraint];
            }
        }
        
        [self configureLayout];
    }
    return self;
}

-(void) setOn:(BOOL)on {
    if (on) {
        [self.onView setAlpha: 1.0];
    }
    else {
        [self.onView setAlpha: 0.0];
    }
}

-(void) setOn:(BOOL)on
     animated:(BOOL)animated {
    if (animated) {
        __weak id weakSelf = self;
        //First animate the color switch
        [UIView animateWithDuration: kDefaultAnimationContrastResizeLength
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [weakSelf setOn: on
                                    animated: NO];
                         }
                         completion:nil];
    }
    else {
        [self setOn: on];
    }
}

-(void) setOnTintColor:(UIColor *)onTintColor {
    _onTintColor = onTintColor;
    [self.onView setBackgroundColor: _onTintColor];
}

-(void) setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self setBackgroundColor: _tintColor];
}

-(void) setContrastColor:(UIColor *)contrastColor {
    _contrastColor = contrastColor;
    [self.contrastView setBackgroundColor: _contrastColor];
}


@end
