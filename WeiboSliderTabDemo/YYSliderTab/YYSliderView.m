//
//  YYSliderView.m
//  WeiboSliderTabDemo
//
//  Created by Zin_戦 on 2017/5/19.
//  Copyright © 2017年 Zin_戦. All rights reserved.
//

#import "YYSliderView.h"

@implementation YYSliderView

// 滑动进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_progress > 0 && _progress <= 1) {
        CGRect frame = self.frame;
        frame.size.width = 15 + _itemWidth * (_progress > 0.5 ? 1 - _progress : _progress);
        frame.origin.x = frame.origin.x + _itemWidth * _progress;
        self.frame = frame;
    }
}
@end
