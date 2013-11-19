// KSCircularActivityView.m
//
// Copyright (c) 2013 Shintaro Kaneko (http://kaneshinth.com)
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

#import "KSCircularActivityView.h"

const static CGFloat kDefaultFramesPerSecond = 60;

@interface KSIndicatorView : UIView
@property (nonatomic, assign) CGFloat *lineWidth;
@property (nonatomic, assign) CGFloat *percentageOfArc;
@property (nonatomic, strong) UIColor *indicatorColor;
- (void)drawPie:(CGRect)rect color:(UIColor *)color startRadian:(CGFloat)startRadian endRadian:(CGFloat)endRadian;
- (void)drawArc:(CGRect)rect color:(UIColor *)color lineWidth:(CGFloat)lineWidth radius:(CGFloat)radius startRadian:(CGFloat)startRadian endRadian:(CGFloat)endRadian;
@end

@implementation KSIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat startRadian = -M_PI_2;
    CGFloat endRadian = startRadian + (2.f * M_PI * (*_percentageOfArc));
    [self drawPie:self.bounds color:_indicatorColor startRadian:startRadian endRadian:endRadian];
    CALayer *layer = self.layer;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    layer.shouldRasterize = YES;
}

- (void)drawPie:(CGRect)rect
          color:(UIColor *)color
    startRadian:(CGFloat)startRadian
      endRadian:(CGFloat)endRadian
{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat radius = .5f * MIN(width, height);
    CGPoint center = CGPointMake(rect.origin.x + .5f * width, rect.origin.y + .5f * height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, startRadian, endRadian, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
}

- (void)drawArc:(CGRect)rect
          color:(UIColor *)color
      lineWidth:(CGFloat)lineWidth
         radius:(CGFloat)radius
    startRadian:(CGFloat)startRadian
      endRadian:(CGFloat)endRadian
{
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, startRadian, endRadian, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
}

@end

@interface KSCircularActivityView ()
@property (nonatomic, strong) KSIndicatorView *indicatorView;
- (void)initialize;
@end

@implementation KSCircularActivityView {
    CGFloat _radian;
    NSTimer *_animationTimer;
}

- (id)initWithContentView:(UIView *)contentView
{
    self = [super initWithFrame:contentView.bounds];
    if (self) {
        self.contentView = contentView;
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[UIView alloc] initWithFrame:frame];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if (_indicatorView == nil) {
        _indicatorView = [[KSIndicatorView alloc] initWithFrame:self.frame];
        _indicatorView.percentageOfArc = &_percentageOfArc;
        [self addSubview:_indicatorView];
    }
    [self addSubview:_contentView];
    self.backgroundColor = [UIColor clearColor];
    _framesPerSecond = 60.f;
    _clockwise = YES;
    _radian = 0.f;
    _hidesWhenStopped = NO;
    _hidesWithAnimation = NO;
    _showsWithAnimation = NO;
    _velocity = .5f;
    _percentageOfArc = 0.05f;
    self.hiddenIndicatorView = NO;
    self.indicatorColor = [UIColor colorWithRed:0.f green:122.f/255.f blue:1.f alpha:1.f];
    self.lineWidth = 1.f;
}

- (void)setContentView:(UIView *)contentView
{
    contentView.center = _contentView.center;
    if (_contentView != nil) {
        [_contentView removeFromSuperview];
    }
    [self addSubview:contentView];
    _contentView = contentView;
    CALayer *layer = contentView.layer;
    layer.cornerRadius = .5f * MIN(CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame));
    layer.masksToBounds = YES;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    layer.shouldRasterize = YES;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    _indicatorView.lineWidth = &_lineWidth;
    CGPoint center = self.center;
    CGRect frame = self.contentView.bounds;
    frame.size.width += 2.f * _lineWidth;
    frame.size.height += 2.f * _lineWidth;
    self.frame = frame;
    self.center = center;
    _indicatorView.frame = frame;
    _contentView.center = CGPointMake(.5f * CGRectGetWidth(frame), .5f * CGRectGetHeight(frame));
    
    CALayer *layer = self.layer;
    layer.cornerRadius = .5f * MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
    layer.masksToBounds = YES;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    layer.shouldRasterize = YES;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    _indicatorView.indicatorColor = _indicatorColor;
}

- (CGFloat)framesPerSecond
{
    return _framesPerSecond > 0 ? _framesPerSecond : kDefaultFramesPerSecond;
}

- (BOOL)hiddenIndicatorView
{
    return _indicatorView.hidden;
}

- (void)setHiddenIndicatorView:(BOOL)hiddenIndicatorView
{
    _indicatorView.hidden = hiddenIndicatorView;
}

- (CGFloat)velocity
{
    return (_clockwise ? 1 : -1) * _velocity * .15f;
}

- (CGFloat)durationWhenHidden
{
    return (_durationWhenHidden > 0 ? _durationWhenHidden : .1f);
}

- (CGFloat)durationWhenShown
{
    return (_durationWhenShown > 0 ? _durationWhenShown : .1f);
}

- (void)animate
{
    _radian += self.velocity;
    _indicatorView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(-M_PI_2 + _radian));
}

- (BOOL)isAnimating
{
    return _animationTimer.isValid;
}

- (void)startAnimating
{
    void (^timerBlock)(void) = ^(void) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/self.framesPerSecond
                                                           target:self
                                                         selector:@selector(animate)
                                                         userInfo:nil
                                                          repeats:YES];
        [_animationTimer fire];
    };
    if (!_animationTimer.isValid) {
        if (_hidesWhenStopped) {
            if (_showsWithAnimation) {
                _indicatorView.alpha = 0.f;
                _indicatorView.hidden = NO;
                timerBlock();
                [UIView animateWithDuration:self.durationWhenShown
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     _indicatorView.alpha = 1.f;
                                 } completion:^(BOOL finished) {
                                     if (finished) {
                                     }
                                 }];
            } else {
                _indicatorView.hidden = NO;
                timerBlock();
            }
        } else {
            timerBlock();
        }
    }
}

- (void)stopAnimating
{
    void (^timerBlock)(void) = ^(void) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    };
    if (_animationTimer.isValid) {
        if (_hidesWhenStopped) {
            if (_hidesWithAnimation) {
                _indicatorView.alpha = 1.f;
                [UIView animateWithDuration:self.durationWhenHidden
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     _indicatorView.alpha = 0.f;
                                 } completion:^(BOOL finished) {
                                     if (finished) {
                                         _indicatorView.hidden = YES;
                                         timerBlock();
                                     }
                                 }];
            } else {
                _indicatorView.hidden = YES;
                timerBlock();
            }
        } else {
            timerBlock();
        }
    }
}

@end
