//
//  BaseWebViewController.h
//  BS
//
//  Created by 蔡卓越 on 16/4/26.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseWebViewController : BaseViewController

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic , assign) CGRect webViewFrame;

- (void)webViewRequestWithURL:(NSString *)url;

@end
