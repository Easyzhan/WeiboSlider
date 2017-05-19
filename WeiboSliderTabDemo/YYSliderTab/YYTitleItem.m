//
//  YYTitleItem.m
//  WeiboSliderTabDemo
//
//  Created by Zin_戦 on 2017/5/19.
//  Copyright © 2017年 Zin_戦. All rights reserved.
//

#import "YYTitleItem.h"

@implementation YYTitleItem

// 滑动进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_progress > 0 && _progress <= 1) {
        [self setTitleColor:[UIColor colorWithRed:0 + 1*_progress green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + 0.1 * _progress, 1 + 0.1 * _progress);
    }
}

@end
