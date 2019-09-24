//
//  PublishTextCell.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, EditStatus) {
    EditStatusBegin,
    EditStatusEnd,
};

typedef void (^CellEditBlock) (NSString *text, NSInteger tag, EditStatus editStatus, NSRange selectRange);



@interface PublishTextCell : UITableViewCell

@property (nonatomic, strong, readonly) UITextView *textField;


@property (nonatomic, strong) NSString *content;


// textView end edit callback
@property (nonatomic, copy) CellEditBlock editBlock;


// textView begin edit and did edit status callback
@property (nonatomic, copy) void (^reloadBlock) (NSInteger index, CGRect cellFrame);


// return when the cursor on the beginning of a line
@property (nonatomic, copy) void (^mergeTextBlock) (NSInteger tag, NSString *leftText);


@end
