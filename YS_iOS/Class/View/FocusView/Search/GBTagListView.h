

#import <UIKit/UIKit.h>

@interface GBTagListView : UIView {
    
    CGRect previousFrame ;
    int totalHeight ;
    NSMutableArray * _tagArr;
}


/** cell高度*/
@property (nonatomic , assign)CGFloat cellHeight;

/**
 * 整个view的背景色
 */
@property(nonatomic,retain) UIColor *GBbackgroundColor;
/**
 *  设置单一颜色
 */
@property (nonatomic) UIColor*signalTagColor;
/**
 *  回调统计选中tag
 */
@property(nonatomic,copy)void (^didselectItemBlock) (NSArray*arr);

@property(nonatomic) BOOL canTouch;

/**
 *  标签文本赋值
 */
-(void)setTagWithTagArray:(NSArray*)arr;


@end
