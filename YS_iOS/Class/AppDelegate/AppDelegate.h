//
//  AppDelegate.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/10/31.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) CLLocationCoordinate2D myCoordinate;


@end

