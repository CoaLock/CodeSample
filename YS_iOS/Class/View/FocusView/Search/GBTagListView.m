

#import "GBTagListView.h"

//#define HORIZONTAL_PADDING 7.0f
//#define VERTICAL_PADDING   3.0f
//#define LABEL_MARGIN       10.0f
//#define BOTTOM_MARGIN      10.0f
//#define KBtnTag            1000

#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f

#define LABEL_MARGIN       20.0f

#define BOTTOM_MARGIN      20.0f

#define KBtnTag            1000


#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@implementation GBTagListView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        totalHeight=0;
        self.frame=frame;
        
        _tagArr=[[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setTagWithTagArray:(NSArray*)arr {
    
    previousFrame = CGRectZero;
    [_tagArr addObjectsFromArray:arr];
    
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        
        
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        tagBtn.frame = CGRectZero;
        if(_signalTagColor){
           
            tagBtn.backgroundColor=_signalTagColor;
        }
        else {
            tagBtn.backgroundColor = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        }
        if(_canTouch){
            
            tagBtn.userInteractionEnabled=YES;
            
        }else{
            
            tagBtn.userInteractionEnabled=NO;
        }
        
        
        [tagBtn setTitleColor:kTextSecondLevelColor forState:UIControlStateNormal];

        tagBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:str forState:UIControlStateNormal];
        
        tagBtn.tag = KBtnTag + idx;
        
        tagBtn.layer.cornerRadius = kBorderCorner;
        
        tagBtn.layer.borderColor = kTextSecondLevelColor.CGColor;
        tagBtn.layer.borderWidth = 1;
        tagBtn.clipsToBounds = YES;
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGSize Size_str = [str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*3;
        Size_str.height += VERTICAL_PADDING*5;
        
        CGRect newRect = CGRectZero;
        
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
            
            newRect.origin = CGPointMake(12, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        previousFrame=tagBtn.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];

        
    }];
    
    if(_GBbackgroundColor) {
        
        self.backgroundColor = _GBbackgroundColor;
        
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    
}

#pragma mark - 改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight {
    
    self.cellHeight = hight;
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}

- (void)tagBtnClick:(UIButton*)button{

    button.selected = !button.selected;
    [self didSelectItems];
    button.selected = !button.selected;
}

- (void)didSelectItems {
    
    NSMutableArray*arr=[[NSMutableArray alloc] init];
    
    for(UIView * view in self.subviews){
        if([view isKindOfClass:[UIButton class]]){
            
            UIButton*tempBtn = (UIButton*)view;
            if (tempBtn.selected == YES) {
                [arr addObject:_tagArr[tempBtn.tag-KBtnTag]];
            }
            
        }
    }
    
    if (self.didselectItemBlock) {
          self.didselectItemBlock(arr);
    }
}




@end
