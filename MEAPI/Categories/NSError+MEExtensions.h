//
//  NSError+MEExtensions.h
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kNSErrorMEExtensionsDomain = @"com.mertdumenci.myeyb.error";

typedef NS_ENUM(NSInteger, MEExtensionsError) {
    MEExtensionsErrorNoSessionToken = 300,
    MEExtensionsErrorNotLoggedIn = 301
};

@interface NSError (MEExtensions)
+(instancetype)noSessionTokenError;
+(instancetype)notLoggedInError;
@end
