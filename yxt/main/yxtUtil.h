//
//  yxtUtil.h
//  yxt
//
//  Created by world ask on 13-5-30.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yxtUtil : NSObject

-(BOOL) checkNetwork;
-(NSString*) setRequestInfo:(NSString *)action :(NSString *)pageIndex :(NSString *)pageSize;
-(NSString*) setIdentifyInfo;
-(NSString*) getResponseInfo;
-(NSString*) getIdentifyInfo;
-(NSString*) getData;

-(NSString*) md5:(NSString *) input;

@end
