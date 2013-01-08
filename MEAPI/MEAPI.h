//
//  MEAPI.h
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MESchool.h"
#import "MEStudent.h"
#import "MECard.h"
#import "MENews.h"

#import "NSError+MEExtensions.h"

typedef void (^MEAPISessionTokenCompletionBlock)(NSString *sessionToken);
typedef void (^MEAPINewsCompletionBlock)(NSArray *news, NSError *error);
typedef void (^MEAPINewsDetailCompletionBlock)(MENews *news, NSError *error);
typedef void (^MEAPISchoolListCompletionBlock)(NSArray *schools, NSError *error);
typedef void (^MEAPILoginCompletionBlock)(MEStudent *student, NSError *error);
typedef void (^MEAPIAutoLoginCompletionBlock)(MEStudent *student, NSError *error);
typedef void (^MEAPICardCompletionBlock)(MECard *card, NSError *error);
typedef void (^MEAPIAdditionalStudentInfoCompletionBlock)(MEStudent *student, NSError *error);

@interface MEAPI : NSObject {
    NSString *_sessionToken;
}

@property (nonatomic) NSString *savedNumber;
@property (nonatomic) NSString *savedPassword;
@property (nonatomic) NSString *savedSchoolCode;
@property (nonatomic)     BOOL loggedIn;

+(instancetype)sharedInstance;

-(void)getSessionTokenWithCompletionBlock:(MEAPISessionTokenCompletionBlock)completionBlock;

/* Methods below require a session token to work */
-(void)getNewsWithCompletionBlock:(MEAPINewsCompletionBlock)completionBlock;
-(void)getSchoolListWithCompletionBlock:(MEAPISchoolListCompletionBlock)completionBlock;

-(void)getDetailForNews:(MENews *)news completionBlock:(MEAPINewsDetailCompletionBlock)completionBlock;

-(void)autologinWithCompletionBlock:(MEAPIAutoLoginCompletionBlock)completionBlock;
-(void)loginWithSchoolNumber:(NSString *)schoolNumber password:(NSString *)password schoolCode:(NSString *)schoolCode withCompletionBlock:(MEAPILoginCompletionBlock)completionBlock;
-(void)logout;

-(void)getCurrentCardWithType:(MEAPICardType)type completionBlock:(MEAPICardCompletionBlock)completionBlock;
-(void)getAndAppendAdditionalInfoToStudent:(MEStudent *)student completionBlock:(MEAPIAdditionalStudentInfoCompletionBlock)completionBlock;


@end
