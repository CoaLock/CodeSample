//
//  BaseWKWebViewController.h
//  ArtInteract
//
//  Created by 蔡卓越 on 16/9/26.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWKWebViewController : BaseViewController

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic , assign) CGRect webViewFrame;

@property (nonatomic, copy) NSString *titleStr;

- (void)wkWebViewRequestWithURL:(NSString *)url;

@end
