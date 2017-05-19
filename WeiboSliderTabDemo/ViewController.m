//
//  ViewController.m
//  WeiboSliderTabDemo
//
//  Created by Zin_戦 on 2017/5/19.
//  Copyright © 2017年 Zin_戦. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "YYSliderViewController.h"
@interface ViewController ()<YYSliderViewControllerDataSource>
/** 滑动选项 */
@property (nonatomic, strong) YYSliderViewController *sliderVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self sliderVC];
    self.title = @"完美";
}

#pragma mark - - lazy load
- (YYSliderViewController *)sliderVC{
    if (!_sliderVC) {
        _sliderVC = [YYSliderViewController new];
        _sliderVC.dataSource = self;
        [self addChildViewController:_sliderVC];
        [self.view addSubview:_sliderVC.view];
    }
    return _sliderVC;
}

#pragma mark - - BLSliderViewControllerDataSource
- (NSArray<NSString *> *)yy_titlesArrayInSliderViewController{
    return @[@"主页",@"随机jjjl",@"银行"];
}

- (UIViewController *)yy_sliderViewController:(YYSliderViewController *)sliderVC subViewControllerAtIndxe:(NSInteger)index{
    
    NSLog(@"---index = %ld",index);
    return [TestViewController new];
}
/** 子视图起始位置（y），默认在状态栏之下,即默认y开始 = 20
 *  没有导航栏时候设置为20,有则设置为0即可
 */
- (CGFloat)yy_optionalViewStartYInSliderViewController{
    return 0.01;
}

- (CGFloat)yy_viewOfChildViewControllerHeightInSliderViewController{
    return self.view.frame.size.height - 40 - 40;
}

@end
