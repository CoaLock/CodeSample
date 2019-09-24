//
//  UserInfoTableView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UserInfoTableView.h"
#import "UserInfoTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface UserInfoTableView() <UITextFieldDelegate, UITextViewDelegate>





@end

@implementation UserInfoTableView

static NSString *identifierCell = @"identifierCel";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style userInfoBlock:(UserInfoBlock)userInfoBlock {

    if (self = [super initWithFrame:frame style:style]) {
        
        _userInfoBlock = userInfoBlock;
        
        [self initWithHeaderView];
        
        [self initWithFooterView];
        
        self.backgroundColor = kBackgroundColor;
        
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([UserInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return self;
}

#pragma mark - Init

- (void)initWithHeaderView {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    headerView.backgroundColor = kBackgroundColor;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 59)];    
    whiteView.backgroundColor = kWhiteColor;
    
    [headerView addSubview:whiteView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserInfoTapGR:)];
    
    [whiteView addGestureRecognizer:tapGR];
    
    UILabel *headIconLabel = [UILabel labelWithText:@"我的头像" textColor:kTextFirstLevelColor textFont:16.0];
    [whiteView addSubview:headIconLabel];
    
    [headIconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(0);
    }];
    
    UIImageView *rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_return_right_gray"]];
    
    [whiteView addSubview:rightIcon];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(6);
        make.width.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
        
    }];
    
    _headIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pl_header"]];
    
    [whiteView addSubview:_headIcon];
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-28);
        make.width.height.mas_equalTo(50);
        make.centerY.mas_equalTo(0);
        
    }];
    
    _headIcon.layer.cornerRadius = 25;
    _headIcon.clipsToBounds = YES;
    
    
    self.tableHeaderView = headerView;
    
}

- (void)initWithFooterView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 155)];
    footerView.backgroundColor = kBackgroundColor;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 145)];
    whiteView.backgroundColor = kWhiteColor;
    [footerView addSubview:whiteView];
    
    
    UILabel *signLabel = [UILabel labelWithText:@"个性签名" textColor:kTextFirstLevelColor textFont:16.0];
    [whiteView addSubview:signLabel];
    
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(11);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(22);
        make.top.mas_equalTo(11);
        
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 44, kScreenWidth - 24, 1)];
    lineView.backgroundColor = kSeperateLineColor;
    [whiteView addSubview:lineView];
    
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.mas_equalTo(12);
//        make.top.mas_equalTo(44);
//        make.right.mas_equalTo(-12);
//        make.height.mas_equalTo(1);
// 
//    }];
    
    _signTF = [[UITextView alloc] init];
    _signTF.scrollEnabled = NO;
    _signTF.delegate = self;
    _signTF.font = Font(14.0);
    _signTF.text = @"";
    _signTF.textColor = kTextFirstLevelColor;
    [whiteView addSubview:_signTF];
    
    
    
    
    [_signTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(7);
        make.bottom.mas_equalTo(-5);
    }];
    
    
    _signPlaceHLabel = [[UILabel alloc] init];
    _signPlaceHLabel.lk_attribute
    .text(@"请输入您的个性签名")
    .font(14)
    .textColor(kTextThirdLevelColor)
    .superView(whiteView);
    
    _signPlaceHLabel.userInteractionEnabled = NO;
    [_signPlaceHLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(15);
        make.left.mas_offset(14);
    }];
    
     
    self.tableFooterView = footerView;
}

#pragma mark - Public
- (void)setUserModel:(UserModel *)userModel {
    if (PASS_NULL_TO_NIL(userModel)) {
        _userModel = userModel;

        [_headIcon sd_setImageWithURL:[NSURL URLWithString:_userModel.headimgurl] placeholderImage:[UIImage imageNamed:@"pl_header"]];
        
        _signTF.text = _userModel.signature;
        
        _signPlaceHLabel.hidden =  PASS_NULL_TO_NIL(_userModel.signature).length > 0;
        
        [self reloadData];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    NSArray *titleArray = @[@"昵称", @"姓名", @"性别", @"生日",@"城市"];
    
    cell.titleLabel.text = titleArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
     
        cell.content = _userModel.nickname;
    }
    else if (indexPath.row == 1) {
    
        cell.content = _userModel.realname;
    }
    else if (indexPath.row == 2) {
        
        NSInteger sex = [PASS_NULL_TO_NIL(_userModel.sex) integerValue];
        NSString *sexString = @"保密";
        if (sex == 1) {
            sexString = @"男";
        }
        else if (sex == 2) {
            sexString = @"女";
        }
        
        cell.content = sexString;
    }
    else if (indexPath.row == 3) {
        
        NSString *birthday = PASS_NULL_TO_NIL(_userModel.birthday).length > 1 ?  _userModel.birthday :@"";
        
        birthday = [NSString stringFromTimeStamp:birthday formatter:@"yyyy-MM-dd"];
        
        cell.content = birthday;
    }
    else if (indexPath.row == 4) {
        
        NSString *provinceName = PASS_NULL_TO_NIL(_userModel.provinceName) ? _userModel.provinceName :@"";
        NSString *cityName = PASS_NULL_TO_NIL(_userModel.cityName) ? _userModel.cityName :@"";
        NSString *address = [NSString stringWithFormat:@"%@ %@", provinceName, cityName];

        cell.content = address.length > 1? address : @"";
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_userInfoBlock) {
        
        _userInfoBlock(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.00001;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

   [self endEditing:YES];
}


#pragma mark - Events
- (void)clickUserInfoTapGR:(UITapGestureRecognizer *)tapGR {

    if (_userInfoBlock) {
        
        _userInfoBlock(UserInfoTypeHeadIcon);
    }
}

#pragma mark - UITextFiledDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        _signPlaceHLabel.hidden = YES;
    }
    else {
        _signPlaceHLabel.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    textView.scrollEnabled = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    textView.scrollEnabled = NO;
}




@end
