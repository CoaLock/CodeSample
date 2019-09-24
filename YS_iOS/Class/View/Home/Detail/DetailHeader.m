//
//  DetailHeader.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DetailHeader.h"
#import <WebKit/WebKit.h>
#import "BaseWKWebview.h"

#import "UIImageView+SetImageWithURL.h"



#import "GArticleModel.h"

@interface DetailHeader ()


@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagBtn;


@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

@property (weak, nonatomic) IBOutlet UILabel *nickName;



@property (weak, nonatomic) IBOutlet UIView *praiseBg;


@property (weak, nonatomic) IBOutlet BaseWKWebview *webView;

@property (weak, nonatomic) IBOutlet UILabel *authorIcon;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardListHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;

@end


@implementation DetailHeader


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_attentBtn setEnlargeEdge:20];
    [_rewardBtn setEnlargeEdge:20];
    [_praiseBtn setEnlargeEdge:20];

    
    _attentBtn.lk_attribute
    .normalBackgroundImage([UIColor createImageWithColor:kAppCustomMainColor])
    .selectBackgroundImage([UIColor createImageWithColor:kTextSecondLevelColor])
    .normalTitle(@"+关注")
    .selectTitle(@"已关注");
   
    
    _praiseBtn.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_praise_white"]);
    //.selectImage([UIImage imageNamed:@"ic_praise_selected_small"]);

    
    _authorIcon.lk_attribute
    .corner(2)
    .border(kTextThirdLevelColor, 1);
    

    GrassWeakSelf;
    _webView.loadEndBlock = ^(CGFloat height) {
    
        [weakSelf changeHeight:height];
    };
}




- (void)changeHeight:(CGFloat)height {
    
    self.webViewHeight.constant = height;
    
    NSInteger rewardCount = _articleModel.articleRewardList.rewardList.count;
    self.rewardListHeight.constant = rewardCount >0 ? 44 :0;

    self.height = self.height -200 -44 + height + self.rewardListHeight.constant;
    
    UITableView *tableView = (UITableView*)self.superview;
    tableView.tableHeaderView = self;    
}


- (void)changeRewardList:(GArticleModel*)articleModel {

    
    if (self.rewardListHeight.constant < 1) {
     
        self.rewardListHeight.constant = 44;
        
        self.height = self.height +44;
        
        
        // [self layoutSubviews];
        
        UITableView *tableView = (UITableView*)self.superview;
        tableView.tableHeaderView = self;
        
    }
    
    NSArray *rewardList = _articleModel.articleRewardList.rewardList;
    _rewardListView.rewardList = rewardList;
}


#pragma mark - Setter
- (void)setIsPraised:(BOOL)isPraised {
    _isPraised = isPraised;

    _praiseBg.backgroundColor = isPraised ? kAuxiliaryTipColor :kTextSecondLevelColor;
}

- (void)setArticleModel:(GArticleModel *)articleModel {

    _articleModel = articleModel;
    
    _tittleLabel.text = _articleModel.title;
    
    
    // 时间 + 标签
    //NSString *timeInterval = _articleModel.passTime;
   // NSString *timeStr = [NSString stringFromTimeStamp:timeInterval formatter:@"yyyy-MM-dd"];

    NSArray *tagList = _articleModel.tagList;
    NSMutableArray *tagNames = @[].mutableCopy;
    for (TagModel *tagName in tagList) {
        
        [tagNames addObject:tagName.tagName];
    }
    NSString *tagStr = [tagNames componentsJoinedByString:@" · "];
    
    _tagBtn.text = [NSString stringWithFormat:@"%@    %@", _articleModel.passTimeStr, tagStr];


    
    [_headIcon setYSImageWithURL:_articleModel.authorInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    _nickName.text = _articleModel.authorInfo.nickname;
    
    
    // 关注
    BOOL isFollow = [PASS_NULL_TO_NIL(_articleModel.isFollow) integerValue] == 1;
    _attentBtn.selected = isFollow;
    
    
    _praiseLabel.text = [NSString stringWithFormat:@"%@", _articleModel.zanNumStr];
    
    
    _webView.htmlStr = _articleModel.contents;
    
    
    NSArray *rewardList = _articleModel.articleRewardList.rewardList;
    
    _rewardListView.rewardList = rewardList;
    
    
    self.isPraised = [PASS_NULL_TO_NIL(_articleModel.isZan) integerValue] == 1;
    
    
}


@end
