//
//  FocusDetailCollectionView.h
//  YS_iOS
//
//  Created by 张阳 on 16/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseCollectionView.h"
#import "DetailTableHeaderView.h"




typedef void(^FocusDetailCellClick)(NSIndexPath* indexpath);

typedef void(^FocusDetailScrollBlock)(CGFloat offsetY, BOOL isHidden);



@class TopicModel;



@interface FocusDetailCollectionView : BaseCollectionView

@property (nonatomic , copy) FocusDetailScrollBlock scrollBlock;

@property (nonatomic , copy) FocusDetailCellClick focusDetailCellClick;


@property (nonatomic , copy) FocusDetailButtoBlock focusDetailButtoBlock;


@property (nonatomic, strong) TopicModel *topicModel;


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout detailCellClick:(FocusDetailCellClick)detailCellClick scrollBlock:(FocusDetailScrollBlock)scrollBlock;



- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout detailCellClick:(FocusDetailCellClick)detailCellClick;



@end
