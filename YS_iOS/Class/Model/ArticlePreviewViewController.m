//
//  ArticlePreviewViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ArticlePreviewViewController.h"
#import <WebKit/WebKit.h>

#import "ReleaseArticleApi.h"
#import "SaveArticleaPI.h"

#import "PublishPerformViewController.h"

#import "UIButton+SetImageWithURL.h"

#import "BaseTableView.h"
#import "PreviewTop.h"

#import "UserInfoApi.h"
#import "UserModel.h"


@interface ArticlePreviewViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UITableViewDelegate, UITableViewDataSource>




@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong) PreviewTop *tableHeader;



@end

@implementation ArticlePreviewViewController



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
   // [self.view addSubview:_webView];
    
    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, _htmlStr];
    
    [_webView loadHTMLString:html baseURL:nil];
    
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

    _tableHeader.titleLabel.text = _articleTitle;
    
    NSString *timeStr = [NSString stringFromDate:[NSDate date] formatter:@"yyyy-MM-dd"];
    
    _tableHeader.descLabel.text = [NSString stringWithFormat:@"%@   %@", timeStr, _tagStr];
    
    
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"文章预览"];

    
    [UIBarButtonItem addRightItemWithTitle:@"发布" frame:CGRectMake(0, 0, 50, 20) vc:self action:@selector(releaseArticle:)];
    
    [self initTableView];
    
    [self initHeader];
    
    
    [self initWebview];

    [self getUserInfo];
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


#pragma mark - Setters
- (void)setHtmlStr:(NSString *)htmlStr {
    
    _htmlStr = htmlStr;
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

    _articleId = (_articleId >0 ) ? _articleId : -1;
    SaveArticleaPI *saveArticleApi = [[SaveArticleaPI alloc] init];
    [saveArticleApi saveArticleWithArticleId:_articleId title:_articleTitle tagList:_tagList textList:_textList callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            NSInteger articleId = [PASS_NULL_TO_NIL(resultData) integerValue];
            if (articleId > 0) {
                [self releaseAricleWithArticleId:articleId];
            }
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)releaseAricleWithArticleId:(NSInteger)articleId {

    [self showIndicatorOnWindowWithMessage:@"发布中..."];
    ReleaseArticleApi *releaseApi = [[ReleaseArticleApi alloc] init];
    [releaseApi releaseArticleWithArticleId:articleId callback:^(id resultData, NSInteger code) {
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
        
//        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.height.mas_equalTo(height);
//        }];
        
        
//        if (_loadEndBlock) {
//            
//            _loadEndBlock(height);
//        }
    }];

}








@end
