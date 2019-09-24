//
//  UserArticleDetailController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UserArticleDetailController.h"

#import <WebKit/WebKit.h>

#import "ReleaseArticleApi.h"
#import "SaveArticleaPI.h"

#import "PublishPerformViewController.h"

#import "UIButton+SetImageWithURL.h"

#import "BaseTableView.h"
#import "PreviewTop.h"

#import "UserInfoApi.h"
#import "UserModel.h"


#import "UserArticleDetailApi.h"
#import "GArticleModel.h"

#import "GetPreviewDetailApi.h"


@interface UserArticleDetailController ()  <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong) PreviewTop *tableHeader;


@property (nonatomic, strong) GArticleModel *articleModel;



@end

@implementation UserArticleDetailController




#pragma mark - Init
- (void)initWebview {
    
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    
    WKUserContentController *userCC = [[WKUserContentController alloc] init];
    
    // [userCC addScriptMessageHandler:self name:@"webviewEvent"];
    
    [userCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.userContentController = userCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64 -160) configuration:config];
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    _tableView.tableFooterView = _webView;
    
}

- (void)initTableView {
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)initHeader {
    
    _tableHeader = [[NSBundle mainBundle] loadNibNamed:@"PreviewTop" owner:nil options:nil].lastObject;
    _tableHeader.frame = CGRectMake(0, 0, kScreenWidth, 160);
    _tableView.tableHeaderView = _tableHeader;
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
    
    [self initHeader];
    
    
    [self initWebview];
    
    [self getUserInfo];
    
    [self getUserArticleDetail];
}


#pragma mark - Private
- (void)getUserInfo {
    
    UserInfoApi *userInfoApi = [[UserInfoApi alloc] init];
    [userInfoApi getUserInfoWithFields:@"headimgurl,nickname" callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            UserModel *userModel = [UserModel mj_objectWithKeyValues:resultData];
            
            [_tableHeader.headIcon setYSImageWithURL:userModel.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
            _tableHeader.nickName.text = userModel.nickname;
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)getUserArticleDetail {

    UserArticleDetailApi *detailApi = [[UserArticleDetailApi alloc] init];
    [detailApi getArticleDetailWithArticleId:_articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            DICTIONARY_NIL_NULL(resultData);
            _articleModel = [GArticleModel mj_objectWithKeyValues:resultData];
            
            [self reloadData:_articleModel];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)reloadData:(GArticleModel*)articleModel {

    NSInteger status = [PASS_NULL_TO_NIL(articleModel.status) integerValue];
    BOOL shouldRelease = (status==0 );// || (status == 3);
    if (shouldRelease) {
        
        [UIBarButtonItem addRightItemWithTitle:@"发布" frame:CGRectMake(0, 0, 50, 20) vc:self action:@selector(releaseArticle:)];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    }
    
    _tableHeader.titleLabel.text = articleModel.title;

    NSString *timeStr = [NSString stringFromDate:[NSDate date] formatter:@"yyyy-MM-dd"];


    NSMutableArray *tagNames = @[].mutableCopy;
    for (TagModel *tagModel in _articleModel.tagList) {
        
        [tagNames addObject:tagModel.tagName];
    }
    
    _tableHeader.descLabel.text = [NSString stringWithFormat:@"%@   %@", timeStr, [tagNames componentsJoinedByString:@" · "]];
    
    [self preViewArticle];
}


- (void)preViewArticle {
 
    GetPreviewDetailApi *previewApi = [[GetPreviewDetailApi alloc] init];
    
    NSString *jsonStr = [NSString serializeMessage:_articleModel.textList];
    [previewApi getPreviewDetailWithTextList:jsonStr callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
           // NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, resultData];
        
            [_webView loadHTMLString:resultData baseURL:nil];
            
        }
        else {
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

#pragma mark - Events
- (void)releaseArticle:(UIButton*)button {

    [self showIndicatorOnWindowWithMessage:@"发布中..."];
    ReleaseArticleApi *releaseApi = [[ReleaseArticleApi alloc] init];
    [releaseApi releaseArticleWithArticleId:_articleId callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        if (code == 0) {
            
            PublishPerformViewController *publishPerformVC = [[PublishPerformViewController alloc] init];
            [self.navigationController pushViewController:publishPerformVC animated:YES];
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    [self showIndicatorOnWindowWithMessage:@"加载中"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    [self hideIndicatorOnWindow];
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        CGFloat height = [string floatValue];
        
        webView.height = height;
        
        _tableView.tableFooterView = webView;
        
    }];
    
}




@end
