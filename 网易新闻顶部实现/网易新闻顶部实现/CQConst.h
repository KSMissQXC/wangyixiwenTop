#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

static CGFloat const titleLabelW = 100;
static CGFloat const titleLabelH = 44;

// 设备尺寸
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//RGB颜色
#define CQColor(r,g,b) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0]
//随机颜色
#define CQRandomColor CQColor((arc4random_uniform(256)),(arc4random_uniform(256)),(arc4random_uniform(256)))








