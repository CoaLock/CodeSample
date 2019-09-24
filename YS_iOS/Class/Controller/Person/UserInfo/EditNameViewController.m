//
//  EditNameViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "EditNameViewController.h"

@interface EditNameViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameTF;

@end

@implementation EditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithSubviews];
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [_nameTF resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    [_nameTF becomeFirstResponder];
}
#pragma mark - Init
- (void)initWithSubviews {

    NSString *title = _editNameType == EditNameTypeNickName ? @"修改昵称": @"修改姓名";
    
    self.navigationItem.titleView = [UILabel labelWithTitle:title];
    
    [UIBarButtonItem addRightItemWithTitle:@"完成" frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(clickEditNameComplete)];
    
    self.view.backgroundColor = kPaleGreyColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 44)];
    
    bgView.backgroundColor = kWhiteColor;
    
    UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 24, 44)];
    nameTF.font = Font(16);
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTF.delegate = self;
    nameTF.returnKeyType = UIReturnKeyDone;
    
    nameTF.placeholder = _editNameType == EditNameTypeNickName ? @"请输入昵称": @"请输入姓名";

    if (_originName.length > 0) {
        nameTF.text = _originName;
    }
    
    _nameTF = nameTF;

    [bgView addSubview:nameTF];
    
    [self.view addSubview:bgView];
    
}

#pragma mark - Events
- (void)clickEditNameComplete {

    if (_editNameBlock) {
        
        [_nameTF resignFirstResponder];
        _editNameBlock(_nameTF.text);
        
        if (_nameTF.text.length == 0) {
            
            NSString *msg = _editNameType == EditNameTypeNickName ? @"请输入昵称": @"请输入昵称";
            [self showTextOnly:msg];
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFiledDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    
    return YES;
}

@end
