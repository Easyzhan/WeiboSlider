//
//  YYOptionalView.h
//  WeiboSliderTabDemo
//
//  Created by Zin_戦 on 2017/5/19.
//  Copyright © 2017年 Zin_戦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYOptionalView : UIScrollView
/** 标题数组 */
@property (nonatomic, strong) NSArray <NSString *> *titleArray;
/** item点击回调 */
@property (nonatomic, copy) void (^titleItemClickedCallBackBlock)(NSInteger index);
/** 偏移量 */
@property (nonatomic, assign) CGFloat contentOffSetX;

@end
