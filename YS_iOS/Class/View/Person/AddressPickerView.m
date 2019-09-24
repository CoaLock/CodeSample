//
//  AddressPickerView.m
//  B2CShop
//
//  Created by 蔡卓越 on 16/7/25.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "AddressPickerView.h"

@interface AddressPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation AddressPickerView

- (instancetype)initWithFrame:(CGRect)frame rowBlock:(SelectRowBlock)rowBlock provinceList:(NSArray *)provinceList cityList:(NSArray*)cityList {
    if (self = [super initWithFrame:frame]) {
        
        _provinceArray = provinceList;
        _cityArray = cityList;
        
        _rowBlock = [rowBlock copy];
        
        [self initWithTopView];
        
        [self initWithPickerView];
        
    }
    
    return self;
}

#pragma mark - Init

- (void)initWithPickerView {

    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 210)];
    _pickerView.backgroundColor = kWhiteColor;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self addSubview:_pickerView];
    
}

- (void)initWithTopView {

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    topView.backgroundColor = kBackgroundColor;
    
    
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kTextFirstLevelColor backgroundColor:kClearColor titleFont:16.0];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    
    
    UIButton *completeBtn = [UIButton buttonWithTitle:@"确定" titleColor:kTextFirstLevelColor backgroundColor:kClearColor titleFont:16.0];
    
    [topView addSubview:completeBtn];
    
    _completeBtn = completeBtn;
    
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self addSubview:topView];
}

#pragma mark - Events

- (void)clickCancel {

    [self hide];
}

- (void)show {

    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(0, kScreenHeight -64- 255, kScreenWidth, 255);
    }];
}

- (void)hide {

    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 255);
        
    } completion:^(BOOL finished) {
        
        
    }];
}

#pragma mark - UIPickerViewDataSource
// 返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    if (_areaArray.count > 0) {
        
        return 3;
    }
    
    if (_cityArray.count > 0) {
        
        return 2;
    }
    
    return 1;
}
// 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        
        return _provinceArray.count;
        
    }else if (component == 1) {
    
        return _cityArray.count;
        
    }else {
    
        return _areaArray.count;
    }
}

#pragma mark - UIPickerViewDelegate
// 返回当前行的内容, 此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if (component == 0) {
        
        NSDictionary *provinceInfo = _provinceArray[row];

        return provinceInfo[@"province_name"];
        
    }else if (component == 1) {
        
        NSDictionary *cityInfo = _cityArray[row];
        
        return cityInfo[@"city_name"];
        
    }else {
        
        NSDictionary *areaInfo = _areaArray[row];
        
        return areaInfo[@"area_name"];
    }
    
}

//每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    return kScreenWidth /3.0;
}

//选中行的事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    _rowBlock(pickerView, component, row);
    
}

//每行字体大小

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];

        //pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}


@end
