//
//  PersonHelpCenterViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonHelpCenterViewController.h"



@interface PersonHelpCenterViewController ()

@end




@implementation PersonHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"帮助中心"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, kWebUrlHelpList];
    
    [self wkWebViewRequestWithURL:url];
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    
    NSString *msgName = message.name;
    
    if ([msgName isEqualToString:@"webviewEvent"]) {
        
        [self handleWebViewEvent:message];
    }
    
}

- (void)handleWebViewEvent:(WKScriptMessage*)message {
    
    NSString *bodyStr = message.body;
    
    NSDictionary *messageBody = [NSString deserializeMessageJSON:bodyStr];
    
    NSString *event = messageBody[@"event"];
    
    if ([event isEqualToString:@"view_help_detail"]) {
        
        NSDictionary *params = PASS_NULL_TO_NIL(messageBody[@"params"]);
        NSString *helpId = params[@"help_id"];
        
        BaseWKWebViewController *webviewVC = [[BaseWKWebViewController alloc] init];
        webviewVC.titleStr = @"帮助详情";
        NSString *url = [NSString stringWithFormat:@"%@%@%@", kDomain, kWebUrlHelpDetail, helpId];
        [webviewVC wkWebViewRequestWithURL:url];
        
        [self.navigationController pushViewController:webviewVC animated:YES];
     
    }
  
}


@end
