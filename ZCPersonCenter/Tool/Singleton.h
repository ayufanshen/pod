//
//  Singleton.h
//  zuche
//
//  Created by shaneZhang on 15/12/16.
//  Copyright © 2015年 zuche. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

/*********
 singleton
 使用方法:http://blog.csdn.net/totogo2010/article/details/8373642
 **********/

/*!
 *  @brief 定义单例的宏，用在头文件中对外声明
 */
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;



/*!
 *  @brief 定义单例的宏，用在实现文件中实现单例
 */
#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#endif /* Singleton_h */
