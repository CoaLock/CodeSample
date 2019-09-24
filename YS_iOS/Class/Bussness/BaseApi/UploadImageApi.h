//
//  UploadImageApi.h
//  ZhiYou
//
//  Created by 崔露凯 on 15/11/24.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface UploadImageApi : BaseApi

//上传图片 （图片）
- (void)uploadImageWithData:(NSData*)imageData dir:(NSString*)dir callback:(ApiRequestCallBack)callback;


@end
