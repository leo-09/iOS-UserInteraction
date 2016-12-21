//
//  YYTabItemViewController.m
//  HiHome_TMZS
//
//  Created by liyy on 2016/12/21.
//  Copyright © 2016年 gxwl. All rights reserved.
//

#import "YYTabItemViewController.h"

#define time 0.3f
// 屏幕宽高
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface YYTabItemViewController () {
    UIImageView *leftImageView;
    UIImageView *rightImageView;
}

@end

@implementation YYTabItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加左右滑动手势pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    // 第一个ViewController没有左view
    if (selectedIndex > 0) {
        UIViewController* v1 = [self.tabBarController.viewControllers objectAtIndex:(selectedIndex - 1)];
        UIImage* image1 = [self imageByCropping:v1.view toRect:v1.view.bounds];
        leftImageView = [[UIImageView alloc] initWithImage:image1];
        leftImageView.frame = CGRectMake(leftImageView.frame.origin.x - kScreenWidth,
                                         leftImageView.frame.origin.y ,
                                         leftImageView.frame.size.width,
                                         leftImageView.frame.size.height);
        [self.view addSubview:leftImageView];
    }
    
    // 最后一个ViewController没有右view
    if (selectedIndex < (self.tabBarController.viewControllers.count-1)) {
        UIViewController *v2 = [self.tabBarController.viewControllers objectAtIndex:(selectedIndex + 1)];
        UIImage* image2 = [self imageByCropping:v2.view toRect:v2.view.bounds];
        rightImageView = [[UIImageView alloc] initWithImage:image2];
        rightImageView.frame = CGRectMake(rightImageView.frame.origin.x + kScreenWidth,
                                    0,
                                    rightImageView.frame.size.width,
                                    rightImageView.frame.size.height);
        [self.view addSubview:rightImageView];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 用于移除pan时的左右两边的view
    if (leftImageView) {
        [leftImageView removeFromSuperview];
    }
    if (rightImageView) {
        [rightImageView removeFromSuperview];
    }
}

#pragma mark Pan手势
- (void) handlePan:(UIPanGestureRecognizer*)recongizer{
    CGPoint point = [recongizer translationInView:self.view];// 获取偏移量
    
    NSUInteger index = [self.tabBarController selectedIndex];
    if (index == 0) {
        if (point.x > 0) {
            return;
        }
    }
    if (index == (self.tabBarController.viewControllers.count-1)) {
        if (point.x < 0) {
            return;
        }
    }
    
    recongizer.view.center = CGPointMake(recongizer.view.center.x + point.x, recongizer.view.center.y);
    [recongizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recongizer.state == UIGestureRecognizerStateEnded) {
        if (recongizer.view.center.x < kScreenWidth && recongizer.view.center.x > 0 ) {
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake(kScreenWidth / 2 ,kScreenHeight / 2);
            }completion:^(BOOL finished) {
                
            }];
        } else if (recongizer.view.center.x <= 0 ){
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake(-kScreenWidth / 2 , kScreenHeight / 2);
            }completion:^(BOOL finished) {
                [self.tabBarController setSelectedIndex:index+1];
                recongizer.view.center = CGPointMake(kScreenWidth / 2 , kScreenHeight / 2);
            }];
        } else {
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake(kScreenWidth * 1.5 , kScreenHeight / 2);
            }completion:^(BOOL finished) {
                [self.tabBarController setSelectedIndex:index-1];
                recongizer.view.center = CGPointMake(kScreenWidth / 2 , kScreenHeight / 2);
            }];
        }
    }
}

// 与pan结合使用 截图方法，图片用来做动画
- (UIImage *) imageByCropping:(UIView*) imageToCrop toRect:(CGRect) rect {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize pageSize = CGSizeMake(scale * rect.size.width, scale * rect.size.height);
    
    UIGraphicsBeginImageContext(pageSize);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext, -rect.origin.x, -rect.origin.y);
    [imageToCrop.layer renderInContext:resizedContext];
    UIImage *imageOriginBackground = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imageOriginBackground = [UIImage imageWithCGImage:imageOriginBackground.CGImage scale:scale orientation:UIImageOrientationUp];
    
    return imageOriginBackground;
}

@end
