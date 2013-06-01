//
//  yxtUtil.m
//  yxt
//
//  Created by world ask on 13-5-30.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtUtil.h"
#import "yxtAppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <CommonCrypto/CommonDigest.h>


@implementation yxtUtil

-(NSString*) setRequestInfo: (NSString *)action :(NSString *)pageIndex :(NSString *)pageSize
{
    NSDateFormatter *nsdf2 = [[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYYMMddHHmmssSSS"];
    NSString *serialnum = [nsdf2 stringFromDate:[NSDate date]];
//    long serialnum = [t2 longLongValue];    
    
    long long timestamp = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *strTimestamp = [NSString stringWithFormat:@"%lld", timestamp];
    
    NSString *authentication = [[NSString alloc] init];
    authentication = [self md5:[action stringByAppendingString: [serialnum stringByAppendingString: [pageIndex stringByAppendingString: [pageSize stringByAppendingString: strTimestamp]]]]];
    
    NSString *result = [[NSString alloc] init];
    result = @"{\"action\":\"";
    [result stringByAppendingString: action];
    [result stringByAppendingString: @"\",\"serialnum\":\""];
    [result stringByAppendingString: serialnum];
    [result stringByAppendingString: @"\",\"pageindex\":\""];
    [result stringByAppendingString: pageIndex];
    [result stringByAppendingString: @"\",\"pagesize\":\""];
    [result stringByAppendingString: pageSize];
    [result stringByAppendingString: @"\",\"timestamp\":\""];
    [result stringByAppendingString: strTimestamp];
    [result stringByAppendingString: @"\",\"authentication\":\""];
    [result stringByAppendingString: authentication];
    [result stringByAppendingString: @"\"}"];
    
    NSLog(result);
    return result;
}
-(NSString*) setIdentifyInfo
{
    yxtAppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    NSString *result = [[NSString alloc] init];
    result = @"{\"curruserid\":\"";
    [result stringByAppendingString: app.userId];
    [result stringByAppendingString: @"\",\"schoolserno\":\""];
    [result stringByAppendingString: app.schoolNo];
    [result stringByAppendingString: @"\",\"logintype\":\""];
    [result stringByAppendingString: app.loginType];
    [result stringByAppendingString: @"\",\"token\":\""];
    [result stringByAppendingString: app.token];
    [result stringByAppendingString: @"\"}"];
    
    return result;
}

-(NSString*) getResponseInfo
{
    return @"111";
}

-(NSString*) getIdentifyInfo
{
    return @"111";
}

-(NSString*) getData
{
    return @"111";
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

// 检查网络连接
-(BOOL) checkNetwork
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    // = flags & kSCNetworkReachabilityFlagsIsWWAN;
    BOOL nonWifi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    BOOL moveNet = flags & kSCNetworkReachabilityFlagsIsWWAN;
    
    return ((isReachable && !needsConnection) || nonWifi || moveNet) ? YES : NO;
}

@end
