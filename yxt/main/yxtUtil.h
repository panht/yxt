//
//  yxtUtil.h
//  yxt
//
//  Created by world ask on 13-5-30.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CommonCrypto/CommonCryptor.h>

@interface yxtUtil : NSObject

+(BOOL) checkNetwork;
//-(NSString*) getSerialNum;
//-(NSString*) getTimestamp;
//-(NSString*) getAuthentication: (NSString *)action :(NSString *)serialNum :(NSString *)pageIndex :(NSString *)pageSize :(NSString *)timestamp;
+(NSString*) setRequestInfo:(NSString *)action :(NSString *)pageIndex :(NSString *)pageSize :(NSString *)identityInfo :(NSString *)data;
+(NSString*) setIdentityInfo;
//+(NSString*) getResponseInfo;
//+(NSString*) getIdentityInfo;
//+(NSString*) getData;
+(NSDictionary*) getResponse:(NSString *)requestInfo :(NSString *)identityInfo :(NSString *)data;
+(NSString *) createPostURL:(NSMutableDictionary *)params;
//+(NSData *) getResultData: (NSMutableDictionary *)params;

+(NSString*) md5:(NSString *) input;
//-(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation) encryptOrDecrypt;

@end
