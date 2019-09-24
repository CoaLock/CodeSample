//
//  SearchViewController.m
//  YS_iOS
//
//  Created by 张阳 on 16/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDetailViewController.h"


#import "HistorySearchTableView.h"
#import "ZYSearchBar.h"

#import "TagModel.h"

#import "GetHistoryApi.h"
#import "GetHotKeywordsApi.h"
#import "EmptyHistotyApi.h"


@interface SearchViewController ()

/** 搜搜*/
@property (nonatomic , strong) ZYSearchBar *searchBar;

@property (nonatomic, strong) HistorySearchTableView *tableView;

@property (nonatomic, assign) NSInteger firstRow;


@property (nonatomic, strong) NSMutableArray *recordList;

@property (nonatomic, strong) NSMutableArray *hotList;



@end

@implementation SearchViewController



- (void)setupSearchBar {
    
    if (_searchBar == nil) {
        
        _searchBar = [ZYSearchBar searchBarWithFrame:CGRectMake(41, 42, kScreenWidth - 41 -12, 32)];
        _searchBar.textField.frame = CGRectMake(50, 5, kScreenWidth-41 -12 -20, 33);
        [self.navigationController.navigationBar addSubview:_searchBar];
        
    }
}

- (void)setupTableViewbottom {
    
    
    GrassWeakSelf;
    _tableView = [[HistorySearchTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped clearSearchBlock:^{
        
        [weakSelf clearHistory];
    }];
    
    _tableView.tagClickBlock = ^(NSString *tagText) {
        
        weakSelf.searchBar.text = tagText;

        SearchDetailViewController *searchDetailVC = [[SearchDetailViewController alloc] init];
        searchDetailVC.keyword = tagText;
        searchDetailVC.searchBar = weakSelf.searchBar;
        [weakSelf.navigationController pushViewController:searchDetailVC animated:YES];
    };
    [self.view addSubview:_tableView];
    
    

}

#pragma mark - Init
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _searchBar.hidden = NO;
    
    [self.navigationController.navigationBar addSubview:_searchBar];
    
    
    [self setupSearchBar];
    
    GrassWeakSelf;
    _searchBar.searchBlock = ^(NSString *text) {
        
        SearchDetailViewController *searchDetailVC = [[SearchDetailViewController alloc] init];
        searchDetailVC.keyword = text;
        searchDetailVC.searchBar = weakSelf.searchBar;
        [weakSelf.navigationController pushViewController:searchDetailVC animated:YES];
    };

    
    [self getSearchRecordList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.navigationController.childViewControllers.count == 1) {

        _searchBar.hidden = YES;
        
        [_searchBar removeFromSuperview];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupSearchBar];
    
    
    [self setupTableViewbottom];
    
    
    [self getHotKeywords];
    
   // [self getSearchRecordList];
}

#pragma mark - Private
- (void)getSearchRecordList {
    
    GetHistoryApi *getHistoryApi = [[GetHistoryApi alloc] init];
    [getHistoryApi getHistoryWithFirstRow:_firstRow fetchNum:30 callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            NSArray *kewords = PASS_NULL_TO_NIL(resultData[@"keyword_list"]);
            
            NSMutableArray *modelList = @[].mutableCopy;
            for (NSDictionary *tagDic in kewords) {
                
                TagModel *tagModel = [[TagModel alloc] init];
                tagModel.tagName = tagDic[@"keyword"];
                [modelList addObject:tagModel];
            }
            
            _recordList = modelList;
            
            if (_hotList.count == 0) {
                _hotList = @[].mutableCopy;
            }
            
            [_tableView reloadRecordList:_recordList hotList:_hotList];
        
        }
        else {
            
            if (_hotList.count == 0) {
                _hotList = @[].mutableCopy;
            }
            [_tableView reloadRecordList:@[].mutableCopy hotList:_hotList];
          //  [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)getHotKeywords {

    GetHotKeywordsApi *keywordsApi = [[GetHotKeywordsApi alloc] init];
    [keywordsApi getHotKeywordsWithCallback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            ARRAY_NIL_NULL(resultData);
            
            NSMutableArray *modelList = @[].mutableCopy;
            for (NSDictionary *tagDic in resultData) {
        
                TagModel *tagModel = [[TagModel alloc] init];
                tagModel.tagName = tagDic[@"title"];
                [modelList addObject:tagModel];
            }
            
            _hotList = modelList;
            
            if (_recordList.count == 0) {
                _recordList = @[].mutableCopy;
            }

            
            [_tableView reloadRecordList:_recordList hotList:_hotList];
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)clearHistory {

    EmptyHistotyApi *emptyHistoryApi = [[EmptyHistotyApi alloc] init];
    [emptyHistoryApi emptyHistoryWithCallback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            [self getSearchRecordList];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}





@end
