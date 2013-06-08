//
//  yxtUtil.h
//  yxt
//
//  Created by panht on 13-5-30.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CommonCrypto/CommonCryptor.h>

@interface yxtUtil : NSObject

+ (BOOL) checkNetwork;
+ (NSString*) setRequestInfo:(NSString *)action :(NSString *)pageIndex :(NSString *)pageSize :(NSString *)identityInfo :(NSString *)data;
+ (NSString*) setIdentityInfo;
+ (NSDictionary*) getResponse:(NSString *)requestInfo :(NSString *)identityInfo :(NSString *)data;

+ (NSString*) urlEncode:(NSString *) input;
+ (NSString*) md5:(NSString *) input;

@end
