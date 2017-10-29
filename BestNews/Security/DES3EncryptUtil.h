
//
//  DES3EncryptUtil.h
//  DES3加解密工具
//
//  Created by xc on 15/12/18.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3EncryptUtil : NSObject

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

@end
