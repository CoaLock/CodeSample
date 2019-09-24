//
//  RecTagViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/29.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "RecTagViewController.h"
#import "DynamicLabel.h"


#import "GetTagListApi.h"
#import "TagModel.h"

#import "DoFollowApi.h"


@interface RecTagViewController ()

@property (nonatomic, strong) DynamicLabel *dynamicLabel;
@property (nonatomic, strong) UIScrollView *scrollView;



@property (nonatomic, strong) NSMutableArray *tagList;


@property (nonatomic, assign) NSInteger firstRow;


@end

@implementation RecTagViewController



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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth -128)/2, 10, 128, 25)];
    label.lk_attribute
    .text(@"选择你喜欢的标签")
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
    [_scrollView addSubview:_dynamicLabel];
    
    
    _dynamicLabel.tagChangeBlock  = ^(UIButton* button, NSInteger index) {
    
        
        [weakSelf doFollowTagWithIndex:index button:button];
    };
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"推荐标签"];

    
    [UIBarButtonItem addLeftItemWithImageName:@"ic_return_wihte" frame:CGRectMake(0, 0, 40, 20) vc:self action:@selector(returnAction)];
    // [UIBarButtonItem addRightItemWithTitle:@"完成" frame:CGRectMake(0, 0, 50, 20) vc:self action:@selector(saveAction)];
    

    [self getTagList];
}

#pragma mark - Private
- (void)getTagList {
    
    GetTagListApi *getTagListApi = [[GetTagListApi alloc] init];
    [getTagListApi getTagListWithCallback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            if ([PASS_NULL_TO_NIL(resultData) isKindOfClass:[NSArray class]]) {
                
                _tagList  = [TagModel mj_objectArrayWithKeyValuesArray:resultData];
                
                [self initScrollView];
            
            }
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)doFollowTagWithIndex:(NSInteger)index button:(UIButton*)button {

    TagModel *tagModel = _tagList[index];
    NSInteger tagId = [PASS_NULL_TO_NIL(tagModel.tagId) integerValue];
    
    DoFollowApi *doFollowApi = [[DoFollowApi alloc] init];
    [doFollowApi doFollowWithType:1 relationId:tagId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
         
            NSString *isFollow = resultData[@"is_follow"];
            tagModel.isFollow = [NSString stringWithFormat:@"%@", isFollow];
            
            
            button.selected = !button.selected;
            if (button.selected) {
                
                button.backgroundColor = kAppCustomMainColor;
                
                button.layer.borderWidth = 0;
            }
            else {
                
                button.backgroundColor = [UIColor clearColor];
                
                button.layer.borderWidth = 1;
                
            }

        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}



#pragma mark - Events
- (void)saveAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)returnAction {
    if (_returnBlock) {
        _returnBlock(_tagList.copy);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}





@end
