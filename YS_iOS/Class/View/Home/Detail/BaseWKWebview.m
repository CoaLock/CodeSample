//
//  BaseWKWebview.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/15.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseWKWebview.h"


@interface BaseWKWebview ()  <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webview;


@end


@implementation BaseWKWebview


- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    
    WKUserContentController *userCC = [[WKUserContentController alloc] init];
    
    // [userCC addScriptMessageHandler:self name:@"webviewEvent"];
    
    [userCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.userContentController = userCC;
    
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20) configuration:config];
    
    _webview.UIDelegate = self;
    _webview.navigationDelegate = self;
    
    [self addSubview:_webview];

    
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    

}


- (void)setHtmlStr:(NSString *)htmlStr {

    _htmlStr = htmlStr;
    
    
    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, _htmlStr];
    
    [_webview loadHTMLString:_htmlStr baseURL:nil];
}



#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    //[self showIndicatorOnWindowWithMessage:@"加载中"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
   // [self hideIndicatorOnWindow];
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        CGFloat height = [string floatValue];
        
        [_webview mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(height);
        }];
        
        
        if (_loadEndBlock) {
            
            _loadEndBlock(height);
        }
    }];
}






@end
