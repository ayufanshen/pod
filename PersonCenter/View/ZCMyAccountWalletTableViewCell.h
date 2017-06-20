//
//  ZCMyAccountWalletTableViewCell.h
//  zuche
//
//  Created by yk on 2017/2/20.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MyWalletItemType_Balance = 100, // 账户余额
    MyWalletItemType_Coupon,        // 优惠券
    MyWalletItemType_Point,         // 积分
    MyWalletItemType_Credit,        // 信用卡
    MyWalletItemType_Card,          // 储值卡
    MyWalletItemType_RedImage       // 积分红点
} MyWalletItemType;         // 我的钱包数据类型

@protocol ZCWalletTableViewCellDelegate <NSObject>
- (void)gotoPageWithWalletType:(MyWalletItemType)type;

@end

@interface ZCMyAccountWalletTableViewCell : UITableViewCell

@property (assign,nonatomic) id<ZCWalletTableViewCellDelegate>delegate;
/**
 *  设置数据的方法
 *
 *  @param flag        数据类型
 *  @param score       数值的字符串
 *  @param unite       数值的单位
 *  @param description 该项的描述
 */
- (void)setDataWithFlag:(MyWalletItemType)flag withData:(NSString *)score withUnite:(NSString *)unite withDescription:(NSString *)description;


@end
