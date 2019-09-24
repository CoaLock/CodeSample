//
//  SearchDetailViewController.h
//  YS_iOS
//
//  Created by 张阳 on 16/11/29.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"

#import "ZYSearchBar.h"


@interface SearchDetailViewController : BaseViewController



@property (nonatomic , strong) ZYSearchBar *searchBar;


@property (nonatomic, strong) NSString *keyword;


@end
