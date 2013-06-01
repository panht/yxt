//
//  yxtUtil.m
//  yxt
//
//  Created by world ask on 13-5-30.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtUtil.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>


@implementation yxtUtil

-(BOOL) checkNetwork
{
//    SCNetworkReachabilityFlags flags;
//    BOOL receivedFlags;
//    
//    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"www.fjyxt.cn" UTF8String]);
//    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
//    CFRelease(reachability);
//    
//    if (!receivedFlags || (flags == 0) )
//    {
//        NSLog(@"0");
//        return 0;
//    } else {
//        NSLog(@"1");
//        return 1;
    //    }
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
