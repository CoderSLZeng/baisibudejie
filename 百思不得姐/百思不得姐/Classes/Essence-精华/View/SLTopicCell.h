//
//  SLTopicCell.h
//  百思不得姐
//
//  Created by Anthony on 17/3/31.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLTopic;

@interface SLTopicCell : UITableViewCell
/** 帖子模型数据 */
@property (nonatomic, strong) SLTopic *topic;

@end
