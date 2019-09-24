//
//  UserInfoViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTableView.h"
#import "UserInfoTableViewCell.h"
#import "EditNameViewController.h"
#import "SelectPhotoUtil.h"

#import "UserInfoApi.h"
#import "UserModel.h"


#import "EditUserInfoApi.h"

#import "UploadImageApi.h"

#import "UIImage+Custom.h"

#import "AddressPickerView.h"

#import "ProvinceListApi.h"
#import "CityListApi.h"



#import <AVFoundation/AVFoundation.h>

#define kPickerHeight kHeight(255)

@interface UserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UserInfoTableView *tableView;
//日期选择器
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIView *dateView;

@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, strong) AddressPickerView *addressView;



@property (nonatomic, strong) NSArray   *provinceList;
@property (nonatomic, strong) NSArray   *cityList;
@property (nonatomic, strong) NSIndexPath *indexPathAddress;


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我的资料"];
    
    [UIBarButtonItem addLeftItemWithImageName:@"ic_return_wihte" frame:CGRectMake(0, 0, 11, 20) vc:self action:@selector(returnAction)];
    
    _indexPathAddress = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self initWithTableView];
    
    [self getUserInfo];
    
    
    [self getProvinceList];

    
    [self addKeyBoardNotification];
}

- (void)addKeyBoardNotification {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidHidden:)
                                                 name:UIKeyboardWillHideNotification                                              object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

// 禁用侧滑 返回手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return NO;
}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init

- (void)initWithTableView {

    GrassWeakSelf;
    _tableView = [[UserInfoTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped userInfoBlock:^(UserInfoType userInfoType) {
        
        [weakSelf initWithUserInfoType:userInfoType];
    }];
    
    [self.view addSubview:_tableView];
}

- (void)initWithPickerView {
    
    if (!_dateView) {
        
        _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight + 150, kScreenWidth, kPickerHeight)];
        
        //创建日期选择器
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 210)];
        
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSDate *localDate = [[NSDate alloc] init];
        
        _datePicker.maximumDate = localDate;
        
        [_datePicker setDate:localDate animated:YES];
        
        _datePicker.backgroundColor = kWhiteColor;
        
        [_dateView addSubview:_datePicker];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        bgView.backgroundColor = kBackgroundColor;
        
        //选中日期标签
        UIButton *completeBtn = [UIButton buttonWithTitle:@"确定" titleColor:kTextFirstLevelColor backgroundColor:kClearColor titleFont:16.0];
        [completeBtn addTarget:self action:@selector(completeDateSelect) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:completeBtn];
        
        
        [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.width.mas_lessThanOrEqualTo(40);
            make.height.mas_lessThanOrEqualTo(30);
            make.centerY.mas_equalTo(0);
        }];
        
        UIButton *cancleBtn = [UIButton buttonWithTitle:@"取消" titleColor:kTextFirstLevelColor backgroundColor:kClearColor titleFont:16.0];
        [cancleBtn addTarget:self action:@selector(cancleDateSelect) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancleBtn];

        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.width.mas_lessThanOrEqualTo(40);
            make.height.mas_lessThanOrEqualTo(30);
            make.centerY.mas_equalTo(0);
        }];

        
        
        [_dateView addSubview:bgView];
        
        [self.view addSubview:_dateView];

    }
    
    [self datePickerShow];
}

- (AddressPickerView *)addressView {
    if (_addressView == nil) {
        
        GrassWeakSelf;
        _addressView = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight -64, kScreenWidth, 255) rowBlock:^(UIPickerView *pickerView, NSInteger component, NSInteger selectRow) {
            if (component == 0) {
                
                NSDictionary *province = weakSelf.provinceList[selectRow];
                NSInteger provinceId = [province[@"province_id"] integerValue];
                [weakSelf getCityListWithProvinceId:provinceId];
                
                weakSelf.indexPathAddress = [NSIndexPath indexPathForRow:0 inSection:selectRow];
            }
            else if (component == 1) {
            
                weakSelf.indexPathAddress = [NSIndexPath indexPathForRow:selectRow inSection:weakSelf.indexPathAddress.section];
            }
            
        } provinceList:_provinceList cityList:_cityList];
        
        [self.view addSubview:_addressView];
        
        [_addressView.completeBtn addTarget:self action:@selector(completeAddressSelect) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _addressView;
}


#pragma mark - Private
- (void)getUserInfo {
    
    UserInfoApi *userInfoApi = [[UserInfoApi alloc] init];
    [userInfoApi getUserInfoWithFields:nil callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            UserModel *userModel = [UserModel mj_objectWithKeyValues:PASS_NULL_TO_NIL(resultData)];
            _tableView.userModel = userModel;
            
            _userModel = userModel;
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)getProvinceList {

    ProvinceListApi *provinceListApi = [[ProvinceListApi alloc] init];
    [provinceListApi getProvinceListWithCallBack:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            if ([PASS_NULL_TO_NIL(resultData) isKindOfClass:[NSArray class]]) {
                
                _provinceList = [NSArray arrayWithArray:resultData];
                
                _addressView.provinceArray = _provinceList;
                
                NSInteger provinceId = [_provinceList.firstObject[@"province_id"] integerValue];
                [self getCityListWithProvinceId:provinceId];
            }
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)getCityListWithProvinceId:(NSInteger)provinceId {

    CityListApi *cityListApi = [[CityListApi alloc] init];
    [cityListApi getCityListWithProvinceId:provinceId callBack:^(id resultData, NSInteger code) {
        
        if (code == 0) {
           
            if ([PASS_NULL_TO_NIL(resultData) isKindOfClass:[NSArray class]]) {
                _cityList = [NSArray arrayWithArray:resultData];
                
                _addressView.cityArray = _cityList;
                
                [_addressView.pickerView  reloadAllComponents];
                [_addressView.pickerView selectRow:0 inComponent:1 animated:YES];
            }

            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)changeUserHeadImg:(UIImage*)image {

    UIImage *newImage = [UIImage getHumbnailImage:image scaledToSize:CGSizeMake(200,image.size.height/image.size.width*200)];

    UploadImageApi *uploadApi = [[UploadImageApi alloc] init];
    [uploadApi uploadImageWithData:UIImagePNGRepresentation(newImage) dir:@"avatar" callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            [self editUserInfoWithValue:resultData forKey:@"headimgurl" object:image];
        }
        else {
            
            [self showErrorMsg:@"上传失败"];
        }
    }];
}

- (void)editUserInfoWithValue:(NSString*)value forKey:(NSString*)key object:(id)object {

    EditUserInfoApi *editUserInfoApi = [[EditUserInfoApi alloc] init];
    [editUserInfoApi editUserInfoWithField:key value:value callback:^(id resultData, NSInteger code) {
       
        if (code == 0 && [PASS_NULL_TO_NIL(resultData) integerValue] == 1) {
            
            if ([key isEqualToString:@"headimgurl"]) {
                
                _tableView.headIcon.image = object;
            }
            else if ([key isEqualToString:@"nickname"]) {
            
                UserInfoTableViewCell *cell = object;
                
                cell.content = value;
            }
            else if ([key isEqualToString:@"realname"]) {
                
                UserInfoTableViewCell *cell = object;
                
                cell.content = value;
            }
            else if ([key isEqualToString:@"sex"]) {
                
                UserInfoTableViewCell *cell = object;
                NSString *sexStr = @"保密";
                if ([value isEqualToString:@"1"]) {
                    sexStr= @"男";
                }
                else if ([value isEqualToString:@"2"]) {
                    sexStr= @"女";
                }
                
                cell.content = sexStr;
            }
            else if ([key isEqualToString:@"birthday"]) {
                
                UserInfoTableViewCell *cell = _tableView.visibleCells[3];
                cell.content = object;
                
            }
            else if ([key isEqualToString:@"signature"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([key isEqualToString:@"city_id"]) {
                
                UserInfoTableViewCell *cell = _tableView.visibleCells[4];
                cell.content = object;
            }

            
        }
        else if (code == 4020912) {
        
        }
        else {
            if ([key isEqualToString:@"signature"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }

            [self showTextOnly:@"编辑失败"];
        }
    }];
}


#pragma mark - Events

- (void)initWithUserInfoType:(UserInfoType)userInfoType {
    
    GrassWeakSelf;

    switch (userInfoType) {
        case UserInfoTypeNickName:
            
        {
            UserInfoTableViewCell *cell = _tableView.visibleCells[userInfoType];
            
            EditNameViewController *editNameVC = [[EditNameViewController alloc] init];
            
            editNameVC.editNameType = EditNameTypeNickName;
            editNameVC.originName = _userModel.nickname;
            editNameVC.editNameBlock = ^(NSString *name) {
                
                [weakSelf editUserInfoWithValue:name forKey:@"nickname" object:cell];
            };
            
            [weakSelf.navigationController pushViewController:editNameVC animated:YES];
        }
            break;
        
        case UserInfoTypeRealName:
            
        {
            UserInfoTableViewCell *cell = _tableView.visibleCells[userInfoType];
            
            EditNameViewController *editNameVC = [EditNameViewController new];
            editNameVC.originName = _userModel.realname;
            editNameVC.editNameType = EditNameTypeRealName;
            
            editNameVC.editNameBlock = ^(NSString *name) {
              
                [weakSelf editUserInfoWithValue:name forKey:@"realname" object:cell];
            };

            [weakSelf.navigationController pushViewController:editNameVC animated:YES];
        }
            break;
            
        case UserInfoTypeSex:
            
        {
            UserInfoTableViewCell *cell = _tableView.visibleCells[userInfoType];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf editUserInfoWithValue:@"1" forKey:@"sex" object:cell];
            }];
            
            UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf editUserInfoWithValue:@"2" forKey:@"sex" object:cell];
            }];
            
            UIAlertAction *secrecyAction = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf editUserInfoWithValue:@"0" forKey:@"sex" object:cell];
            }];
            
            [alertController addAction:maleAction];
            [alertController addAction:femaleAction];
            [alertController addAction:secrecyAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        case UserInfoTypeBirthday:
            
        {
            [weakSelf initWithPickerView];
           
            [weakSelf.addressView hide];
        }
            break;
        
        case UserInfoTypeCity:
            
        {
             [weakSelf.addressView show];
            
            [self datePickerHide];
        }
            break;
            
        case UserInfoTypeHeadIcon:
            
        {
            SelectPhotoUtil *selectPhotoUtil = [SelectPhotoUtil shareInstance];
            
            [selectPhotoUtil selectImageViewWithViewController:self success:^(UIImage *image, NSDictionary *info) {
                
                 UIImage *editImage = info[UIImagePickerControllerEditedImage];

                
                [weakSelf changeUserHeadImg:editImage];
            }];
        }
            break;
            
        default:
            break;
    }
}


- (void)completeAddressSelect {
    
    [self.addressView hide];

    NSString *provinceName = _provinceList[_indexPathAddress.section][@"province_name"];
    NSString *cityName = _cityList[_indexPathAddress.row][@"city_name"];
    NSString *address = [NSString stringWithFormat:@"%@-%@", provinceName, cityName];
    
    NSString *cityId = _cityList[_indexPathAddress.row][@"city_id"];
    [self editUserInfoWithValue:cityId forKey:@"city_id" object:address];
    
}

- (void)completeDateSelect {
    
    NSDate *pickDate = _datePicker.date;
    NSString *yearStr = [NSString stringFromDate:pickDate formatter:@"yyyy-MM-dd"];
    
    NSInteger timeInterval= pickDate.timeIntervalSince1970;
    
    [self editUserInfoWithValue:[NSString stringWithFormat:@"%li", timeInterval] forKey:@"birthday" object:yearStr];
    
    [self datePickerHide];
}

- (void)cancleDateSelect {

    [self datePickerHide];
}


- (void)datePickerShow {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _dateView.frame = CGRectMake(0, kScreenHeight -64 - kPickerHeight, kScreenWidth, kPickerHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)datePickerHide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _dateView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kPickerHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)returnAction {

    NSString *signature =_tableView.signTF.text;
    if ([signature isEqualToString:_userModel.signature]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self editUserInfoWithValue:signature forKey:@"signature" object:nil];
}

#pragma mark - Keyboard
- (void)handleKeyboardDidShow:(NSNotification*)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘高度

    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0,rect.size.height + 100, 0);
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 450, 0) animated:YES];

}

- (void)handleKeyboardDidHidden:(NSNotification*)notificaiton {
    
    _tableView.contentInset = UIEdgeInsetsZero;
}



@end
