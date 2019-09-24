//
//  ArticleDynamicCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/5.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ArticleDynamicCell.h"

#import "ArticleDynamicTop.h"

#import "MessageModel.h"
#import "UIImageView+SetImageWithURL.h"



@interface ArticleDynamicCell ()


@property (weak, nonatomic) IBOutlet ArticleDynamicTop *topView;


@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;


@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;

@property (weak, nonatomic) IBOutlet UILabel *fromContent2;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel3;

@property (weak, nonatomic) IBOutlet UILabel *fromContent3;


@property (weak, nonatomic) IBOutlet ArticleDynamicTop *topView2;


@property (weak, nonatomic) IBOutlet ArticleDynamicTop *topView3;




@property (weak, nonatomic) IBOutlet UIImageView *headIcon1;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;

@property (weak, nonatomic) IBOutlet UILabel *descLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;


@property (weak, nonatomic) IBOutlet UIImageView *headIcon2;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;

@property (weak, nonatomic) IBOutlet UILabel *descLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;



@property (weak, nonatomic) IBOutlet UIImageView *headIcon3;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel3;

@property (weak, nonatomic) IBOutlet UILabel *descLabel3;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel3;






@end

@implementation ArticleDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageModel:(MessageModel *)messageModel {

    _messageModel = messageModel;
    
    /*
     // 2.文章被点赞  1111  简单格式
     
     // 3.文章被评论  2222
     
     // 4.文章被打赏  1111
     
     // 5.文章被收藏  1111
     
     // 6.评论被点赞  1111
     
     // 7.评论被评论  3333
     */
    
    
    
    NSInteger type = [PASS_NULL_TO_NIL(messageModel.type) integerValue];
    
    if (_topView.headIcon == nil && (type == 2 || type == 4 || type ==5 || type == 6)) {
        
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"ArticleDynamicTop" owner:nil options:nil].lastObject;
        [self.contentView addSubview:self.topView];
        
        
        _topView.headIcon.lk_attribute
        .corner(15);
        
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.mas_offset(0);
            make.height.mas_equalTo(40);
        }];
    }

    
    
    if (_topView2.headIcon == nil && (type == 7)) {
        
        self.topView2 = [[NSBundle mainBundle] loadNibNamed:@"ArticleDynamicTop" owner:nil options:nil].lastObject;
        [self.contentView addSubview:self.topView2];
        
        _topView2.headIcon.lk_attribute
        .corner(15);
        
        [_topView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.mas_offset(0);
            make.height.mas_equalTo(40);
        }];
    }
    
    
    
    if (_topView3.headIcon == nil && (type == 3)) {
        
        self.topView3 = [[NSBundle mainBundle] loadNibNamed:@"ArticleDynamicTop" owner:nil options:nil].lastObject;
        [self addSubview:self.topView3];
        
        _topView3.headIcon.lk_attribute
        .corner(15);
        
        [_topView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.mas_offset(0);
            make.height.mas_equalTo(40);
        }];
    }

    
    
    // 1.类型1
    if (type == 2) {
        
    
        [_topView.headIcon setYSImageWithURL:messageModel.triggerInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
        _topView.nameLabel.text = messageModel.triggerInfo.nickname;
        _topView.descLabel.text = @"赞了您的文章";
        
        if (PASS_NULL_TO_NIL(messageModel.articleInfo)) {
            _contentLabel1.text = [NSString stringWithFormat:@"《%@》", messageModel.articleInfo.title];
        }
        else {
            _contentLabel1.text = @"该文章已下架或被删除";
        }
        
        _topView.timeLabel.text = messageModel.addtimeStr;
    }
    else if (type == 4) {
    
        
        [_topView.headIcon setYSImageWithURL:messageModel.triggerInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
        _topView.nameLabel.text = messageModel.triggerInfo.nickname;
        _topView.descLabel.text = @"打赏了您的文章";
        
        if (PASS_NULL_TO_NIL(messageModel.articleInfo)) {
            _contentLabel1.text = [NSString stringWithFormat:@"《%@》", messageModel.articleInfo.title];
        }
        else {
            _contentLabel1.text = @"该文章已下架或被删除";
        }
        
        _topView.timeLabel.text = messageModel.addtimeStr;

    }
    else if (type == 5) {
        
        [_topView.headIcon setYSImageWithURL:messageModel.triggerInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
        _topView.nameLabel.text = messageModel.triggerInfo.nickname;
        _topView.descLabel.text = @"收藏了您的文章";
        
        if (PASS_NULL_TO_NIL(messageModel.articleInfo)) {
            _contentLabel1.text = [NSString stringWithFormat:@"《%@》", messageModel.articleInfo.title];
        }
        else {
            _contentLabel1.text = @"该文章已下架或被删除";
        }
        
        _topView.timeLabel.text = messageModel.addtimeStr;

    }
    else if (type == 6) {
        
        [_topView.headIcon setYSImageWithURL:messageModel.triggerInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
        _topView.nameLabel.text = messageModel.triggerInfo.nickname;
        _topView.descLabel.text = @"赞了您的评论";
        
        if (PASS_NULL_TO_NIL(messageModel.commentInfo.contents)) {
            
            _contentLabel1.text = [NSString stringWithFormat:@"%@", messageModel.commentInfo.contents];
        }
        else {
           _contentLabel1.text = @"该评论已被删除";
        }
        
        _topView.timeLabel.text = messageModel.addtimeStr;

    }
    else if (type == 7) {
        
        [_topView2.headIcon setYSImageWithURL:messageModel.triggerInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
        _topView2.nameLabel.text = messageModel.triggerInfo.nickname;
        
        _topView2.descLabel.text = @"评论了您的评论";
        
        
        _topView2.timeLabel.text = messageModel.addtimeStr;
        
        if (PASS_NULL_TO_NIL(messageModel.commentInfo.contents)) {
            
            NSString *contents = messageModel.commentInfo.contents;
           // contents =[contents stringByReplacingOccurrencesOfString:@"\n" withString:@"..."];
            
            _contentLabel2.text = contents;
        }
        else {
            _contentLabel2.text = @"该评论已被删除";
        }
        
        
        NSString *parentStr = messageModel.commentInfo.parentInfo.contents;
        
        NSString *linkedStr = [NSString stringWithFormat:@"我的评论: %@", parentStr];
        
        NSDictionary *attrs = @{NSFontAttributeName: Font(14),
                                NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"]
                                };
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:linkedStr attributes:attrs];
        [attrStr addAttribute:NSForegroundColorAttributeName value:kTextFirstLevelColor range:NSMakeRange(0, 6)];
        
        if (PASS_NULL_TO_NIL(parentStr)) {
            
            _fromContent2.attributedText = attrStr;
        }
        else {
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"该评论已被删除" attributes:attrs];
            [attrStr addAttribute:NSForegroundColorAttributeName value:kTextFirstLevelColor range:NSMakeRange(0, attrStr.length)];
            _fromContent2.attributedText = attrStr;
        }
        
    }
    else if (type == 3) {
        
        
        [_topView3.headIcon setYSImageWithURL:messageModel.triggerInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
        _topView3.nameLabel.text = messageModel.triggerInfo.nickname;
        _topView3.descLabel.text = @"评论了您的文章";
        _topView3.timeLabel.text = messageModel.addtimeStr;
        
        
        if (PASS_NULL_TO_NIL(messageModel.commentInfo.contents)) {
            
            _contentLabel3.text = messageModel.commentInfo.contents;
        }
        else {
            _contentLabel3.text = @"该评论已被删除";
        }
        
        if (PASS_NULL_TO_NIL(messageModel.articleInfo.title)) {
            _fromContent3.text = [NSString stringWithFormat:@"《%@》", messageModel.articleInfo.title];
        }
        else {
           _fromContent3.text = @"该文章已被删除";
        }
        
        
    }

}

+ (CGFloat)getCommentForArtcileCellHeight:(NSString*)text {
    
    CGFloat height = [text getSizeForTextWithFont:14 size:CGSizeMake(kScreenWidth - (375 -314), MAXFLOAT)].height;
    
    
    return 100 + height;
}


+ (CGFloat)getCommentForCommentCellHeight:(NSString*)contentText parentText:(NSString*)parentText {
    
    CGFloat contentHeight = [contentText getSizeForTextWithFont:14 size:CGSizeMake(kScreenWidth - (375 -313), MAXFLOAT)].height;
    
    CGFloat parentHeight = [parentText getSizeForTextWithFont:14 size:CGSizeMake(kScreenWidth - (375 -313), MAXFLOAT)].height;

    
    return 140 - 60 + contentHeight + parentHeight;
}









@end
