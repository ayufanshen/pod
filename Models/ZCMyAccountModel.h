//
//  ZCMyAccountResult.h
//  zuche
//
//  Created by 饭小团 on 2017/6/9.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HelpUrls.h"
#import "PeccancyModel.h"


@interface ZCMyAccountModel : JSONModel

@property (assign, nonatomic) int            accIntegral;
@property (assign, nonatomic) int            cdmsOrderCount;
@property (assign, nonatomic) int            continueUploadPic;
@property (assign, nonatomic) int            convenienceOrderCount;

@property (assign, nonatomic) int            creditCount;
@property (assign, nonatomic) int            depositCount;
@property (assign, nonatomic) int            faceAuth;
@property (assign, nonatomic) int            groupId;

@property (assign, nonatomic) int            openCreditCardStatus;
@property (assign, nonatomic) int            payPwdStatus;
@property (assign, nonatomic) int            point;
@property (assign, nonatomic) int            proofTime;

@property (assign, nonatomic) int            quickPayShowStatus;
@property (assign, nonatomic) int            quickPayStatus;
@property (assign, nonatomic) int            rentautoCoinCount;
@property (assign, nonatomic) int            requireCompletion;

@property (assign, nonatomic) int            share;
@property (assign, nonatomic) int            srmsOrderCount;
@property (assign, nonatomic) int            unEluationConvenienceOrder;
@property (assign, nonatomic) int            unEluationSrmsOrder;

@property (assign, nonatomic) int            userState;
@property (assign, nonatomic) int            violationUnTime;
@property (assign, nonatomic) int            isBusinessCustomer;
@property (assign, nonatomic) int            isOpenQuickPay;

@property (assign, nonatomic) int            isRelatedCreditcard;
@property (assign, nonatomic) int            level;
@property (assign, nonatomic) int            idType;

@property (strong, nonatomic) NSNumber     * violationUnCount;
@property (strong, nonatomic) NSNumber     * giftcardAmount;
@property (strong, nonatomic) NSNumber     * couponCount;
@property (strong, nonatomic) NSNumber     * availIntegral;

@property (strong, nonatomic) NSString     * nativePhone;
@property (strong, nonatomic) NSString     * accountAmount;
@property (strong, nonatomic) NSString     * bindCardPrompt;
@property (strong, nonatomic) NSString     * businessName;

@property (strong, nonatomic) NSString     * couponListUrl;
@property (strong, nonatomic) NSString     * driverPic;
@property (strong, nonatomic) NSString     * groupImgUrl;
@property (strong, nonatomic) NSString     * email;

@property (strong, nonatomic) NSString     * idCarPicBack;
@property (strong, nonatomic) NSString     * idCarPicFront;
@property (strong, nonatomic) NSString     * idNo;
@property (strong, nonatomic) NSString     * idTypeName;

@property (strong, nonatomic) NSString     * levelDesc;
@property (strong, nonatomic) NSString     * name;
@property (strong, nonatomic) NSString     * openCreditCardStatusDesc;
@property (strong, nonatomic) NSString     * phone;

@property (strong, nonatomic) NSString     * quickPayStatusDesc;
@property (strong, nonatomic) NSString     * regTime;
@property (strong, nonatomic) NSString     * scoreDetailUrl;
@property (strong, nonatomic) NSString     * userDetailUrl;

@property (strong, nonatomic) HelpUrls     * helps;

@end


