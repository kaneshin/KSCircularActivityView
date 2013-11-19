// KSCircularActivityView.h
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

#import <Foundation/Foundation.h>

@interface KSCircularActivityView : UIView

- (id)initWithContentView:(UIView *)contentView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat percentageOfArc;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) CGFloat framesPerSecond;

@property (nonatomic, copy) UIColor *indicatorColor;
@property (nonatomic, assign) BOOL hiddenIndicatorView;
@property (nonatomic, assign) BOOL hidesWhenStopped;
@property (nonatomic, assign) BOOL showsWithAnimation;
@property (nonatomic, assign) BOOL hidesWithAnimation;
@property (nonatomic, assign) CGFloat durationWhenShown;
@property (nonatomic, assign) CGFloat durationWhenHidden;
@property (nonatomic, assign) BOOL clockwise;

- (BOOL)isAnimating;
- (void)startAnimating;
- (void)stopAnimating;
@end
