//
//  YYSliderViewController.h
//  WeiboSliderTabDemo
//
//  Created by Zin_戦 on 2017/5/19.
//  Copyright © 2017年 Zin_戦. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYSliderViewController;
@protocol YYSliderViewControllerDataSource <NSObject>
/** 标题个数 */
- (NSArray<NSString *> *)yy_titlesArrayInSliderViewController;
/** index对应的子控制器 */
- (UIViewController *)yy_sliderViewController:(YYSliderViewController *)sliderVC subViewControllerAtIndxe:(NSInteger)index;
@optional
/** 子视图高度 (不包含optionalView高度的子视图高度, optionalView高度40), 默认适配全屏*/
- (CGFloat)yy_viewOfChildViewControllerHeightInSliderViewController;
/** 子视图起始位置（y），默认在状态栏之下 */
- (CGFloat)yy_optionalViewStartYInSliderViewController;
@end


@interface YYSliderViewController : UIViewController

@property (nonatomic, weak) id<YYSliderViewControllerDataSource> dataSource;


@end
