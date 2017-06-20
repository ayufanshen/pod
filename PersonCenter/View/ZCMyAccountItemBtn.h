//
//  ZCMyAccountItemBtn.h
//  zuche
//
//  Created by yk on 2017/2/22.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCMyAccountItemBtn : UIButton

@property (nonatomic, strong) UILabel *titleLbl;

- (void)buttonWithMoneyStr:(NSString *)moneyStr unitStr:(NSString *)unitStr titleStr:(NSString *)titleStr;
- (void)buttonWithStatusStr:(NSString *)statusStr titleStr:(NSString *)titleStr;
- (void)buttonWithNumberStr:(NSString *)numberStr titleStr:(NSString *)titleStr;
- (void)buttonWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr;

@end
