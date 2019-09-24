//
//  PublishTextCell.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PublishTextCell.h"


@interface PublishTextCell () <UITextViewDelegate>



@end


@implementation PublishTextCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _textField = [[UITextView alloc] init];
        _textField.font = Font(15.0);
        _textField.scrollEnabled = NO;
        
        [self.contentView addSubview:_textField];
        
        _textField.delegate = self;
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}

- (void)setContent:(NSString *)content {
    
    _content = content;
    
    _textField.text = _content;
}


#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
  

//    if (_editBlock) {
//        _editBlock(textView.text, textView.tag-1000, EditStatusBegin, textView.selectedRange);
//    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat cursorPositionY;
        if (textView.selectedTextRange) {
            cursorPositionY = [textView caretRectForPosition:textView.selectedTextRange.start].origin.y;
        } else {
            cursorPositionY = 0;
        }
        
        // cursorPositionY
        CGRect cursorRowFrame = CGRectMake(0, 0, kScreenWidth, textView.height);
        
        _reloadBlock(textView.tag -1000, cursorRowFrame);
    });
}

- (void)textViewDidChange:(UITextView *)textView{
    
     
    CGSize size = [textView sizeThatFits:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
    if (ABS(textView.height - size.height) < 1) {
        return;
    }
    
    CGFloat height = size.height;
    self.height = height +1;
    
    if (_reloadBlock) {
    
        
        CGFloat cursorPositionY;
        if (textView.selectedTextRange) {
            cursorPositionY = [textView caretRectForPosition:textView.selectedTextRange.start].origin.y;
        } else {
            cursorPositionY = 0;
        }
        // cursorPositionY
        CGRect cursorRowFrame = CGRectMake(0, 0, kScreenWidth, height);
        
        
        _reloadBlock(textView.tag -1000, cursorRowFrame);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    // 判断光标是否在行首返回
    if ([text isEqualToString:@""] && textView.selectedRange.location == 0) {
        
        if (_mergeTextBlock) {
            
            _mergeTextBlock(textView.tag-1000, textView.text);
            
            return NO;
        }
            
    }
    
    // 判断输入的字是否是回车，
    if ([text isEqualToString:@"\n"]){
     
        
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView resignFirstResponder]) {
       
        if (_editBlock) {
            
            _editBlock(textView.text, textView.tag-1000, EditStatusEnd, textView.selectedRange);
        }
    }
}



@end
