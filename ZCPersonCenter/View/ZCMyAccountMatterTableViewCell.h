//
//  ZCMyAccountMatterTableViewCell.h
//  zuche
//
//  Created by yk on 2017/2/21.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCMyAccountItemBtn.h"

typedef enum
{
    MatterItemType_Illegal = 100,   // 违章处理
    MatterItemType_WaitPay,         // 待支付项
} MatterItemType;  // 待办事项数据类型

@protocol ZCMatterTableViewCellDelegate <NSObject>
- (void)gotoPageWithMatterType:(MatterItemType)type;

@end

@interface ZCMyAccountMatterTableViewCell : UITableViewCell

@property (assign,nonatomic) id<ZCMatterTableViewCellDelegate>delegate;
/**
 *  设置数据的方法
 *
 *  @param flag        数据类型
 *  @param score       数值的字符串
 *  @param description 该项的描述
 */
- (void)setDataWithFlag:(MatterItemType)flag withData:(NSString *)score withDescription:(NSString *)description;

@end
