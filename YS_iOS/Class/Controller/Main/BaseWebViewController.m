//
//  BaseWebViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/4/26.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseWebViewController.h"
#import "UserDefaultsUtil.h"

@interface BaseWebViewController ()<UIWebViewDelegate>

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (UIWebView *)webView {
    
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] initWithFrame:_webViewFrame];
        
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)webViewRequestWithURL:(NSString *)url {
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *phpSession = [UserDefaultsUtil getUsetDefaultCookie];
    
    NSString *cookieString = [NSString stringWithFormat:@"%@=%@",@"PHPSESSID",phpSession];
    
    [urlRequest setValue:cookieString forHTTPHeaderField:@"Cookie"];

    
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

//    [self showIndicatorOnWindowWithMessage:@"玩命加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

//    [self hideIndicatorOnWindow];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                                     "script.type = 'text/javascript';"
                                                     "script.text = \"function ResizeImages() { "
                                                     "var myimg,oldwidth;"
                                                     "var maxwidth=%f;"
                                                     "for(i=0;i <document.images.length;i++){"
                                                     "myimg = document.images[i];"
                                                     "if(myimg.clientWidth > maxwidth-20){"
                                                     "oldwidth = myimg.width;"
                                                     "myimg.style.width = maxwidth-20;"
                                                     "myimg.style.height = 'auto';"
                                                     
                                                     "}"
                                                     "}"
                                                     "var firstEle = document.body.firstChild;"
                                                     
                                                     "firstEle.style.marginTop = 0 + 'px';"
                                                     "}\";"
                                                     "document.getElementsByTagName('head')[0].appendChild(script);", kScreenWidth]];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];




}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

//    [self hideIndicatorOnWindow];
}



@end
