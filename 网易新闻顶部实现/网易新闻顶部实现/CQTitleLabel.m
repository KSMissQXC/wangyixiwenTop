//
//  CQTitleLabel.m
//  网易新闻顶部实现
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CQTitleLabel.h"
#import "CQConst.h"

@implementation CQTitleLabel

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.highlightedTextColor = [UIColor redColor];
        self.font = [UIFont systemFontOfSize:17];
        self.textAlignment = NSTextAlignmentCenter;
        self.width = titleLabelW;
        self.height = titleLabelH;
        self.y = 0;
        
    }
    return self;
}


-(void)setScale:(CGFloat)scale{
    //颜色渐变效果
    // 设置文字颜色渐变
    /*
     R G B
     黑色 0 0 0
     红色 1 0 0
     */

    self.transform = CGAffineTransformMakeScale(scale * 0.3 + 1, scale * 0.3 + 1);
    self.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1];

}


@end
