// NSMPlayerAccessoryView.m
//
// Copyright (c) 2017 NSMPlayer
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

#import "NSMPlayerAccessoryView.h"

@interface NSMPlayerAccessoryView ()

@property (nonatomic, weak) UIButton *startOrPauseButton;
@property (nonatomic, weak) UILabel *progressLabel;
@property (nonatomic, weak) UISlider *sliderView;
@property (nonatomic, weak) UIProgressView *progressView;

@end

@implementation NSMPlayerAccessoryView

@synthesize delegate = _delegate;
@synthesize progress = _progress;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *startOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startOrPauseButton setImage:[UIImage imageNamed:@"pauseBtno50" inBundle:[NSBundle bundleForClass:[NSMPlayerAccessoryView class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [startOrPauseButton setImage:[UIImage imageNamed:@"playBtn50" inBundle:[NSBundle bundleForClass:[NSMPlayerAccessoryView class]] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    startOrPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.startOrPauseButton = startOrPauseButton;
    [self addSubview:startOrPauseButton];
    
    [NSLayoutConstraint constraintWithItem:startOrPauseButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:startOrPauseButton.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:startOrPauseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:startOrPauseButton.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0].active = YES;
    
    
    UIFont *timingFont = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    UIColor *tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    UILabel *progressLabel = [[UILabel alloc] init];
    progressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressLabel = progressLabel;
    progressLabel.text = @"00:00/00:00";
    progressLabel.textAlignment = NSTextAlignmentRight;
    progressLabel.font = timingFont;
    progressLabel.textColor = tintColor;
    [self addSubview:progressLabel];
    
    
    UIColor *sunYellowColor = [UIColor colorWithRed:1.0 green:204.0 / 255.0 blue:0.0 alpha:1.0];
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressView = progressView;
    progressView.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    progressView.trackTintColor = tintColor;
    [self addSubview:progressView];
    
    UISlider *sliderView = [[UISlider alloc] init];
    sliderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.sliderView = sliderView;
    sliderView.minimumTrackTintColor = sunYellowColor;
    sliderView.maximumTrackTintColor = [UIColor clearColor];
    [self addSubview:sliderView];

    UIView *superview = self;
    NSDictionary *views = NSDictionaryOfVariableBindings(superview, sliderView, progressView, progressLabel);
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[progressView]-30-[progressLabel(==100)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    for (NSLayoutConstraint *constraint in horizontalConstraints) {
        constraint.active = YES;
    }
    
    [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:sliderView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:sliderView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:progressView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-30.0].active = YES;
    [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:sliderView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:1.0].active = YES;
    
    [sliderView setContentHuggingPriority:UILayoutPriorityDefaultLow - 1.0 forAxis:UILayoutConstraintAxisHorizontal];
    [progressView setContentHuggingPriority:UILayoutPriorityDefaultLow - 1.0 forAxis:UILayoutConstraintAxisHorizontal];
    [sliderView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh - 1.0 forAxis:UILayoutConstraintAxisHorizontal];
    [progressView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh - 1.0 forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)show:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        }];
    } else {
        self.alpha = 1.0;
    }
}

- (void)hide:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        }];
    } else {
        self.alpha = 0.0;
    }
}

@end
