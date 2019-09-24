//
//  ZYSearchBar.h
//  BS
//
//  Created by 张阳 on 16/4/5.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYSearchBar : UITextField<UITextFieldDelegate>


/** 外部UITextField接口*/
@property (nonatomic , strong) UITextField *textField;



@property (nonatomic, copy) void (^searchBlock) (NSString *str);


+(instancetype)searchBarWithFrame:(CGRect)frame;


@end
