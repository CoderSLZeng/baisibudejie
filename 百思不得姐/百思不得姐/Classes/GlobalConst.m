//
//  GlobalConst.m
//  百思不得姐
//
//  Created by Anthony on 17/3/29.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 通用的间距值 */
CGFloat const SLMargin = 10;
/** 通用的小间距值 */
CGFloat const SLSmallMargin = SLMargin * 0.5;

/** 公共的URL */
NSString * const SLCommonURL = @"http://api.budejie.com/api/api_open.php";

/** SLUser - sex - male */
NSString * const SLUserSexMale = @"m";

/** SLUser - sex - female */
NSString * const SLUserSexFemale = @"f";

/*** 通知 ***/
/** TabBar按钮被重复点击的通知 */
NSString * const SLTabBarButtonDidRepeatClickNotification = @"SLTabBarButtonDidRepeatClickNotification";
/** 标题按钮被重复点击的通知 */
NSString * const SLTitleButtonDidRepeatClickNotification = @"SLTitleButtonDidRepeatClickNotification";