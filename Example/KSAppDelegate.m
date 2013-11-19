// KSAppDelegate.m
// Copyright (c) 2013 kaneshinth.com. All rights reserved.

#import "KSAppDelegate.h"

#import "KSCircularActivityView.h"

@interface KSAppDelegate ()
@property (nonatomic, strong) KSCircularActivityView *circularActivityView;
@end

@implementation KSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIViewController *controller = [[UIViewController alloc] init];
    self.window.rootViewController = controller;
    
    CGRect contentFrame = CGRectMake(0.f, 0.f, 100.f, 100.f);
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonSize = .25f * CGRectGetWidth(contentFrame);
    button.frame = CGRectMake(0.f, 0.f, buttonSize, buttonSize);
    button.center = contentView.center;
    button.backgroundColor = [UIColor colorWithRed:1.f green:122.f/255.f blue:1.f alpha:1.f];
    [button addTarget:self action:@selector(toggleAnimation) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    
    _circularActivityView = [[KSCircularActivityView alloc] initWithContentView:contentView];
    _circularActivityView.center = controller.view.center;
    _circularActivityView.backgroundColor = [UIColor clearColor];
    _circularActivityView.lineWidth = 1.f;
    _circularActivityView.percentageOfArc = .95;
    _circularActivityView.velocity = .2f;
    _circularActivityView.indicatorColor = [UIColor colorWithRed:1.f green:122.f/255.f blue:1.f alpha:1.f];
    _circularActivityView.framesPerSecond = 60.f;
    _circularActivityView.hidesWhenStopped = YES;
    _circularActivityView.hidesWithAnimation = YES;
    _circularActivityView.durationWhenHidden = .15f;
    _circularActivityView.showsWithAnimation = YES;
    _circularActivityView.durationWhenShown = .15f;
    [_circularActivityView startAnimating];
    
    [controller.view addSubview:_circularActivityView];
    
    KSCircularActivityView *activityView = [[KSCircularActivityView alloc] initWithFrame:CGRectMake(50.f, 50.f, 100.f, 100.f)];
    activityView.lineWidth = 1.f;
    activityView.percentageOfArc = .96f;
    activityView.velocity = .4f;
    [activityView startAnimating];
    [controller.view addSubview:activityView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 100.f)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://i.imgur.com/oyRSoRs.jpg"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityView stopAnimating];
            imageView.image = image;
            activityView.contentView = imageView;
            [activityView startAnimating];
        });
    });
    
    return YES;
}

- (void)toggleAnimation
{
    if (_circularActivityView.isAnimating) {
        [_circularActivityView stopAnimating];
    }
    else {
        _circularActivityView.clockwise = !_circularActivityView.clockwise;
        [_circularActivityView startAnimating];
    }
}

@end
