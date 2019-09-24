//
//  CommentCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"

#import "UIImageView+SetImageWithURL.h"

@interface CommentCell ()


@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priaseLabel;




@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *parentInfo;



@end


@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    
    _praiseBtn.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_praise_unselected_big"])
    .selectImage([[UIImage imageNamed:@"ic_praise_selected_big"] imageWithColor:kAppCustomMainColor]);
    
    [_praiseBtn setEnlargeEdge:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCommentModel:(CommentModel *)commentModel {

    _commentModel = commentModel;
    
    [_headIcon setYSImageWithURL:_commentModel.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    _nickLabel.text = commentModel.nickname;
    
   // NSString *timeStr = [NSString stringFromTimeStamp:_commentModel.addtime];
    _timeLabel.text = _commentModel.addtimeStr;
    
    
    _priaseLabel.text = [NSString stringWithFormat:@"%@", _commentModel.zanNum];
    

    _contentLabel.text = commentModel.contents;

    _praiseBtn.selected = ([PASS_NULL_TO_NIL(commentModel.isZan) integerValue] == 1);
    
    
    // 回复信息
    if (PASS_NULL_TO_NIL(commentModel.parentInfo)) {
        
        NSString *parentName = commentModel.parentInfo.nickname;
        NSString *parentContents = commentModel.parentInfo.contents;
        
        NSDictionary *attrDic = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]
                                  };
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", parentName, parentContents] attributes:attrDic];
        
        [attrStr addAttribute:NSForegroundColorAttributeName value:kTextFirstLevelColor range:NSMakeRange(0, parentName.length+1)];
        
        _parentInfo.attributedText = attrStr;
    }
    else {
    
        _parentInfo.text = @"";
    }

}


+ (CGFloat)getCellHeightWithContent:(NSString*)content parentContent:(NSString*)parentStr {

    NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName: Font(14)}];
    
    CGFloat contentHeight = [contentAttr boundingRectWithSize:CGSizeMake(kScreenWidth - (375 -314), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    
    if (parentStr.length == 0) {
        
        return 60 +15 + contentHeight;
    }
    
    
    NSMutableAttributedString *parentAttr = [[NSMutableAttributedString alloc] initWithString:parentStr attributes:@{NSFontAttributeName: Font(14)}];
    
    CGFloat parentHeight = [parentAttr boundingRectWithSize:CGSizeMake(kScreenWidth - (375 -305), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    return 60 + contentHeight + 33+ parentHeight;
}



@end
