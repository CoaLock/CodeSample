//
//  SystemNoticeCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/5.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "SystemNoticeCell.h"

#import "MessageModel.h"



@interface SystemNoticeCell ()


@property (weak, nonatomic) IBOutlet UIView *tipIcon1;

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;


@property (weak, nonatomic) IBOutlet UIView *tipView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon2;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;

@property (weak, nonatomic) IBOutlet UILabel *descLabel2;

@property (weak, nonatomic) IBOutlet UILabel *timeLbel2;



@end


@implementation SystemNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];

    if (_tipIcon1) {
        _tipIcon1.lk_attribute
        .corner(4);
    }
    
    if (_tipView2) {
        _tipView2.lk_attribute
        .corner(4);
    }

    if (_imgIcon) {
        _imgIcon.lk_attribute
        .image([[UIImage imageNamed:@"ic_system_msg_small"] imageWithColor:kAppCustomMainColor]);
    }
    
    if (_imgIcon2) {
        _imgIcon2.lk_attribute
        .image([[UIImage imageNamed:@"ic_system_msg_small"] imageWithColor:kAppCustomMainColor]);
    }
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;


    _moreBtn.userInteractionEnabled = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMessageModel:(MessageModel *)messageModel {

    _messageModel = messageModel;
    
    
    NSInteger type = [PASS_NULL_TO_NIL(messageModel.type) integerValue];

    // 1.关注
    if (type == 10) {
        
        _nameLabel2.text = messageModel.triggerInfo.nickname;
        _descLabel2.text = @"关注了您";
        
        _timeLbel2.text = messageModel.addtimeStr;
        
        _tipView2.hidden = ([PASS_NULL_TO_NIL(messageModel.isRead) integerValue] == 1);
        
        return;
    }
    
    /*
     // 8.文章审核通过
     
     // 9.文章审核未通过
     
     // 10.被用户关注
     
     // 11.群发公告
     
     // 12.一句话通知
     
     */
    
    
    _titleLabel1.text = (type ==11) ? @"群发公告" : @"系统通知";
  
    _descLabel.text = messageModel.showStr;
    
    _moreBtn.hidden = !messageModel.isShowMoreBtn;
    
    _timeLabel1.text = messageModel.addtimeStr;
    
    _tipIcon1.hidden = ([PASS_NULL_TO_NIL(messageModel.isRead) integerValue] == 1);
    
}


+ (CGFloat)getCellHeight:(NSString*)text {

    CGFloat height = [text getSizeForTextWithFont:14 size:CGSizeMake(kScreenWidth - (375 -313), MAXFLOAT)].height;
    
    if (height < 45) {
        
        return 90;
    }
   
    return 115;
}





@end
