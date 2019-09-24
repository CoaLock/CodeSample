//
//  AddTagViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AddTagViewController.h"
#import "DynamicLabel.h"

#import "GetTagListApi.h"
#import "TagModel.h"

#import "DoFollowApi.h"


#import "GetTagListApi.h"
#import "TagModel.h"


@interface AddTagViewController ()

@property (nonatomic, strong) DynamicLabel *dynamicLabel;
@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic, strong) NSMutableArray *tagList;


@property (nonatomic, assign) NSInteger firstRow;



@end

@implementation AddTagViewController


#pragma mark- Initialization
- (void)initScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-64);
    [self.view addSubview:_scrollView];
    
    
    UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake(86, 22, kScreenWidth - 86*2, 1)];
    lineH.lk_attribute
    .backgroundColor(kSeperateLineColor)
    .superView(_scrollView);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth -131)/2, 10, 131, 25)];
    label.lk_attribute
    .text(@"选择文章相符的标签")
    .font(14)
    .textColor(kTextThirdLevelColor)
    .backgroundColor([UIColor whiteColor])
    .textAlignment(NSTextAlignmentCenter)
    .superView(_scrollView);
    
    UIView *lineH2 = [[UIView alloc] initWithFrame:CGRectMake(12, 45, kScreenWidth - 12*2, 1)];
    lineH2.lk_attribute
    .backgroundColor(kTextThirdLevelColor)
    .superView(_scrollView);
    
    
    GrassWeakSelf;
    _dynamicLabel = [[DynamicLabel alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight) titleNames:_tagList needSelected:YES heightChangeBlock:^(CGFloat height) {
        
        height = height +45 > kScreenHeight -64? height +45 : kScreenHeight -64;
        weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, height) ;
        
    }];
    
    _dynamicLabel.limitTipBlock = ^() {
    
        [weakSelf showErrorMsg:@"最多添加3个标签"];
    };
    
    _dynamicLabel.limitedNum = 3;
    [_scrollView addSubview:_dynamicLabel];
    
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"文章标签"];
    
    [UIBarButtonItem addRightItemWithTitle:@"确定" frame:CGRectMake(0, 0, 50, 20) vc:self action:@selector(saveAction)];

    
    [self getTagList];
    
}

#pragma mark - Private
- (void)getTagList {
    
    GetTagListApi *getTagListApi = [[GetTagListApi alloc] init];
    [getTagListApi getTagListWithCallback:^(id resultData, NSInteger code) {
        if (code == 0) {
         
            if ([PASS_NULL_TO_NIL(resultData) isKindOfClass:[NSArray class]]) {
                
               _tagList  = [TagModel mj_objectArrayWithKeyValuesArray:resultData];
                
                for (TagModel *tagModel in _tagList) {
                    
                    tagModel.isFollow = @"0";
                }
                
                
                [self initScrollView];
            }
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - Events
- (void)saveAction {
    
    if (_sureBlock) {
        
        NSMutableArray *tagList = @[].mutableCopy;
        
        NSMutableArray *tagNames = @[].mutableCopy;
        NSMutableArray *tagIds =@[].mutableCopy;

        for (TagModel *tagModel in _tagList) {
            if ([PASS_NULL_TO_NIL(tagModel.isFollow) integerValue] == 1) {
            
                [tagList addObject:tagModel];
                
                [tagNames addObject:tagModel.tagName];
                [tagIds addObject:tagModel.tagId];
            }
        }
        
        if (tagList.count == 0) {
            
            [self showErrorMsg:@"请至少选择一个标签"];
            return;
        }
        

        NSString *tagIdStr = [tagIds componentsJoinedByString:@","];
        NSString *tagNameStr = [tagNames componentsJoinedByString:@"、"];
        
       _sureBlock(tagList, tagIdStr, tagNameStr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}




@end
