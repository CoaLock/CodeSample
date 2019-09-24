//
//  MsgDetailViewController.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "MsgDetailViewController.h"

#import <WebKit/WebKit.h>


@interface MsgDetailViewController () <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>


@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}



#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSString *msgName = message.name;
    
    if ([msgName isEqualToString:@"webviewEvent"]) {
        

    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        self.navigationItem.titleView = [UILabel labelWithTitle:string];
    }];
}



@end
