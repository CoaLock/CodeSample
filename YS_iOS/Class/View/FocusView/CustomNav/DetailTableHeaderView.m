//
//  DetailTableHeaderView.m
//
//
//  Created by 张阳 on 16/11/23.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "DetailTableHeaderView.h"
#import "TopicModel.h"
#import "UIImageView+SetImageWithURL.h"

@interface DetailTableHeaderView ()


@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UIImageView *topIconImageView;

@property (nonatomic, strong) UILabel*topNameLabel;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *topNumberLabel;


@property (nonatomic, strong) UIButton *focusButton;

@end



@implementation DetailTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame focusButtonBlock:(FocusDetailButtoBlock)focusButtonBlock {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.focusButtonBlock = focusButtonBlock;
        
        [self setupTableHeaderView];
    }
    return self;
}

- (void)setupTableHeaderView {
    
    /*
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight)];
    imageView.image = [UIImage imageNamed:@"rect_bg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    
    //渐变涂层
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = imageView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,[(id)[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [imageView.layer insertSublayer:gradientLayer atIndex:0];
    */
    
    [self setupView:0];
}

- (void)setupView:(NSInteger)type {
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight)];
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.clipsToBounds = YES;
    topImageView.userInteractionEnabled = YES;
    topImageView.image = [UIImage imageNamed:@"pl_big"];
    [self addSubview:topImageView];
    
    _topImageView = topImageView;
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = 0.7;
    [topImageView addSubview:effectView];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    UIView *topInView = [[UIView alloc]initWithFrame:CGRectMake(0,kHeight(95), kScreenWidth, kHeight(60))];
    topInView.backgroundColor = [UIColor clearColor];
    topInView.userInteractionEnabled = YES;
    [topImageView addSubview:topInView];
    
    UIImageView *topIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"square_bg"]];
    topIconImageView.layer.borderWidth = 1;
    topIconImageView.layer.borderColor = kWhiteColor.CGColor;
    [topInView addSubview:topIconImageView];
    
    _topIconImageView = topIconImageView;
    
    [topIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(topInView.mas_top);
        make.width.height.equalTo(@(kHeight(60)));
    }];
    
    UILabel *topNameLabel = [[UILabel alloc]init];
    topNameLabel.text = @"世界摄影大师";
    topNameLabel.textColor = [UIColor whiteColor];
    topNameLabel.font = [UIFont systemFontOfSize:16];
    [topInView addSubview:topNameLabel];
    
    _topNameLabel = topNameLabel;
    
    [topNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topIconImageView.mas_right).offset(15);
        make.top.equalTo(topIconImageView.mas_top).offset(0);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = @"这里是摄影的小天地，畅游图片海洋";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.font = [UIFont systemFontOfSize:12];
    [topInView addSubview:topLabel];
    
    _topLabel = topLabel;
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topNameLabel.mas_left);
        make.top.equalTo(topNameLabel.mas_bottom).offset(4);
        make.height.mas_equalTo(17);
        make.right.mas_equalTo(-70);
    }];
    
    UILabel *topNumberLabel = [[UILabel alloc]init];
    topNumberLabel.text = @"999+关注";
    topNumberLabel.textColor = [UIColor whiteColor];
    topNumberLabel.font = [UIFont systemFontOfSize:12];
    [topInView addSubview:topNumberLabel];
    
    _topNumberLabel = topNumberLabel;
    
    [topNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topNameLabel.mas_left);
        make.top.equalTo(topLabel.mas_bottom).offset(0);
    }];
    
    UIButton * focusButton = [[UIButton alloc]init];
    focusButton.lk_attribute
    .normalTitle(@"+关注")
    .selectTitle(@"已关注")
    .font(14)
    .normalTitleColor(kWhiteColor)
    .corner(kBorderCorner)
    .event(self, @selector(videoButtonClick:))
    .normalBackgroundImage([UIColor createImageWithColor:kAppCustomMainColor])
    .selectBackgroundImage([UIColor createImageWithColor:kTextSecondLevelColor])
    .superView(topInView);
    
    _focusButton = focusButton;
    
    [focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topInView.mas_centerY);
        make.right.equalTo(topInView.mas_right).offset(-12);
        make.width.equalTo(@60);
        make.height.equalTo(@25);
    }];
}


#pragma mark - Events
- (void)setTopicModel:(TopicModel *)topicModel {
    _topicModel = topicModel;
    

    [_topImageView setYSImageWithURL:_topicModel.backgroundPic placeHolderImage:[UIImage imageNamed:@"pl_big"]];
    
    [_topIconImageView setYSImageWithURL:_topicModel.basePic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];
    
    _topNameLabel.text = topicModel.title;
    _topLabel.text = topicModel.desc;
    
    _topNumberLabel.text = [NSString stringWithFormat:@"%@ 关注", topicModel.fansNum];

    _focusButton.selected = ([PASS_NULL_TO_NIL(_topicModel.isFollow) integerValue] ==1);
    
}


#pragma mark - Events
- (void)videoButtonClick:(UIButton*)btn {
    
    if (self.focusButtonBlock) {
        
        self.focusButtonBlock(btn);
    }
}




@end
