//
//  PersonView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonView.h"
#import "UserModel.h"

#import "BaseTableView.h"

#import <SDWebImage/UIImageView+WebCache.h>



@interface PersonView() <UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *editView;


@property (nonatomic, strong) UIImageView *headIcon;

@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *moneyBtn;

@property (nonatomic, strong) UIButton *fanBtn;

@property (nonatomic, strong) BaseTableView *tableView;



@end

@implementation PersonView

- (instancetype)initWithFrame:(CGRect)frame personBlock:(PersonBlock)personBlock {

    if (self = [super initWithFrame:frame]) {
        
        _personBlock = personBlock;
        
        [self initWithSubviews];
    }
    
    return self;
}

#pragma mark - Init

- (void)initWithSubviews {

    [self initBgView];
    
    
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _tableView = [[BaseTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    
    
    [self initWithTopView];
    
    [self initWithBottomView];
}

- (void)initBgView {

    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_person"]];
    
    NSString *imgUrlStr = [Singleton sharedManager].personal_background;
    [bgImage sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_person"]];
    [self addSubview:bgImage];
    
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    effectView.alpha = 0.5;
    [bgImage addSubview:effectView];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}



- (void)initWithTopView {

    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(210 + 40))];
    _topView = topView;
    
    
    UIButton *cancelBtn = [UIButton buttonWithImageName:@"ic_close_black"];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    [cancelBtn setEnlargeEdge:30];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(31);
        make.width.height.mas_equalTo(22);
    }];
    
    
    UIView *editView = [[UIView alloc] init];
    editView.userInteractionEnabled = YES;
    
    [topView addSubview:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(kWidth(140));
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(kWidth(70));
    }];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personTapGR:)];
    [editView addGestureRecognizer:tapGR];
    _editView = editView;
    
    //    pl_header
    _headIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_no_content"]];
    _headIcon.lk_attribute
    .corner(kBorderCorner)
    .border(kWhiteColor, 1)
    .superView(editView);
    
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(kWidth(80));
        make.top.mas_equalTo(0);
    }];
    
    
    _nickNameLabel = [UILabel labelWithText:@"曲水流觞" textColor:kBlackColor textFont:16.0];
    _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [editView addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(kWidth(22));
        make.top.mas_equalTo(_headIcon.mas_bottom).offset(kWidth(15));
        
    }];
    
    
    UIColor *signColor = [UIColor colorWithHexString:@"#666666"];
   _textLabel = [UILabel labelWithText:@"人间四月芳菲尽，山寺桃花始盛开" textColor:signColor textFont:14.0];
    
//    kTextSecondLevelColor
    
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 2;
    [editView addSubview:_textLabel];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(_headIcon.mas_bottom).mas_equalTo(kWidth(40));
    }];
    
    
    // 金币 粉丝
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = kTextFirstLevelColor;
    
    [_topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-1);
    }];
    
    _moneyBtn = [UIButton buttonWithTitle:@"金币  0" titleColor:kTextFirstLevelColor backgroundColor:kClearColor titleFont:16.0];
    [_topView addSubview:_moneyBtn];
    _moneyBtn.tag = 1201;
    [_moneyBtn addTarget:self action:@selector(clickPersonBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(lineView.mas_left).mas_equalTo(-20);
        make.width.mas_lessThanOrEqualTo(120);
        make.height.mas_equalTo(22);
        make.bottom.mas_equalTo(0);
    }];
    
    _fanBtn = [UIButton buttonWithTitle:@"粉丝  99" titleColor:kTextFirstLevelColor backgroundColor:kClearColor titleFont:16.0];
    
    [_topView addSubview:_fanBtn];
    [_fanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(lineView.mas_right).mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(120);
        make.height.mas_equalTo(22);
        make.bottom.mas_equalTo(0);
    }];
 
    
    _tableView.tableHeaderView = _topView;
}



- (void)initWithBottomView {

    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 320)];
    _tableView.tableFooterView = bottomView;
    
    
    NSArray *textArray = @[@"我的消息",@"我的金币",@"我的文章",@"我的收藏",@"我的关注",@"帮助中心",@"设置"];
    
    for (int i = 0; i < textArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithTitle:textArray[i] titleColor:kTextFirstLevelColor backgroundColor:kClearColor titleFont:16.0];
        
        btn.tag = 1200 + i;
        [btn addTarget:self action:@selector(clickPersonBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(i*44);
            
        }];
        
        if (i == 0) {
            
            _msgDot = [[UIView alloc] init];
            _msgDot.lk_attribute
            .backgroundColor(kAuxiliaryTipColor)
            .corner(4)
            .superView(bottomView);
            
            _msgDot.hidden = YES;
            
            [_msgDot mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(38);
                make.width.height.mas_equalTo(8);
                make.centerY.mas_equalTo(btn.mas_centerY).mas_offset(0);
                
            }];
            
        }
        
        
    }
}

#pragma mark - Public
- (void)loadUserInfo:(UserModel*)userInfo {

    [_headIcon sd_setImageWithURL:[NSURL URLWithString:userInfo.headimgurl] placeholderImage:[UIImage imageNamed:@"bg_no_content"]];

    // bg_no_content  pl_header
    
    _nickNameLabel.text = userInfo.nickname.length >0 ? userInfo.nickname : @"小树苗";
    
    _textLabel.text = userInfo.signature.length >0 ? userInfo.signature : @"暂未设置签名哦";
 
    NSString *leftMoney = [NSString stringWithFormat:@"金币  %@", userInfo.leftMoney];
    
    [_moneyBtn setTitle:leftMoney forState:UIControlStateNormal];
    
    NSString *fanNum = [NSString stringWithFormat:@"粉丝  %@", userInfo.fansNum];
    [_fanBtn setTitle:fanNum forState:UIControlStateNormal];
}


#pragma mark - Events

- (void)clickCancelBtn:(UIButton *)sender {

    if (_personBlock) {
        
        _personBlock(PersonTypeCancel);
    }
}

- (void)clickPersonBtn:(UIButton *)sender {

    NSInteger index = sender.tag - 1200;
    
    if (_personBlock) {
        
        switch (index) {
            case 0:
                
                _personBlock(PersonTypeMessage);
                break;
                
            case 1:
                
                _personBlock(PersonTypeMoney);
                break;
                
            case 2:
                
                _personBlock(PersonTypeArticle);
                break;
                
            case 3:
                
                _personBlock(PersonTypeCollect);
                break;
                
            case 4:
                
                _personBlock(PersonTypeFollow);
                break;
                
            case 5:
                
                _personBlock(PersonTypeHelpCenter);
                break;
                
            case 6:
                
                _personBlock(PersonTypeSetting);
                break;
            default:
                break;
        }
    }
    
}

- (void)personTapGR:(UITapGestureRecognizer *)tapGR {

    if (_personBlock) {
        _personBlock(PersonTypeInfo);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}




@end
