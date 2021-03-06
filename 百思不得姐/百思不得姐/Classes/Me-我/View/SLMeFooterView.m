//
//  SLMeFooterView.m
//  百思不得姐
//
//  Created by Anthony on 17/3/29.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

#import "SLMeFooterView.h"
#import "SLMeSquare.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "SLMeSquareButton.h"
#import "SLWebViewController.h"
#import <SafariServices/SafariServices.h>

@interface SLMeFooterView()
@end

@implementation SLMeFooterView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        
        @SLWeakObj(self)
        // 请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          @SLStrongObj(self)
            // 字典数组 -> 模型数组
            NSArray *squares = [SLMeSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            // 根据模型数据创建对应的控件
            [self createSquares:squares];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            SLLog(@"请求失败 - %@", error);
        }];
    }
    return self;
}

/**
 *  根据模型数据创建对应的控件
 */
- (void)createSquares:(NSArray *)squares
{
    // 方块个数
    NSUInteger count = squares.count;
    
    // 方块的尺寸
    NSUInteger maxColsCount = 4; // 一行的最大列数
    CGFloat buttonW = self.sl_width / maxColsCount;
    CGFloat buttonH = buttonW;
    
    // 创建所有的方块
    for (NSUInteger i = 0; i < count; i++) {
        if (![squares[i] isMemberOfClass:[SLMeSquare class]]) continue;
        // 创建按钮
        SLMeSquareButton *button = [SLMeSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // 设置frame
        button.sl_x = (i % maxColsCount) * buttonW;
        button.sl_y = (i / maxColsCount) * buttonH;
        button.sl_width = buttonW;
        button.sl_height = buttonH;
        
        // 设置数据
        button.square = squares[i];
    }
    
    // 设置footer的高度 == 最后一个按钮的bottom(最大Y值)
    self.sl_height = self.subviews.lastObject.sl_bottom;

    // 设置tableView的contentSize
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
    [tableView reloadData]; // 重新刷新数据(会重新计算contentSize)
    
    // 总数 : 1660
    // 每一行最多显示的数量 : 30
    // 总行数 : (1660 + 30 - 1) / 30
//        NSUInteger rowsCount = 0;
//        if (count % maxColsCount == 0) { // 能整除
//            rowsCount = count / maxColsCount;
//        } else { // 不能整除
//            rowsCount = count / maxColsCount + 1;
//        }
//
//        NSUInteger rowsCount = count / maxColsCount;
//        if (count % maxColsCount) { // 不能整除
//            rowsCount += 1;
//        }
    
    // 总数 : 2476
    // 每页显示的最大数量 : 35
    // 总页数 :  (2476 + 35 - 1) / 35
    // pagesCount = (总数  +  每页显示的最大数量 - 1) / 每页显示的最大数量
    
//    NSUInteger rowsCount = (count + maxColsCount - 1) / maxColsCount;
//    self.sl_height = rowsCount * buttonH;
}

#pragma mark - 监听
- (void)buttonClick:(SLMeSquareButton *)button
{
    
    NSString *url = button.square.url;
    
    if ([url hasPrefix:@"http"]) { // 利用webView加载url即可
        // 使用SFSafariViewController显示网页
        //        SFSafariViewController *webView = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        //        UITabBarController *tabBarVc = (UITabBarController *)self.window.rootViewController;
        //        [tabBarVc presentViewController:webView animated:YES completion:nil];
        
        
        // 获得"我"模块对应的导航控制器
        //        UITabBarController *tabBarVc = [UIApplication sharedApplication].keyWindow.rootViewController;
        //        UINavigationController *nav = tabBarVc.childViewControllers.firstObject;
        UITabBarController *tabBarVc = (UITabBarController *)self.window.rootViewController;
        UINavigationController *nav = tabBarVc.selectedViewController;
        
        // 显示SLWebViewController
        SLWebViewController *webView = [[SLWebViewController alloc] init];
        webView.url = url;
        webView.navigationItem.title = button.currentTitle;
        [nav pushViewController:webView animated:YES];
    } else if ([url hasPrefix:@"mod"]) { // 另行处理
        if ([url hasSuffix:@"BDJ_To_Check"]) {
            SLLog(@"跳转到[审帖]界面");
        } else if ([url hasSuffix:@"BDJ_To_RecentHot"]) {
            SLLog(@"跳转到[每日排行]界面");
        } else {
            SLLog(@"跳转到其他界面");
        }
    } else {
        SLLog(@"不是http或者mod协议的");
    }
    
    
}

@end
