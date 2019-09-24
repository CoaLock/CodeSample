//
//  RewardView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/15.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "RewardView.h"
#import "UIColor+Custom.h"




@interface RewardView ()

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIView *selectCoinView;
@property (nonatomic, strong) UIView *inputCoinView;



@property (nonatomic, assign) BOOL isInputAmount;


@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UITextField *coinTF;


// 当前选中金额
@property (nonatomic, assign) CGFloat selectAmount;



@end


@implementation RewardView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.hidden = YES;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.layer.opacity = 0.001;
        [self addSubview:effectView];
        
        _effectView = effectView;
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [effectView addGestureRecognizer:tapGesture];
        
        
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        
        UIView *containView = [[UIView alloc] init];
        containView.lk_attribute
        .backgroundColor(kWhiteColor)
        .corner(8)
        .superView(self);
        _containView = containView;
        
        _containView.layer.opacity = 0.001;
        
        [containView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(287);
            make.centerY.mas_equalTo(0);
        }];
        
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.lk_attribute
        .normalImage([UIImage imageNamed:@"ic_close_white"])
        .event(self, @selector(closeAction:))
        .superView(self);
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.height.mas_equalTo(30);
            make.right.mas_equalTo(-25);
            make.bottom.mas_equalTo(containView.mas_top).mas_offset(-30);
        }];
        
        
        // 顶部
        UIImageView *topView = [[UIImageView alloc] init];
        topView.lk_attribute
        .backgroundColor(kAuxiliaryTipColor)
        .image([UIImage imageNamed:@"bg_star"])
        .superView(containView);
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(60);
        }];
        
        
        UIImageView *rewardIcon = [[UIImageView alloc] init];
        rewardIcon.lk_attribute
        .image([UIImage imageNamed:@"ic_award"])
        .backgroundColor(kWhiteColor)
        .corner(20)
        .border([UIColor colorWithRed:1 green:1 blue:1 alpha:0.5],3)
        .superView(topView);
        
        [rewardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.height.mas_equalTo(40);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(kWidth(55));
        }];
        
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.lk_attribute
        .text(@"您的支持\n将鼓励我们继续创作")
        .textColor(kWhiteColor)
        .font(14)
        .numberLines(0)
        .superView(topView);
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(rewardIcon.mas_right).offset(kWidth(30));

            make.centerY.mas_equalTo(0);
        }];
        
        
        
        
        // 输入选择金币
        UIView *selectCoinView = [[UIView alloc] init];
         selectCoinView.lk_attribute
        .superView(containView);
        
        _selectCoinView = selectCoinView;
        
        [selectCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(topView.mas_bottom).offset(0);
            make.height.mas_equalTo(130);
        }];
        
        
        CGFloat widthContain = kScreenWidth-25*2;
        
        NSArray *titles = @[@"5金币", @"10金币", @"20金币", @"30金币", @"50金币", @"其他"];
        _titles = titles;
        for (NSInteger i = 0; i < 6; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.lk_attribute
            .corner(kBorderCorner)
            .border(kAuxiliaryTipColor, 1)
            .font(14)
            .tag(1000 +i)
            .event(self, @selector(selectCoinAction:))
            .normalBackgroundImage([UIColor createImageWithColor:kWhiteColor])
            .selectBackgroundImage([UIColor createImageWithColor:kAuxiliaryTipColor])
            .superView(selectCoinView);
            
            
            [btn setBackgroundImage:[UIColor createImageWithColor:kWhiteColor] forState:UIControlStateHighlighted];
            
            
            NSDictionary *norAttr = @{NSForegroundColorAttributeName: kAuxiliaryTipColor,
                                      NSFontAttributeName: Font(20)
                                         };
            NSMutableAttributedString *normalStr = [[NSMutableAttributedString alloc] initWithString:titles[i] attributes:norAttr];
            [normalStr addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(normalStr.length -2, 2)];
           
            NSDictionary *selectedAttr = @{NSForegroundColorAttributeName: kWhiteColor,
                                      NSFontAttributeName: Font(20)
                                      };
            NSMutableAttributedString *selectedStr = [[NSMutableAttributedString alloc] initWithString:titles[i] attributes:selectedAttr];
            [selectedStr addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(normalStr.length -2, 2)];
            
            [btn setAttributedTitle:normalStr forState:UIControlStateNormal];
            [btn setAttributedTitle:selectedStr forState:UIControlStateSelected];
            
            
            if (i == 5) {
                btn.titleLabel.font = kTitleFont;
                [btn setTitle:@"其他" forState:UIControlStateNormal];
            }
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
               
                CGFloat left = (widthContain - 3*kWidth(70) - 20*2)/2;
                if (i < 3) {
                    
                    make.height.mas_equalTo(35);
                    make.width.mas_equalTo(kWidth(70));
                    make.top.mas_equalTo(40);
                    make.left.mas_equalTo(left+ i*(kWidth(70)+20));
                    
                }
                else {
                    
                    make.height.mas_equalTo(35);
                    make.width.mas_equalTo(kWidth(70));
                    make.top.mas_equalTo(105);
                    make.left.mas_equalTo(left+ (i-3)*(kWidth(70)+20));
                }
                
            }];
        }
        
        
        // 输入金币
        UIView *inputCoinView = [[UIView alloc] init];
        inputCoinView.lk_attribute
        .corner(kBorderCorner)
        .border(kSeperateLineColor, 1)
        .superView(containView);
        
        _inputCoinView = inputCoinView;
        _inputCoinView.hidden = YES;
        
        
        [inputCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_offset(30);
            make.right.mas_offset(-30);
            make.height.mas_offset(44);
            make.top.mas_equalTo(topView.mas_bottom).offset(50);
        }];
        
        UILabel *cointitleLabel = [[UILabel alloc] init];
        cointitleLabel.lk_attribute
        .text(@"金币")
        .font(16)
        .textColor(kTextFirstLevelColor)
        .superView(inputCoinView);
        
        [cointitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(0);
        }];
        
        
        UITextField *coinTF = [[UITextField alloc] init];
        coinTF.placeholder = @"输入您要打赏的金额";
        coinTF.font = Font(14);
        coinTF.keyboardType = UIKeyboardTypeNumberPad;
        [inputCoinView addSubview:coinTF];
    
        _coinTF = coinTF;
        
        
        [coinTF mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(56);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(0);
        }];
        
        
        // 底部
        UILabel *titleTipLabel = [[UILabel alloc] init];
        titleTipLabel.lk_attribute
        .text(@"确定后直接从金币余额中扣除")
        .textAlignment(NSTextAlignmentCenter)
        .font(12)
        .textColor(kTextThirdLevelColor)
        .superView(containView);
        
        [titleTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-53);
        }];
        
        
        
        UIView *lineH = [[UIView alloc] init];
        lineH.lk_attribute
        .backgroundColor(kSeperateLineColor)
        .superView(containView);
        
        [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-45);
            make.height.mas_equalTo(1);
        }];
        
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.lk_attribute
        .normalTitle(@"确定")
        .font(16)
        .event(self, @selector(submitAction))
        .normalTitleColor(kTextFirstLevelColor)
        .superView(containView);
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
        
        
    }
    return self;
}


- (void)selectCoinAction:(UIButton*)btn {

    
    for (NSInteger i =0; i < 5; i++) {
        
        UIButton *button = [btn.superview viewWithTag:1000+i];
        button.selected = NO;
    }
    
    if (btn.tag != 1005) {
        
        // 不是输入金额
        _isInputAmount = NO;
        
        NSString *amountStr = _titles[btn.tag-1000];
        
        _selectAmount = [[amountStr substringToIndex:amountStr.length -2] floatValue];
        
        btn.selected = YES;

    }
    else {
        
        
        // 输入金额
        _isInputAmount = YES;

    
        _selectCoinView.hidden = YES;
        _inputCoinView.hidden = NO;

        [_coinTF becomeFirstResponder];
        
        [_containView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(251);
            make.centerY.mas_equalTo(-90);
        }];
    }
}

- (void)tapAction {

    [self endEditing:YES];
    [self hide];
}


- (void)closeAction:(UIButton*)button {

    [self endEditing:YES];
    [self hide];    
}

- (void)submitAction {

    [self endEditing:YES];
    
    if (_selectedBlock) {
        
        if (_isInputAmount) {
         
            CGFloat amount = [_coinTF.text floatValue];
//            if (_coinTF.text.length == 0) {
//                return;
//            }
            
            _selectedBlock(amount);
        }
        else {
        
//            if (_selectAmount == 0) {
//                return;
//            }
            
            _selectedBlock(_selectAmount);
        }
        
    }
    
    [self hide];
}

- (void)show {

    self.hidden = NO;
    _containView.transform = CGAffineTransformMakeScale(0.3, 0.3);

    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _effectView.layer.opacity = 0.4;
        _containView.layer.opacity = 1;
        _containView.transform = CGAffineTransformIdentity;

        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide {

    [UIView animateWithDuration:0.15 animations:^{
        
        _containView.transform = CGAffineTransformMakeScale(0.8, 0.8);

        _effectView.layer.opacity = 0.001;
        _containView.layer.opacity = 0.001;

        
    } completion:^(BOOL finished) {
       
        _selectCoinView.hidden = NO;
        _inputCoinView.hidden = YES;
        
        [_containView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(287);
            make.centerY.mas_equalTo(0);
        }];

        self.hidden = YES;
        
        
        // 输入模式 则清空状态
        if (_isInputAmount) {
            _selectAmount = 0;
            for (NSInteger i =0; i < 5; i++) {
                
                UIButton *button = [_selectCoinView viewWithTag:1000+i];
                button.selected = NO;
            }
        }
        
        
    }];
    
}




@end
