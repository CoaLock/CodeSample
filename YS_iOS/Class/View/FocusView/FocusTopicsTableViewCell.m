//
//  FocusTopicsTableViewCell.m
//  YS_iOS
//
//  Created by 张阳 on 16/11/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "FocusTopicsTableViewCell.h"
#import "UIImageView+SetImageWithURL.h"


@interface FocusTopicsTableViewCell ()


@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UIImageView *topIconImageView;

@property (nonatomic, strong) UILabel*topNameLabel;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *topNumberLabel;


@property (nonatomic, strong) UIScrollView *bottomScroll;

@property (nonatomic, strong) UIView *blankTipView;


@end


@implementation FocusTopicsTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupTopicView];
        
        
        [self setupTablViewCell];
    }
    return self;
}



- (void)setupTopicView {

    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.clipsToBounds = YES;
    topImageView.userInteractionEnabled = YES;
    topImageView.image = [UIImage imageNamed:@"rect_bg"];
    [self.contentView addSubview:topImageView];
    
    _topImageView = topImageView;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.alpha = 0.7;
    [topImageView addSubview:effectView];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    
    UIView *topInView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 60)];
    topInView.backgroundColor = [UIColor clearColor];
    topInView.userInteractionEnabled = YES;
    [topImageView addSubview:topInView];
    
    UIImageView *topIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"square_bg"]];
    topIconImageView.layer.borderColor = kWhiteColor.CGColor;
    topIconImageView.layer.borderWidth = 1;
    [topInView addSubview:topIconImageView];
    
    _topIconImageView = topIconImageView;
    
    [topIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topInView.mas_left).offset(12);
        make.top.equalTo(topInView.mas_top);
        make.bottom.equalTo(topInView.mas_bottom);
        make.width.equalTo(@60);
    }];
    
    UILabel*topNameLabel = [[UILabel alloc]init];
    topNameLabel.text = @"世界摄影大师";
    topNameLabel.font = [UIFont systemFontOfSize:16];
    topNameLabel.textColor = [UIColor whiteColor];
    [topInView addSubview:topNameLabel];
    [topNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topIconImageView.mas_right).offset(15);
        make.top.equalTo(topIconImageView.mas_top).offset(0);
    }];
    
    _topNameLabel = topNameLabel;
    
    
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = @"这里是摄影的小天地，畅游图片的海洋";
    topLabel.font = [UIFont systemFontOfSize:12];
    topLabel.textColor = [UIColor whiteColor];
    [topInView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topNameLabel.mas_left);
        make.top.equalTo(topNameLabel.mas_bottom).offset(4);
        make.height.mas_equalTo(17);
        make.right.mas_equalTo(-70);

    }];
    
    _topLabel = topLabel;
    
    UILabel *topNumberLabel = [[UILabel alloc]init];
    topNumberLabel.text = @"999+关注";
    topNumberLabel.textColor = kWhiteColor;
    topNumberLabel.font = [UIFont systemFontOfSize:12];
    [topInView addSubview:topNumberLabel];
    
    [topNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topNameLabel.mas_left);
        make.top.equalTo(topLabel.mas_bottom).offset(0);
    }];
    
    
    _topNumberLabel = topNumberLabel;
    
    UIButton *focusButton = [[UIButton alloc]init];
    _focusButton = focusButton;
    focusButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [focusButton setTitle:@"+关注" forState:UIControlStateNormal];
    
    [focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [focusButton setTitle:@"已关注" forState:UIControlStateSelected];
    focusButton.layer.cornerRadius = 5;
    focusButton.layer.masksToBounds = YES;
    [topInView addSubview:focusButton];
    
    [focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topInView.mas_centerY);
        make.right.equalTo(topInView.mas_right).offset(-12);
        make.width.equalTo(@60);
        make.height.equalTo(@25);
    }];
    
    
    [focusButton setBackgroundImage:[UIColor createImageWithColor:kAppCustomMainColor] forState:UIControlStateNormal];
    [focusButton setBackgroundImage:[UIColor createImageWithColor:kTextSecondLevelColor] forState:UIControlStateSelected];
    
    
    UIScrollView *bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, kScreenWidth, 214)];
    bottomScroll.userInteractionEnabled = YES;
    bottomScroll.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:bottomScroll];
    
    _bottomScroll = bottomScroll;

    
    // 没有文章时候 显示视图
    _blankTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, kScreenWidth, 214)];
    _blankTipView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_blankTipView];
    _blankTipView.hidden = YES;
    
    UIImageView *blankImgView = [[UIImageView alloc] init];
    blankImgView.lk_attribute
    .image([UIImage imageNamed:@"bg_no_content"])
    .superView(_blankTipView);
    
    [blankImgView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-20);
        make.width.height.mas_equalTo(70);
    }];
    
    UILabel *blankLabel = [[UILabel alloc] init];
    blankLabel.lk_attribute
    .text(@"该话题下暂无文章哦")
    .textColor(kTextSecondLevelColor)
    .font(14)
    .superView(_blankTipView);
    
    [blankLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(blankImgView.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
}

- (void)setupTablViewCell {
    
    for (UIView *view in _bottomScroll.subviews) {
        
        if ([view isKindOfClass:[UIControl class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    self.scrollImageArray = @[].mutableCopy;
    self.shareButtonArray = @[].mutableCopy;
    self.imAnswerButtonArray = @[].mutableCopy;

    
    _blankTipView.hidden = _topicModel.articleList.count > 0;
    
    NSArray *articleList = _topicModel.articleList;
    _bottomScroll.contentSize = CGSizeMake(articleList.count *138 + (articleList.count+1)*10, _bottomScroll.height);
    
    for (NSInteger i = 0; i < articleList.count; i++) {
       
        UIControl *bgBottomView = [[UIControl alloc] initWithFrame:CGRectMake(((138+10)*i)+10, 0, 138, 214)];
        bgBottomView.userInteractionEnabled = YES;
        bgBottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomScroll addSubview:bgBottomView];
        
        [_scrollImageArray addObject:bgBottomView];
        
        
        GArticleModel *articleModel = articleList[i];
        
        
        // 1.图片
        // WithFrame:CGRectMake(0, 0, 138, 138)
        UIImageView *scrollImage = [[UIImageView alloc] init];
        scrollImage.contentMode = UIViewContentModeScaleAspectFill;
        scrollImage.clipsToBounds = YES;
        scrollImage.image = [UIImage imageNamed:@"square_bg"];
        [bgBottomView addSubview:scrollImage];
        
        [scrollImage setYSImageWithURL:articleModel.smallPic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];

        [scrollImage mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.top.mas_equalTo(0);
            make.width.height.mas_equalTo(138);
        }];
        
        // 2.标题
        UILabel *scrollLabel = [[UILabel alloc] init];
        //scrollLabel.frame = CGRectMake(4, 145, 130, 40);
        scrollLabel.textColor = kTextFirstLevelColor;
        scrollLabel.text = @"一个匠人之心，用三男时光拍摄自然之美";
        scrollLabel.numberOfLines = 2;
        scrollLabel.font = [UIFont systemFontOfSize:14];
        [bgBottomView addSubview:scrollLabel];

        scrollLabel.text = articleModel.title;
        
        
        [scrollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(4);
            make.top.mas_equalTo(145);
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(40);
        }];
        
        
        // 3.分享、评论
        for (NSInteger i = 0; i< 2; i++) {
            
            // CGRectMake(60*i, 190, 50, 20)
            UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            actionButton.lk_attribute
            .normalTitleColor(kTextSecondLevelColor)
            .font(12)
            .superView(bgBottomView);
            
            [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(55*i + 4);
                make.top.mas_equalTo(190);
                make.height.mas_equalTo(20);
            }];
            
            [actionButton setEnlargeEdge:10];
            
            if (i==0) {
            
                [actionButton setImage:[UIImage imageNamed:@"ic_share_small"] forState:UIControlStateNormal];
                [_shareButtonArray addObject:actionButton];
                
                [actionButton setTitle:[NSString stringWithFormat:@"  %@", articleModel.shareNum] forState:UIControlStateNormal];
            }
            else {
                
                [actionButton setImage:[UIImage imageNamed:@"ic_message_small"] forState:UIControlStateNormal];
                [_imAnswerButtonArray addObject:actionButton];
                
                [actionButton setTitle:[NSString stringWithFormat:@"  %@", articleModel.commentNum] forState:UIControlStateNormal];
            }
        }

    }

}


- (void)setTopicModel:(TopicModel *)topicModel {

    _topicModel = topicModel;
    
    
    [_topImageView setYSImageWithURL:_topicModel.backgroundPic placeHolderImage:[UIImage imageNamed:@"pl_big"]];
    
    [_topIconImageView setYSImageWithURL:_topicModel.basePic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];
    
    _topNameLabel.text = topicModel.title;
    _topLabel.text = topicModel.desc;
    
    _topNumberLabel.text = [NSString stringWithFormat:@"%@ 关注", topicModel.fansNum];

    
    _focusButton.selected = ([topicModel.isFollow integerValue]==1);
    
    [self setupTablViewCell];
    
}







@end
