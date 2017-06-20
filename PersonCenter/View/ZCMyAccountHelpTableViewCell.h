//
//  ZCMyAccountHelpTableViewCell.h
//  zuche
//
//  Created by yk on 2017/2/21.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    HelpItemType_Course = 100, // 新手指导
    HelpItemType_Rule,         // 服务规则
    HelpItemType_Problem,      // 常见问题
    HelpItemType_Feedbk        // 意见反馈
} HelpItemType;  // 帮助反馈数据类型

@protocol ZCHelpTableViewCellDelegate <NSObject>
- (void)gotoPageWithHelpType:(HelpItemType)type;

@end

@interface ZCMyAccountHelpTableViewCell : UITableViewCell

@property (assign,nonatomic) id<ZCHelpTableViewCellDelegate>delegate;
/**
 *  设置数据的方法
 *
 *  @param flag        数据类型
 *  @param img         图片的字符串
 *  @param description 该项的描述
 */
- (void)setDataWithFlag:(HelpItemType)flag withData:(NSString *)img withDescription:(NSString *)description;

@end
