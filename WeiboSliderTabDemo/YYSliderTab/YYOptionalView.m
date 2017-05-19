//
//  YYOptionalView.m
//  WeiboSliderTabDemo
//
//  Created by Zin_戦 on 2017/5/19.
//  Copyright © 2017年 Zin_戦. All rights reserved.
//
/** 屏幕尺寸参数 */
#define kSCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)
/** 随机颜色 */
#define randomColor [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]


#import "YYOptionalView.h"
#import "YYTitleItem.h"
#import "YYSliderView.h"
@interface YYOptionalView ()
/** 滑动条 */
@property (nonatomic, strong) YYSliderView *sliderView;

@end

static const CGFloat sliderViewWidth = 15;
CGFloat itemWidth = 60;

@implementation YYOptionalView

/** 接收通知 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    CGFloat itemVisionblePositionMax = _sliderView.frame.origin.x - (itemWidth - sliderViewWidth)/2 + 2*itemWidth;
    CGFloat itemVisionblePositionMin = _sliderView.frame.origin.x - (itemWidth - sliderViewWidth)/2 - itemWidth;
    
    // 右滑
    if (itemVisionblePositionMax >= self.frame.size.width + self.contentOffset.x &&
        itemVisionblePositionMax <= self.contentSize.width) {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentOffset = CGPointMake(itemVisionblePositionMax - self.frame.size.width, 0);
        }];
    }
    // 左滑
    if (itemVisionblePositionMin < self.contentOffset.x &&
        itemVisionblePositionMin >= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentOffset = CGPointMake(itemVisionblePositionMin, 0);
        }];
    }
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray{
    _titleArray = titleArray;
    
    if (itemWidth*titleArray.count<kSCREEN_WIDTH) {
        itemWidth = kSCREEN_WIDTH/titleArray.count;
    }
    [self addSubview:self.sliderView];
    /** 监听frame改变 */
    [self addObserver:self forKeyPath:@"_sliderView.frame" options:NSKeyValueObservingOptionNew context:nil];
    
    // 添加所有item
    for (NSInteger i = 0; i < titleArray.count; i++) {
        YYTitleItem *item = [[YYTitleItem alloc] initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, self.frame.size.height)];
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [item setTitle:titleArray[i] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        item.tag = i + 100;
        [self addSubview:item];
    }
    
    // 第一个item 更改样式
    YYTitleItem *firstItem = [self viewWithTag:100];
    [firstItem setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    firstItem.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    
    self.contentSize = CGSizeMake(itemWidth*titleArray.count, self.frame.size.height);
}

- (void)setContentOffSetX:(CGFloat)contentOffSetX{
    _contentOffSetX = contentOffSetX;
    NSInteger index = (NSInteger)contentOffSetX / (NSInteger)[UIScreen mainScreen].bounds.size.width;
    // progress 0(屏幕边缘开始) -  1 （满屏结束）
    CGFloat progress =( _contentOffSetX - index * [UIScreen mainScreen].bounds.size.width )/ [[UIScreen mainScreen]bounds].size.width;
    // 左右选项卡（item）
    YYTitleItem *leftItem = [self viewWithTag:index + 100];
    YYTitleItem *rightItem = [self viewWithTag:index + 101];
    // item 根据progress改变状态
    leftItem.progress = 1 - progress;
    rightItem.progress = progress;
    // 滑条sliderView 根据progress 改变状态
    CGRect frame = _sliderView.frame;
    frame.origin.x = index * itemWidth + (itemWidth - sliderViewWidth)/2;
    _sliderView.frame = frame;
    _sliderView.progress = progress;
}

#pragma mark - - lazy load

- (YYSliderView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[YYSliderView alloc] initWithFrame:CGRectMake((itemWidth - sliderViewWidth)/2, self.frame.size.height - 4, sliderViewWidth, 2)];
        _sliderView.backgroundColor = [UIColor redColor];
        _sliderView.layer.cornerRadius = 2;
        _sliderView.layer.masksToBounds = YES;
        _sliderView.itemWidth = itemWidth;
    }
    return _sliderView;
}


#pragma mark - - button event

- (void)itemClicked:(YYTitleItem *)sender{
    NSInteger index = (NSInteger)_contentOffSetX / (NSInteger)[UIScreen mainScreen].bounds.size.width;
    if (sender.tag - 100 == index) return;
    YYTitleItem *currentItem = [self viewWithTag:index + 100];
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [currentItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGRect frame = _sliderView.frame;
    frame.origin.x = (sender.tag - 100) * itemWidth + (itemWidth - sliderViewWidth)/2;
    
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        currentItem.transform = CGAffineTransformIdentity;
        _sliderView.frame = frame;
    }];
    !_titleItemClickedCallBackBlock ? : _titleItemClickedCallBackBlock(sender.tag);
}


@end
