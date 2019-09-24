//
//  AddressPickerView.h
//  B2CShop
//
//  Created by 蔡卓越 on 16/7/25.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectRowBlock) (UIPickerView *pickerView, NSInteger component, NSInteger selectRow);

@interface AddressPickerView : UIView

@property (nonatomic, copy) SelectRowBlock rowBlock;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *provinceArray;

@property (nonatomic, strong) NSArray *cityArray;

@property (nonatomic, strong) NSArray *areaArray;


@property (nonatomic, strong) UIButton *completeBtn;



- (instancetype)initWithFrame:(CGRect)frame rowBlock:(SelectRowBlock)rowBlock provinceList:(NSArray *)provinceList cityList:(NSArray*)cityList;

- (void)show;

- (void)hide;

@end
