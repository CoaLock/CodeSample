//
//  PersonFocusTagController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonFocusTagController.h"

#import "RecTagViewController.h"

#import "DynamicLabel.h"

#import "GetFollowListApi.h"


#import "DoFollowApi.h"

#import "TagModel.h"


#define kTopTitleHeight 90


@interface PersonFocusTagController () <UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) DynamicLabel *dynamicLabel;

@property (nonatomic, strong) NSArray *tagNames;

@property (nonatomic, assign) NSInteger firstRow;

@property (nonatomic, strong) TagListModel *tagListModel;

@property (nonatomic, strong) NSMutableArray *tagList;


@end

@implementation PersonFocusTagController


#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 44+45, kScreenWidth, kScreenHeight - 44 -45-64) img:@"ic_attent_lable" title:@"您还没有关注任何标签哦" bgColor:kBackgroundColor];
        self.blankView.bindedView = _dynamicLabel;
        [self.view addSubview:self.blankView];
        
        self.blankView = blankView;
    }
    
    return self.blankView;
}


- (void)initScrollView {

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 53, kScreenWidth, kScreenHeight - 64- 53)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 10, 70, 22);
    btn.lk_attribute
    .normalTitle(@"修改标签")
    .font(16)
    .event(self, @selector(addTag))
    .normalTitleColor(kTextFirstLevelColor)
    .superView(_scrollView);
    
    btn.topEdge(10).bottomEdge(10).rightEdge(kScreenWidth -70);
    
    
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowBtn.frame = CGRectMake(kScreenWidth - 12 -9, 14, 9, 16);
    arrowBtn.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_return_right_gray"])
    .superView(_scrollView);
    
    UIView *lineTagH1 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 10)];
    lineTagH1.backgroundColor = kBackgroundColor;
    [_scrollView addSubview:lineTagH1];
    
    UILabel *tagTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, lineTagH1.bottom + 10, 120, 22)];
    tagTitle.lk_attribute
    .font(16)
    .text(@"我关注的标签")
    .textColor(kTextSecondLevelColor)
    .superView(_scrollView);
    
//    UIView *lineTagH2 = [[UIView alloc] initWithFrame:CGRectMake(12, 44+45, kScreenWidth - 12*2, 1)];
//    lineTagH2.backgroundColor = kSeperateLineColor;
//    [_scrollView addSubview:lineTagH2];

}

- (void)initDynamicLabel {

    GrassWeakSelf;
    [_dynamicLabel removeFromSuperview];
    _dynamicLabel = nil;
    
    _dynamicLabel = [[DynamicLabel alloc] initWithFrame:CGRectMake(0, kTopTitleHeight, kScreenWidth, 2) titleNames:_tagList needSelected:YES heightChangeBlock:^(CGFloat height) {
        
        height = height +kTopTitleHeight > kScreenHeight -64 - 53? height +kTopTitleHeight : kScreenHeight -64-53;
        weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, height) ;

    }];
    
    _dynamicLabel.tagChangeBlock = ^(UIButton *button, NSInteger index) {
    
        [weakSelf doFollowTagWithIndex:index button:button];        
    };
    
    _dynamicLabel.userInteractionEnabled = NO;
    
    [_scrollView addSubview:_dynamicLabel];

}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];


    _tagNames = @[];
    
    [self initScrollView];
    
    
    [self getFollowList];
    
        
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


#pragma mark - Private
- (void)startLoadData {

    [self getFollowList];
}


- (void)getFollowList {

    GetFollowListApi *getFollowListApi = [[GetFollowListApi alloc] init];
    [getFollowListApi getFollowListWithType:1 firstRow:_firstRow fetchNum:100 callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            _tagListModel = [TagListModel mj_objectWithKeyValues:resultData];
            
            for (TagModel *tagModel in _tagListModel.followList) {
                
                tagModel.isFollow = @"1";
            }
            
            _tagList = _tagListModel.followList;
            
            // 显示tableView
            self.blankView.bindedView = _dynamicLabel;
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            [[self createBlankView] shouldShow:(_tagListModel.followList.count==0)];
            
            if (_tagListModel.followList.count > 0) {
                [self initDynamicLabel];
            }
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
    
}


#pragma mark - Events
- (void)addTag {

    RecTagViewController *addTag = [[RecTagViewController alloc] init];
    [self.navigationController pushViewController:addTag animated:YES];
    
    addTag.returnBlock = ^(NSMutableArray *tagList) {
    
        [self getFollowList];
    };
}






@end
