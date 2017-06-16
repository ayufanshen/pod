//
//  ZCMyAccountViewModel.h
//  zuche
//
//  Created by 饭小团 on 2017/6/8.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCMyAccountModel.h"
#import "PeccancyModel.h"

@interface ZCMyAccountViewModel : NSObject

@property (strong, nonatomic,readonly) ZCMyAccountModel     * myAccount;
@property (strong, nonatomic,readonly) PeccancyModel         * peccancyModel;

@property (strong, nonatomic,readonly) NSString     * scoreUrlStr;
@property (strong, nonatomic,readonly) NSString     * couponUrlStr;
@property (assign, nonatomic,readonly) BOOL           isNewUser;
@property (strong, nonatomic,readonly) NSString     * memberLevelURLStr;

@property (strong, nonatomic,readonly) NSString     * name;
@property (strong, nonatomic,readonly) NSString     * userImageName;
@property (strong, nonatomic,readonly) NSString     * memberLevelStr;
@property (strong, nonatomic,readonly) NSString     * balanceAmount;

// 银行卡
@property (strong, nonatomic,readonly) NSString     * cardCount;
@property (strong, nonatomic,readonly) NSMutableArray        * cellTitleArray;
@property (strong, nonatomic,readonly) NSMutableArray        * cellSubTitleArray;
@property (strong, nonatomic) NSDictionary          * resultDict;


- (void)initUserInfo;
- (void)setCellTextLabel:(UILabel *)textLabel withString:(NSString *)desc;

-(void)setLatestPeccancyDate;
-(void)updateLatestPeccancyDate;

-(void)initMyAccountResult:(NSDictionary *)resultDict;
-(void)initPeccancyModel:(NSDictionary *)resultDict;

-(void)clearMyAccount;

@end
