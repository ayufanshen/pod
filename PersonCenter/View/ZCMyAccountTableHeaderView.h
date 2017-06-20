//
//  ZCMyAccountTableHeaderView.h
//  zuche
//
//  Created by yk on 2017/2/20.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^gotoWebPageBlock)(NSInteger);

@interface ZCMyAccountTableHeaderView : UIView

@property (nonatomic,   copy) gotoWebPageBlock webPageBlock;
@property (nonatomic, strong) UIImageView *userHeadShot;
@property (nonatomic, strong) UILabel *nameLbl;

- (void)adjustMemberWithLevel:(NSString *)levelStr levelIconImg:(NSString *)levelIconImg;

@end
