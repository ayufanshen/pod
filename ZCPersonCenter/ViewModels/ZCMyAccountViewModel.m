//
//  ZCMyAccountViewModel.m
//  zuche
//
//  Created by 饭小团 on 2017/6/8.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import "ZCMyAccountViewModel.h"
#import "ZCUserInfo.h"
#import "ZCPushService.h"

#import "NSString+ThreeDES.h"
#import "NSString+URLEncode.h"
#import "NSDictionary+Accessors.h"
#import "NSObject+ZCUtility.h"
#import "UIColor+HexString.h"


@interface ZCMyAccountViewModel(){
    NSMutableArray *cellTitleArray_,*cellSubTitleArray_;
}

@end

@implementation ZCMyAccountViewModel

-(void)initMyAccountResult:(NSDictionary *)resultDict{
    
    
    _myAccount = [[ZCMyAccountModel alloc] initWithDictionary:resultDict error:nil];
    

//    NSLog(@"%@",myAccount);
}

-(void)initPeccancyModel:(NSDictionary *)resultDict{
    
    _peccancyModel = [[PeccancyModel alloc] initWithDictionary:resultDict error:nil];
    
}


-(void)clearMyAccount{
    _myAccount = nil;
}


- (void)setCellTextLabel:(UILabel *)textLabel withString:(NSString *)desc
{
    if (desc == nil || desc.length == 0) {
        return;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:desc];
    NSRange range = [desc rangeOfString:@"("];
    if (range.location == NSNotFound) {
        textLabel.text = desc;
        return;
    }
    
    [str addAttribute:NSForegroundColorAttributeName
                value:[UIColor colorWithHexString:@"626262"]
                range:NSMakeRange(0,range.location)];
    [str addAttribute:NSForegroundColorAttributeName
                value:[UIColor colorWithHexString:@"929292"]
                range:NSMakeRange(range.location,desc.length - range.location)];
    
    textLabel.attributedText = str;
}

-(NSString *)scoreUrlStr{
    
    NSString *scoreDetail = _myAccount.scoreDetailUrl;
    
    NSString    *mobile = [[ZCUserInfo sharedZCUserInfo] telephone];
    NSTimeInterval ts   = [[NSDate date] timeIntervalSince1970];
    NSString    *params = [NSString stringWithFormat:@"{\"origin\":\"ios\",\"mobile\":\"%@\",\"ts\":\"%f\"}",mobile,ts];
    //加密
    NSString    *encryptionStr = [NSString TripleDES:params encryptOrDecrypt:kCCEncrypt key:k3DES_KEY];
    //urlencode加密
    encryptionStr = [encryptionStr URLEncode];
    NSString *urlStr = [NSString stringWithFormat:@"%@?q=%@", scoreDetail, encryptionStr];
    
    return urlStr;
}

-(NSString *)couponUrlStr{
    
    //跳转到优惠券的详情页面
    NSString *couponList = _myAccount.couponListUrl;
    
    NSString  *mobile = [[ZCUserInfo sharedZCUserInfo] telephone];
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString  *params = [NSString stringWithFormat:@"{\"origin\":\"ios\",\"mobile\":\"%@\",\"ts\":\"%.0f\"}",mobile,ts];
    //加密
    NSString *encryptionStr = [NSString TripleDES:params encryptOrDecrypt:kCCEncrypt key:k3DES_KEY];
    //urlencode加密
    encryptionStr    = [encryptionStr URLEncode];
    NSString *urlStr = [NSString stringWithFormat:@"%@?q=%@", couponList, encryptionStr];
    return urlStr;
}

- (void)initUserInfo
{

    BOOL isRelatedCreditcard    = NO;
    BOOL requireCompletion      = NO;
    
    if (_myAccount.isRelatedCreditcard) {
        isRelatedCreditcard = YES;
    }
    if (_myAccount.requireCompletion) {
        requireCompletion = YES;
    }
    
    [[ZCUserInfo sharedZCUserInfo] setIsRelatedCreditcard:isRelatedCreditcard];
    [[ZCUserInfo sharedZCUserInfo] setName:_myAccount.name];
    [[ZCUserInfo sharedZCUserInfo] setEmail:_myAccount.email];
    [[ZCUserInfo sharedZCUserInfo] setIdType:_myAccount.idType];
    [[ZCUserInfo sharedZCUserInfo] setIdTypeName:_myAccount.idTypeName];
    [[ZCUserInfo sharedZCUserInfo] setIdNo:_myAccount.idNo];
    [[ZCUserInfo sharedZCUserInfo] setIdCarPicFront:_myAccount.idCarPicFront];
    [[ZCUserInfo sharedZCUserInfo] setIdCarPicBack:_myAccount.idCarPicBack];
    [[ZCUserInfo sharedZCUserInfo] setDriverPic:_myAccount.driverPic];
    [[ZCUserInfo sharedZCUserInfo] setTelephone:_myAccount.nativePhone];
    [[ZCUserInfo sharedZCUserInfo] setCredictCardTipsString:_myAccount.bindCardPrompt];
    // 保存用户是否需要补全信息的界面逻辑
    [[ZCUserInfo sharedZCUserInfo]setIsRequireCompletion:requireCompletion];
    
}

-(BOOL)isNewUser{
    return [[ZCPushService sharedZCPushService] checkIsNewUser];
}

-(NSString *)memberLevelURLStr{
    NSString    *userDetail = _myAccount.userDetailUrl;
    NSInteger   groupId     = _myAccount.groupId;
    NSString    *mobile     = [[ZCUserInfo sharedZCUserInfo] telephone];
    NSTimeInterval ts       = [[NSDate date] timeIntervalSince1970];
    NSString    *params     = [NSString stringWithFormat:@"{\"origin\":\"ios\",\"mobile\":\"%@\",\"ts\":\"%f\"}",mobile,ts];
    
    if (_myAccount.level == LevelPudong) {
        params = [NSString stringWithFormat:@"{\"origin\":\"ios\",\"mobile\":\"%@\",\"ts\":\"%f\",\"groupId\":\"%zd\"}",mobile,ts,groupId];
    }
    //加密
    NSString    *encryptionStr = [NSString TripleDES:params encryptOrDecrypt:kCCEncrypt key:k3DES_KEY];
    //urlencode加密
    encryptionStr = [encryptionStr URLEncode];
    NSString *memberUrlStr = [NSString stringWithFormat:@"%@?q=%@", userDetail, encryptionStr];
    
    return memberUrlStr;
}


-(NSMutableArray *)cellTitleArray{
    
    if (cellTitleArray_.count > 0) {
        return cellTitleArray_;
    }
    
    NSArray *section1Title = @[@""];
    NSArray *section2Title = @[@""];
    NSArray *section3Title = @[@""];
    NSArray *section4Title = @[@"发票管理"];
    NSArray *section5Title = @[@"关于神州"];
    NSArray *section6Title = @[@"客服电话"];
    cellTitleArray_ = [NSMutableArray arrayWithArray:@[section1Title,section2Title,section3Title,section4Title,section5Title,section6Title]];
    
    return cellTitleArray_;
}

-(NSMutableArray *)cellSubTitleArray{
    
    if (cellSubTitleArray_.count > 0) {
        return cellSubTitleArray_;
    }

    NSArray *section1SubTitle = @[@""];
    NSArray *section2SubTitle = @[@""];
    NSArray *section3SubTitle = @[@""];
    NSArray *section4SubTitle = @[@"发票抬头、地址"];
    NSArray *section5SubTitle = @[@""];
    NSArray *section6SubTitle = @[@"400-616-6666"];
    cellSubTitleArray_ = [NSMutableArray arrayWithObjects:section1SubTitle,section2SubTitle,section3SubTitle,section4SubTitle,section5SubTitle,section6SubTitle,nil];
    
    return cellSubTitleArray_;
    
}

-(NSString *)userImageName{
    
    NSString *userImageName = @"ZCIconPrivilegeCardDefault";
    
    switch (_myAccount.level) {
        case LevelGeneral: {
            userImageName = @"ZCIconPrivilegeCardNormal";
        }
            break;
        case LevelSilver: {
            userImageName = @"ZCIconPrivilegeCardSilver";
        }
            break;
        case LevelGolden: {
            userImageName = @"ZCIconPrivilegeCardGold";
        }
            break;
        case LevelPlatinum: {
            userImageName = @"ZCIconPrivilegeCardPlatinum";
        }
            break;
        case LevelDiamond: {
            userImageName = @"ZCIconPrivilegeCardDiamond";
        }
            break;
        case LevelPudong:{
            userImageName = _myAccount.groupImgUrl;
        }
            break;
    }
    
    
    return userImageName;
}

-(NSString *)memberLevelStr{
    
    NSString *memberLevelStr = @"会员";
    
    switch (_myAccount.level) {
        case LevelGeneral: {
            memberLevelStr = @"普卡会员";
        }
            break;
        case LevelSilver: {
            memberLevelStr = @"银卡会员";
        }
            break;
        case LevelGolden: {
            memberLevelStr = @"金卡会员";
        }
            break;
        case LevelPlatinum: {
            memberLevelStr = @"白金卡会员";
        }
            break;
        case LevelDiamond: {
            memberLevelStr = @"钻石卡会员";
        }
            break;
        case LevelPudong:{
            memberLevelStr = _myAccount.levelDesc;
        }
            break;
    }
    
    return memberLevelStr;
}

-(NSString *)name{
    NSString *name = _myAccount.name;
    return [NSObject isEmptyObj:name] ? @"会员":name;
}

-(NSString *)balanceAmount{
    // 账户余额
    NSString *accountAmount = _myAccount.accountAmount;
    NSString *balanceAmount = accountAmount ? [NSString stringWithFormat:@"%.2f",[accountAmount floatValue]]:@"0";
    if ([balanceAmount doubleValue] >= 10000) {
        balanceAmount = @"9999.99";
    }
    
    return balanceAmount;
}


-(NSString *)cardCount{
    // 银行卡
    int creditCount  = _myAccount.creditCount?:0;
    int depositCount = _myAccount.depositCount?:0;
    return [NSString stringWithFormat:@"%d", creditCount + depositCount];
}


// 本地违章追款订单时间
-(void)setLatestPeccancyDate{
    
    NSNumber *latestDate = @(_myAccount.proofTime); //TODO 待确认
    [[ZCUserInfo sharedZCUserInfo] setLatestPeccancyDate:latestDate flag:kPeccancyUpdateDate];
}

-(void)updateLatestPeccancyDate{

    NSNumber *latestDate = @(_myAccount.violationUnTime);
    [[ZCUserInfo sharedZCUserInfo] setLatestPeccancyDate:latestDate flag:kPeccancyOrderDate];
}

@end
