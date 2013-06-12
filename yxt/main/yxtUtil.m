//
//  yxtUtil.m
//  yxt
//
//  Created by panht on 13-5-30.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtUtil.h"
#import "yxtAppDelegate.h"
//#import "GTMBase64.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

//#define kChosenDigestLength     CC_SHA1_DIGEST_LENGTH
//
//#define DESKEY @"D6D2402F1C98E208FF2E863AA29334BD65AE1932A821502D9E5673CDE3C713ACFE53E2103CD40ED6BEBB101B484CAE83D537806C6CB611AEE86ED2CA8C97BBE95CF8476066D419E8E833376B850172107844D394016715B2E47E0A6EECB3E83A361FA75FA44693F90D38C6F62029FCD8EA395ED868F9D718293E9C0E63194E87"


@implementation yxtUtil

// 请求参数requestinfo
+(NSString*) setRequestInfo: (NSString *)action :(NSString *)pageIndex :(NSString *)pageSize :(NSString *)identityInfo :(NSString *)data
{
    
    NSDateFormatter *nsdf2 = [[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYYMMddHHmmssSSS"];
    NSString *serialnum = [nsdf2 stringFromDate:[NSDate date]];
    
    
    long long timestamp = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *strTimestamp = [NSString stringWithFormat:@"%lld", timestamp];
    
    NSString *authentication = [[NSString alloc] initWithString:[self md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", action, serialnum, pageIndex, pageSize, strTimestamp, identityInfo, data]]];
    
    NSString *result = [[NSString alloc] initWithString:[NSString stringWithFormat:@"{\"action\":\"%@\",\"serialnum\":\"%@\",\"pageindex\":\"%@\",\"pagesize\":\"%@\",\"timestamp\":\"%@\",\"authentication\":\"%@\"}", action, serialnum, pageIndex, pageSize, strTimestamp, authentication]];
    
    return result;
}

// 请求参数identityInfo
+(NSString*) setIdentityInfo
{
    yxtAppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    NSString *result = [[NSString alloc] initWithString: [NSString stringWithFormat:@"{\"curruserid\":\"%@\",\"schoolserno\":\"%@\",\"logintype\":\"%@\",\"token\":\"%@\"}", app.userId, app.schoolNo, app.loginType, app.token]];
    
    return result;
}

+(NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

// 从服务器返回结果数据集
+(NSDictionary*) getResponse:(NSString *)requestInfo :(NSString *)identityInfo :(NSString *)data {
    // 检查网络连接
    BOOL flagNetwork = [self checkNetwork];
    
    if (flagNetwork == NO) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        [result setObject:@"-999" forKey:@"resultcode"];
        [result setObject:@"没有可用的网络连接" forKey:@"resultdes"];
        
        return result;
    } else {
        yxtAppDelegate *app = [[UIApplication sharedApplication] delegate];
        
        // 特殊字符urlencode
        requestInfo = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) requestInfo, NULL, CFSTR("!*'();:@&=+$,/?%#[]{}\""), kCFStringEncodingUTF8));
        identityInfo = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) identityInfo, NULL, CFSTR("!*'();:@&=+$,/?%#[]{}\""), kCFStringEncodingUTF8));
        data = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) data, NULL, CFSTR("!*'();:@&=+$,/?%#[]{}\""), kCFStringEncodingUTF8));
        //    requestInfo = [self urlEncode:requestInfo];
        //    identityInfo = [self urlEncode:identityInfo];
        //    data = [self urlEncode:data];
        
        NSString *postURL = [[NSString alloc] initWithFormat:@"RequestInfo=%@&IdentityInfo=%@&data=%@", requestInfo, identityInfo, data];
        
        //    NSLog(@"postURL: %@", postURL);
        // 向服务器提交请求，并得到返回数据
        NSData *postData = [postURL dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:app.urlService]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        //[NSURLConnection connectionWithRequest:request delegate:self ];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        // 返回数据转json
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:kNilOptions
                                                               error:&error];
        // responseinfo段再转json
        NSString* responseinfo = [json objectForKey:@"responseinfo"];
        NSData *dataResponseinfo = [responseinfo dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonResponseinfo = [NSJSONSerialization JSONObjectWithData:dataResponseinfo
                                                                         options:kNilOptions
                                                                           error:&error];
        
        // 返回数据
        NSString *resultData = [json objectForKey:@"resultdata"];
        NSData *dataResultData = [resultData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResultData = [NSJSONSerialization JSONObjectWithData:dataResultData
                                                                       options:kNilOptions
                                                                         error:&error];
        
        
        // 将responseinfo中的recordcount附加到data
        if ([jsonResponseinfo objectForKey:@"recordcount"] != NULL && [jsonResultData isKindOfClass:[NSDictionary class]] == YES) {
            NSMutableDictionary *jsonResultData1 = [jsonResultData mutableCopy];
            [jsonResultData1 setObject:[jsonResponseinfo objectForKey:@"recordcount"] forKey:@"recordcount"];
            jsonResultData = [NSDictionary dictionaryWithDictionary:jsonResultData1];
        }
        
        NSLog(@"resultdata = %@", resultData);
        return jsonResultData;
    }
}

+ (NSString*) urlEncode:(NSString *) input {
    NSString *data = [input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *data = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)input, nil, nil, kCFStringEncodingUTF8));

    //    data = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)data, nil, nil, kCFStringEncodingUTF8);
    
    return data;
}

+ (NSString*) urlDecode:(NSString *) input {
//    NSString *data = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)input, nil,  kCFStringEncodingUTF8));
    NSString *data =  [input stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}

// 检查网络连接
+(BOOL) checkNetwork
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

+ (void) message:(UIView *) view :(NSString *) message {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];

	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
//	HUD.delegate = self;
	HUD.labelText = message;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:2];
}

+ (void) warning:(UIView *) view :(NSString *) message {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
	HUD.mode = MBProgressHUDModeCustomView;
//	HUD.delegate = self;
	HUD.labelText = message;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:2];
}

@end
