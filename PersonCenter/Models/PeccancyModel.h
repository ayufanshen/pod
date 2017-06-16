//
//  PeccancyModel.h
//  zuche
//
//  Created by 饭小团 on 2017/6/15.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import <JSONModel/JSONModel.h>

//违章内容
@interface PeccancyModel : JSONModel
@property (assign, nonatomic) int           proofCount;
@property (strong, nonatomic) NSString     *proofDesc;
@end
