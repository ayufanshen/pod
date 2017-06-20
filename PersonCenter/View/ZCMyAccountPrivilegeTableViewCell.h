//
//  ZCMyAccountPrivilegeTableViewCell.h
//  zuche
//
//  Created by yk on 2017/3/7.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PrivilegeType_Member = 100  // 会员
} PrivilegeItemType;  // 特权数据类型

@protocol ZCPrivilegeTableViewCellDelegate <NSObject>
- (void)gotoPageWithPrivilegeType:(PrivilegeItemType)type;

@end

@interface ZCMyAccountPrivilegeTableViewCell : UITableViewCell

@property (assign,nonatomic) id<ZCPrivilegeTableViewCellDelegate>delegate;
/**
 *  设置数据的方法
 *
 *  @param flag        数据类型
 *  @param img         图片的字符串
 *  @param description 该项的描述
 */
- (void)setDataWithFlag:(PrivilegeItemType)flag withData:(NSString *)img withDescription:(NSString *)description;

@end
