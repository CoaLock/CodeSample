//
//  DynamicLabel.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/29.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DynamicLabel.h"
#import "TagModel.h"

static unsigned kMarginLeft     =  16;
static unsigned kMarginRight    =  16;
static unsigned kMarginTop      =  20;
static unsigned kMarginBottom   =  20;

static unsigned KButtonHeight   =  30;
static unsigned KSpaceH         =  20;
static unsigned KSpaceV         =  20;




@interface DynamicLabel ()

@property (nonatomic, strong) NSArray *tagList;

@property (nonatomic, assign) BOOL     needSelected;

@property (nonatomic, copy)  void (^heightChangeBlock) (CGFloat height);


@end


@implementation DynamicLabel


#pragma mark- Initialization
- (void)_initSubviews:(NSArray*)tagList {
    
    NSInteger totalCount = tagList.count;
    
    CGFloat currentX = kMarginLeft;
    CGFloat currentY = kMarginTop;
    
    for (NSInteger i = 0; i < totalCount; i++) {
        
        TagModel *tagModel = tagList[i];
        NSString *titleStr = tagModel.tagName;
        
        CGFloat widthBtn = [self _getTextWidthWith:titleStr];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(currentX, currentY, widthBtn, KButtonHeight);
        button.tag = 1000 + i;
        
        
        button.selected = [PASS_NULL_TO_NIL(tagModel.isFollow) integerValue] == 1;
        button.userInteractionEnabled = _needSelected;
        
        
        button.layer.cornerRadius = kBorderCorner;
        button.titleLabel.font = kArticleTextFont;
        
        
        [button setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [button setTitleColor:kTextThirdLevelColor forState:UIControlStateNormal];
        button.layer.borderColor = kTextThirdLevelColor.CGColor;
        
        if (button.selected) {
            
            button.backgroundColor = kAppCustomMainColor;
            button.layer.borderWidth = 0;
        }
        else {
            
            button.backgroundColor = [UIColor clearColor];
            button.layer.borderWidth = 1;
        }
        
        
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i + 1 < totalCount) {
            
            TagModel *nextTagModel = tagList[i+1];
            NSString *titleStrNext = nextTagModel.tagName;
            CGFloat widthBtnNext = [self _getTextWidthWith:titleStrNext];
            
            if (widthBtnNext + KSpaceH + kMarginRight > (kScreenWidth - currentX - widthBtn)) {
                
                currentX = kMarginLeft;
                currentY = currentY + KButtonHeight + KSpaceV;
            }
            else {
                currentX = currentX + KSpaceH + widthBtn;
                currentY =currentY;
            }
        }
        
        if (i + 1 == totalCount) {
            
            CGFloat height = button.bottom + kMarginBottom;
            
            self.height = height;
            
            if (_heightChangeBlock) {
                _heightChangeBlock(height);
            }
        }
        
    }
}

- (instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray*)tagList needSelected:(BOOL)needSelected heightChangeBlock:(void (^) (CGFloat height))heightChangeBlock {
    
    if (self = [super initWithFrame:frame]) {
        
        _needSelected = needSelected;
        
        _tagList = tagList;
        
        _heightChangeBlock = [heightChangeBlock copy];
        
        [self _initSubviews:_tagList];
        
        
    }
    return self;
}

#pragma mark - Private
- (CGFloat)_getTextWidthWith:(NSString*)text {
    
    STRING_NIL_NULL(text);
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, attrStr.length)];
    CGRect frame = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat width = (frame.size.width + 20 +kMarginLeft +kMarginRight > kScreenWidth) ? (kScreenWidth - kMarginLeft -kMarginRight) : (frame.size.width + 20);
    return width;
}


#pragma mark - Events
- (void)buttonOnClicked:(UIButton*)button {

    
    if (_tagChangeBlock) {
        
        _tagChangeBlock(button, button.tag -1000);
        
        return;
    }
    
    
    NSInteger count = 0;
    for (TagModel *tagM in _tagList) {
        
        if ([PASS_NULL_TO_NIL(tagM.isFollow) integerValue] == 1) {
            count++;
        }
    }
    if (_limitedNum > 0 && count == _limitedNum && !button.selected) {

        if (_limitTipBlock) {
            _limitTipBlock();
        }
        return;
    }

    
    button.selected = !button.selected;
    
    NSInteger index = button.tag -1000;
    
    TagModel *tagModel = _tagList[index];
    
    tagModel.isFollow = [NSString stringWithFormat:@"%d", button.selected];
    
    if (button.selected) {
     
        button.backgroundColor = kAppCustomMainColor;

        button.layer.borderWidth = 0;
    }
    else {
    
        button.backgroundColor = [UIColor clearColor];

        button.layer.borderWidth = 1;

    }
}






@end
