//
//  NSError+MEExtensions.m
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import "NSError+MEExtensions.h"

@implementation NSError (MEExtensions)
+(instancetype)noSessionTokenError {
    NSError *error = [NSError errorWithDomain:kNSErrorMEExtensionsDomain code:MEExtensionsErrorNoSessionToken userInfo:@{NSLocalizedDescriptionKey : @"Please retrieve a session token by -getSessionTokenWithCompletionBlock: method first."}];
    return error;
}

+(instancetype)notLoggedInError {
    NSError *error = [NSError errorWithDomain:kNSErrorMEExtensionsDomain code:MEExtensionsErrorNotLoggedIn userInfo:@{NSLocalizedDescriptionKey : @"Please login by -loginWithSchoolNumber:password:schoolCode:withCompletionBlock: first."}];
    return error;
}

@end
