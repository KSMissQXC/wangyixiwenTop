//
//  CQNewsViewController.m
//  网易新闻顶部实现
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CQNewsViewController.h"
#import "CQTopViewController.h"
#import "CQHotViewController.h"
#import "CQVideoViewController.h"
#import "CQSocietyViewController.h"
#import "CQReaderViewController.h"
#import "CQScienceViewController.h"
#import "CQConst.h"
#import "CQTitleLabel.h"

//static CGFloat const radioScale = 1.3;

@interface CQNewsViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

//当前选中的titleLabel
@property (weak, nonatomic)CQTitleLabel *selectedLabel;

//保存所有的顶部标题label
@property (strong, nonatomic)NSMutableArray *titleLabelArray;

@end

@implementation CQNewsViewController

#pragma mark - 初始化
- (void)viewDidLoad {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    //添加所有子控制器
    [self setupAllChildVc];
    
    //添加所有的顶部标题
    [self setupAllTitle];
    
    //设置scrollView属性
    [self setupScrollView];
 
}

#pragma mark 懒加载
-(NSMutableArray *)titleLabelArray{
    if (_titleLabelArray == nil) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}



#pragma mark 设置scrollView属性
-(void)setupScrollView{
    NSInteger vcCount = self.childViewControllers.count;
    self.titleScrollView.contentSize = CGSizeMake(vcCount * titleLabelW, 0);
    self.contentScrollView.contentSize = CGSizeMake(vcCount * SCREEN_WIDTH, 0);

}

#pragma mark 添加所有标题
-(void)setupAllTitle{
    NSInteger vcCount = self.childViewControllers.count;
    for (NSInteger i = 0; i < vcCount; i++) {
        CQTitleLabel *titleLabel = [[CQTitleLabel alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        //给label添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)];
        [titleLabel addGestureRecognizer:tap];
        //默认选中第一个
        if (i == 0) {
            [self titleLabelClick:tap];
        }
        titleLabel.tag = i;
        titleLabel.x = titleLabelW * i;
        titleLabel.text = vc.title;
        [self.titleLabelArray addObject:titleLabel];
        [self.titleScrollView addSubview:titleLabel];
    }

}

#pragma mark 添加所有子控制器
-(void)setupAllChildVc{
    //头条
    CQTopViewController *topVc = [[CQTopViewController alloc]init];
    topVc.title = @"头条";
    [self addChildViewController:topVc];
    
    //热点
    CQHotViewController *hotVc = [[CQHotViewController alloc]init];
    hotVc.title = @"热点";
    [self addChildViewController:hotVc];
    
    //视频
    CQVideoViewController *videoVc = [[CQVideoViewController alloc]init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    //社会
    CQSocietyViewController *societyVc = [[CQSocietyViewController alloc]init];
    societyVc.title = @"社会";
    [self addChildViewController:societyVc];
    
    //阅读
    CQReaderViewController *readVc = [[CQReaderViewController alloc]init];
    readVc.title = @"阅读";
    [self addChildViewController:readVc];

    //科技
    CQScienceViewController *scienceVc = [[CQScienceViewController alloc]init];
    scienceVc.title = @"科技";
    [self addChildViewController:scienceVc];

}

#pragma mark - 事件处理
-(void)titleLabelClick:(UITapGestureRecognizer *)tap{
    CQTitleLabel *label = (CQTitleLabel *)tap.view;
    [self selectLabel:label];
    //获取偏移量
    CGFloat offetX = SCREEN_WIDTH * label.tag;
    [self showVcWithOffsetX:offetX];
    self.contentScrollView.contentOffset = CGPointMake(offetX, 0);
    //让label居中显示
    [self showLaelAtmiddle:label];

}


#pragma mark - 私有方法
#pragma mark 选中的label
-(void)selectLabel:(CQTitleLabel *)label{
    self.selectedLabel.highlighted = NO;
    //还原之前label的效果
    self.selectedLabel.transform = CGAffineTransformIdentity;
    self.selectedLabel.textColor = [UIColor blackColor];
    label.scale = 1;
    self.selectedLabel = label;

}

#pragma mark 居中显示顶部label
/*
 偏移宽度为当前的X减去屏幕的一半,
 偏移的界限,如果计算后偏移为负数了  这偏移为0,
 偏移的最大值为滚动条的contentSize的宽度减去屏幕
 */
-(void)showLaelAtmiddle:(UILabel *)label{
    CGFloat offsetX = label.centerX - SCREEN_WIDTH * 0.5;
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - SCREEN_WIDTH;
    if (offsetX < 0) {
        offsetX = 0;
    }
    if (offsetX >= maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}


#pragma mark  需要添加的vc
-(void)showVcWithOffsetX:(CGFloat)offetX{
    NSInteger index = offetX / SCREEN_WIDTH;
    UIViewController *vc = self.childViewControllers[index];
    if (vc.isViewLoaded) return;
    vc.view.frame = CGRectMake(offetX, 0, self.contentScrollView.width, self.contentScrollView.height);
    vc.view.backgroundColor = CQRandomColor;
    [self.contentScrollView addSubview:vc.view];
}



#pragma mark - 代理,通知等
#pragma mark scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取滚动的页码
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    //获取左边label角标
    NSInteger leftIndex = curPage;
    
    //获取右边label角标
    NSInteger rightIndex = leftIndex + 1;
    
    //获取右边label的比例
    CGFloat rightScale = curPage - leftIndex;
    
    //获取左边label的比例
    CGFloat leftScale =  1 - rightScale;
    
    //获取左边label
    CQTitleLabel *leftLabel = self.titleLabelArray[leftIndex];
    leftLabel.scale = leftScale;
    
    
    //获取右边的label
    CQTitleLabel *rightLabel;
    if (rightIndex < self.titleLabelArray.count - 1) {
        rightLabel = self.titleLabelArray[rightIndex];
    }
    rightLabel.scale = rightScale;

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //获取滚动的范围
    CGFloat offsetX = scrollView.contentOffset.x;
    //滚动完成在加载view
    [self showVcWithOffsetX:offsetX];
    
    //获取滚动的标签
    NSInteger index = offsetX / SCREEN_WIDTH;
    //拿到当前应该显示的label
    CQTitleLabel *showLabel = self.titleLabelArray[index];
    [self selectLabel:showLabel];
    //让label居中显示
    [self showLaelAtmiddle:showLabel];

}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidEndScrollingAnimation");
    
}

@end
