//
//  PersonMoneyViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonMoneyViewController.h"

@interface PersonMoneyViewController ()

@end

@implementation PersonMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我的金币"];
    
    
    [UIBarButtonItem addRightItemWithTitle:@"金币说明" frame:CGRectMake(0, 0, 80, 20) vc:self action:@selector(getCoinDesc)];
    
    
    NSString *style = PASS_NULL_TO_NIL([Singleton sharedManager].app_style) ? [Singleton sharedManager].app_style : @"";
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", kDomain, kWebUrlMyCoin, style];
    
    [self wkWebViewRequestWithURL:url];

}


- (void)getCoinDesc {

    BaseWKWebViewController *webviewVC = [[BaseWKWebViewController alloc] init];
    webviewVC.titleStr = @"金币说明";
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, kWebUrlCoinDescription];
    
    [webviewVC wkWebViewRequestWithURL:url];
    
    [self.navigationController pushViewController:webviewVC animated:YES];

}


/* 3.在收到服务器的响应头，根据response相关信息，决定是否跳转。 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {

    NSDictionary *headers = navigationAction.request.allHTTPHeaderFields;
    NSString *cookie = headers[@"Cookie"];
   
    NSLog(@"-----%@", cookie);

    decisionHandler(WKNavigationActionPolicyAllow);
}



@end
