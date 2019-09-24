//
//  ZYSearchBar.m
//  BS
//
//  Created by 张阳 on 16/4/5.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "ZYSearchBar.h"


@interface ZYSearchBar ()

@property (nonatomic , strong) NSUserDefaults *textFeildUsers;

@end

@implementation ZYSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.textField = self;
        self.font = [UIFont systemFontOfSize:14];
        self.placeholder = @"输入文章关键词搜索";
        self.delegate = self;
        
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] init];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999"] range:NSMakeRange(0, attributedStr.length)];
        [attributedStr addAttribute:NSFontAttributeName value:Font(14.0) range:NSMakeRange(0, attributedStr.length)];
        
//        self.attributedPlaceholder = attributedStr;
        self.tintColor = kTextThirdLevelColor;
        self.textColor = kTextFirstLevelColor;
        
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        self.clearButtonMode = UITextFieldViewModeAlways;
        
        self.returnKeyType = UIReturnKeySearch;
        
        self.leftViewMode = UITextFieldViewModeAlways;

        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, KViewHeight)];        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 20, 20)];
        imgView.image = [UIImage imageNamed:@"ic_search_gary"];
        [leftview addSubview:imgView];
        
        
        self.leftView = leftview;
        
    
        
        _textFeildUsers = [NSUserDefaults standardUserDefaults];
        [_textFeildUsers setObject:@"" forKey:@"TextFieldString"];
        
    }
    return self;
}

+(instancetype)searchBarWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    
    NSString *textStr = textField.text;
    
    textStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_searchBlock && textStr.length > 0) {
        _searchBlock(textStr);
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [_textFeildUsers setObject:toBeString forKey:@"TextFieldString"];
    
    if (toBeString.length > 20) {
        
        textField.text = [toBeString substringToIndex:20];
        [_textFeildUsers setObject:textField.text forKey:@"TextFieldString"];

        return NO;
    }
    
    return YES;
    
}

@end
