//
//  YYSliderViewController.m
//  WeiboSliderTabDemo
//
//  Created by Zin_戦 on 2017/5/19.
//  Copyright © 2017年 Zin_戦. All rights reserved.
//

#import "YYSliderViewController.h"
#import "YYOptionalView.h"
@interface YYSliderViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) YYOptionalView *optionalView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray<NSString *> *titleArray;

@end

static const CGFloat optionalViewHeight = 40.0;
@implementation YYSliderViewController
{
    /** 缓存VC index */
    NSMutableArray<NSNumber *> *_cacheVCIndex;
}
- (void)dealloc{
    [self removeObserver:_optionalView forKeyPath:@"_optionalView.sliderView.frame"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    /** 添加子视图 */
    [self initSubViews];
    /** 处理事件回调 */
    [self dealButtonCallBackBlcok];
    
}

/** 添加子视图 */
- (void)initSubViews{
    _cacheVCIndex = [NSMutableArray arrayWithCapacity:0];
    self.view.frame = CGRectMake(self.view.frame.origin.x, [self getOptionalStartY], self.view.frame.size.width, optionalViewHeight + [self getScrollViewHeight]);
    
    [self.view addSubview:self.optionalView];
    [self.view addSubview:self.mainScrollView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeSubViewControllerAtIndex:0];
    
    self.mainScrollView.contentSize = CGSizeMake(_titleArray.count *self.view.frame.size.width, self.mainScrollView.frame.size.height);
}

/** 处理事件回调 */
- (void)dealButtonCallBackBlcok{
    __weak YYSliderViewController *weakSelf = self;
    _optionalView.titleItemClickedCallBackBlock = ^(NSInteger index){
        weakSelf.mainScrollView.contentOffset = CGPointMake((index - 100) * self.view.frame.size.width , 0);
    };
}

#pragma mark - - lazy load

- (YYOptionalView *)optionalView{
    if (!_optionalView) {
        _optionalView = [[YYOptionalView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, optionalViewHeight)];
        _optionalView.titleArray = self.titleArray;
        _optionalView.showsVerticalScrollIndicator = NO;
        _optionalView.showsHorizontalScrollIndicator = NO;
        
    }
    return _optionalView;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.optionalView.frame), self.view.frame.size.width, [self getScrollViewHeight])];
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = NO;
    }
    return _mainScrollView;
}

- (NSArray *)titleArray{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(yy_titlesArrayInSliderViewController)]) {
        _titleArray = [self.dataSource yy_titlesArrayInSliderViewController];
    }
    return _titleArray;
}

#pragma mark - - scrollView
/** 偏移量控制显示状态 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / (scrollView.frame.size.width + 1);
    [self initializeSubViewControllerAtIndex:index + 1];
    self.optionalView.contentOffSetX = scrollView.contentOffset.x;
}

#pragma mark - - private

- (CGFloat)getOptionalStartY{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(yy_optionalViewStartYInSliderViewController)]) {
        return [self.dataSource yy_optionalViewStartYInSliderViewController];
    }else{
        return 20;
    }
}

- (CGFloat)getScrollViewHeight{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(yy_viewOfChildViewControllerHeightInSliderViewController)]) {
        return [self.dataSource yy_viewOfChildViewControllerHeightInSliderViewController];
    }else{
        return [UIScreen mainScreen].bounds.size.height - optionalViewHeight - 20;
    }
}

- (void)initializeSubViewControllerAtIndex:(NSInteger)index{
    
    // 添加子控制器
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(yy_sliderViewController:subViewControllerAtIndxe:)]) {
        UIViewController *vc = [self.dataSource yy_sliderViewController:self subViewControllerAtIndxe:index];
        if (![_cacheVCIndex containsObject:[NSNumber numberWithInteger:index]]) {
            [_cacheVCIndex addObject:[NSNumber numberWithInteger:index]];
            vc.view.frame = CGRectMake(index * vc.view.frame.size.width, 0, vc.view.frame.size.width , self.mainScrollView.frame.size.height);
            [self addChildViewController:vc];
            [self.mainScrollView addSubview:vc.view];
        }
    }
}


@end
