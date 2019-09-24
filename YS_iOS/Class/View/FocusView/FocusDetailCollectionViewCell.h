//
//  FocusDetailCollectionViewCell.h
//  YS_iOS
//
//  Created by 张阳 on 16/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *detailCollectImage;


@property (weak, nonatomic) IBOutlet UILabel *detailCollectLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailSharebutton;
@property (weak, nonatomic) IBOutlet UIButton *detailImAnswerButton;
@property (weak, nonatomic) IBOutlet UIButton *detailThrumClick;

@end
