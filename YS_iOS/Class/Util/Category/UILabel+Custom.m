//
//  UILabel+Custom.m
//  BS
//
//  Created by 蔡卓越 on 16/4/7.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)

+ (UILabel *)labelWithTitle:(NSString *)title {

    return [self labelWithTitle:title frame:CGRectMake(0, 0, 100, 30)];
}

+ (UILabel *)labelWithTitle:(NSString *)title frame:(CGRect)frame {

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = kNavBarMainColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = Font(18.0);
    
    return label;
}

//调整行间距
- (void)labelWithTextString:(NSString *)textString lineSpace:(CGFloat)lineSpace {

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textString length])];
    
    self.attributedText = attributedStr;
}


+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor textFont:(CGFloat)textFont {
    UILabel *label = [[UILabel alloc] init];
 
    label.text = text;
    label.textColor = textColor;
    label.font = Font(textFont);

    
    return label;
}
@end
