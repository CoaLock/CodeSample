//
//  PublishHeader.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PublishHeader.h"


@interface PublishHeader () <UITextFieldDelegate>

//@property (weak, nonatomic) IBOutlet UIButton *addArticleBtn;


@end

@implementation PublishHeader



- (void)awakeFromNib {
    [super awakeFromNib];
    
    _addTagBtn.rightEdge(kScreenWidth -40).topEdge(10).bottomEdge(10);
    
    
    _titleLabel.delegate = self;
    
    _titleLabel.returnKeyType = UIReturnKeyDone;
    
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length >= 50) {
        
        return NO;
    }
    
    return YES;
}








@end
