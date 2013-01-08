//
//  MEAPI.m
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import "MEAPI.h"

#import <AFNetworking/AFNetworking.h>
#import "OpenUDID.h"
#import "UICKeyChainStore.h"

#import "MEJSONRequestOperation.h"

static NSString *const kNumberSaveKey = @"com.mertdumenci.meapi.number";
static NSString *const kPasswordSaveKey = @"com.mertdumenci.meapi.password";
static NSString *const kSchoolCodeSaveKey = @"com.mertdumenci.meapi.schoolcode";

@interface MEAPI (private)
-(NSURLRequest *)_sessionTokenRequest;
-(NSURLRequest *)_newsListRequest;
-(NSURLRequest *)_newsRequestWithID:(NSString *)newsID;
-(NSURLRequest *)_schoolListRequest;
-(NSURLRequest *)_loginRequestWithSchoolNumber:(NSString *)schoolNumber password:(NSString *)password andSchoolCode:(NSString *)schoolCode;
-(NSURL *)_cardRequestBaseURL;
-(NSURLRequest *)_additionalInfoRequest;

-(void)_saveCredentialsWithSchoolNumber:(NSString *)schoolNumber password:(NSString *)password schoolCode:(NSString *)schoolCode;
-(BOOL)_hasSavedCredentials;
@end

@implementation MEAPI
#pragma mark - Lifecycle

+(instancetype)sharedInstance {
    static MEAPI *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[self alloc] init];
    });
    
    return api;
}

#pragma mark - Public methods

-(void)getSessionTokenWithCompletionBlock:(MEAPISessionTokenCompletionBlock)completionBlock {
    [[MEJSONRequestOperation JSONRequestOperationWithRequest:self._sessionTokenRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (JSON) {
            _sessionToken = JSON[@"s"];
            completionBlock(_sessionToken);
            return;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(nil);
        return;
    }] start];
}

-(void)getNewsWithCompletionBlock:(MEAPINewsCompletionBlock)completionBlock {
    [[MEJSONRequestOperation JSONRequestOperationWithRequest:self._newsListRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (JSON) {
            NSMutableArray *newsArray = [NSMutableArray array];
            for (NSDictionary *dict in JSON[@"l"]) {
                MENews *news = [[MENews alloc] initWithJSONDictionary:dict];
                [newsArray addObject:news];
            }
            
            completionBlock([NSArray arrayWithArray:newsArray], nil);
            return;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(nil, error);
        return;
    }] start];
}

-(void)getSchoolListWithCompletionBlock:(MEAPISchoolListCompletionBlock)completionBlock {
    [[MEJSONRequestOperation JSONRequestOperationWithRequest:self._schoolListRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (JSON) {
            NSMutableArray *schoolsList = [NSMutableArray array];
            for (NSDictionary *dict in JSON) {
                MESchool *school = [[MESchool alloc] initWithJSONDictionary:dict];
                [schoolsList addObject:school];
            }
            
            [schoolsList removeLastObject]; // API returns a weird empty object as the last object, get rid of that
            completionBlock([NSArray arrayWithArray:schoolsList], nil);
            return;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(nil, error);
        return;
    }] start];
}

-(void)getDetailForNews:(MENews *)news completionBlock:(MEAPINewsDetailCompletionBlock)completionBlock {
    [[MEJSONRequestOperation JSONRequestOperationWithRequest:[self _newsRequestWithID:news.id] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [news appendAdditionalInfoJSONDictionary:JSON];
        completionBlock(news, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(nil, error);
    }] start];
}

-(void)autologinWithCompletionBlock:(MEAPIAutoLoginCompletionBlock)completionBlock {
    if (self._hasSavedCredentials) {
        [self loginWithSchoolNumber:self.savedNumber password:self.savedPassword schoolCode:self.savedSchoolCode withCompletionBlock:^(MEStudent *student, NSError *error) {
            completionBlock(student, error);
        }];
        return;
    }
    else {
        completionBlock(nil, [NSError notLoggedInError]);
        return;
    }
}

-(void)loginWithSchoolNumber:(NSString *)schoolNumber password:(NSString *)password schoolCode:(NSString *)schoolCode withCompletionBlock:(MEAPILoginCompletionBlock)completionBlock {
    [[MEJSONRequestOperation JSONRequestOperationWithRequest:[self _loginRequestWithSchoolNumber:schoolNumber password:password andSchoolCode:schoolCode] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (JSON) {
            MEStudent *student = [[MEStudent alloc] initWithJSONDictionary:JSON];
            [self _saveCredentialsWithSchoolNumber:schoolNumber password:password schoolCode:schoolCode];
            _loggedIn = YES;
            completionBlock(student, nil);
            return;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self logout];
        completionBlock(nil, error);
        return;
    }] start];
}

-(void)logout {
    self.savedNumber = nil;
    self.savedPassword = nil;
    self.savedSchoolCode = nil;
    _sessionToken = nil;
    _loggedIn = NO;
}

-(void)getCurrentCardWithType:(MEAPICardType)type completionBlock:(MEAPICardCompletionBlock)completionBlock {
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:self._cardRequestBaseURL];
    
    NSMutableString *string = [NSMutableString stringWithString:@"CarnetPreview.aspx?"];
    [string appendFormat:@"sessionID=%@", _sessionToken];
    if (type == MEAPICardTypeOfficial) [string appendString:@"&type=offical"];
    NSString *percentEscapedString = [[string copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [client getPath:percentEscapedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            MECard *card = [[MECard alloc] initWithCardImage:[UIImage imageWithData:responseObject] type:type];
            
            completionBlock(card, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
    }];
}

-(void)getAndAppendAdditionalInfoToStudent:(MEStudent *)student completionBlock:(MEAPIAdditionalStudentInfoCompletionBlock)completionBlock {
    [[MEJSONRequestOperation JSONRequestOperationWithRequest:self._additionalInfoRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (JSON) {
            BOOL success = [student appendAdditionalInfoJSONDictionary:JSON];
            completionBlock(success ? student : nil, nil);
            return;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(nil, error);
        return;
    }] start];
}

#pragma mark - Properties
-(void)setSavedNumber:(NSString *)savedNumber {
    [[NSUserDefaults standardUserDefaults] setObject:savedNumber forKey:kNumberSaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)savedNumber {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kNumberSaveKey];
}

-(void)setSavedPassword:(NSString *)savedPassword {
    if (savedPassword) {
        [UICKeyChainStore setString:savedPassword forKey:kPasswordSaveKey];
    }
    
    else {
        [UICKeyChainStore removeItemForKey:kPasswordSaveKey];
    }

    [[UICKeyChainStore keyChainStore] synchronize];
}

-(NSString *)savedPassword {
    return [UICKeyChainStore stringForKey:kPasswordSaveKey];
}

-(void)setSavedSchoolCode:(NSString *)savedSchoolCode {
    if (savedSchoolCode) {
        [UICKeyChainStore setString:savedSchoolCode forKey:kSchoolCodeSaveKey];
    }
    
    else {
        [UICKeyChainStore removeItemForKey:kSchoolCodeSaveKey];
    }
    
    [[UICKeyChainStore keyChainStore] synchronize];
}

-(NSString *)savedSchoolCode {
    return [UICKeyChainStore stringForKey:kSchoolCodeSaveKey];
}

#pragma mark - Private Methods

-(NSURLRequest *)_sessionTokenRequest {
    NSMutableString *string = [NSMutableString stringWithString:@"http://my.eyuboglu.com/mobileapp/Default.aspx?"];
    
    [string appendString:@"par1=12"];
    [string appendFormat:@"&par3=%@", [OpenUDID value]];
    [string appendFormat:@"&par4=%@", [[UIDevice currentDevice] name]];
    [string appendFormat:@"&par5=%@", [[UIDevice currentDevice] systemName]];
    [string appendFormat:@"&par6=%@", [[UIDevice currentDevice] systemVersion]];
    [string appendString:@"&par7=iPhone"];
    [string appendString:@"&par8=iPhone"];
    
    NSString *percentEscapedString = [[string copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:percentEscapedString];
    return [NSURLRequest requestWithURL:URL];
}

-(NSURLRequest *)_newsListRequest {
    NSMutableString *string = [NSMutableString stringWithString:@"http://my.eyuboglu.com/mobileapp/Default.aspx?"];
    
    [string appendString:@"par1=14"];
    [string appendFormat:@"&par2=%@", _sessionToken];
    [string appendString:@"&par3=0"];
    
    NSString *percentEscapedString = [[string copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:percentEscapedString];
    return [NSURLRequest requestWithURL:URL];
}

-(NSURLRequest *)_newsRequestWithID:(NSString *)newsID {
    NSMutableString *string = [NSMutableString stringWithString:@"http://my.eyuboglu.com/mobileapp/Default.aspx?"];
    
    [string appendString:@"par1=15"];
    [string appendFormat:@"&par2=%@", _sessionToken];
    [string appendFormat:@"&par3=%@", newsID];
    
    NSString *percentEscapedString = [[string copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:percentEscapedString];
    return [NSURLRequest requestWithURL:URL];
}

-(NSURLRequest *)_schoolListRequest {
    NSMutableString *string = [NSMutableString stringWithString:@"http://my.eyuboglu.com/mobileapp/Default.aspx?"];
    
    [string appendString:@"par1=1"];
    [string appendFormat:@"&par2=%@", _sessionToken];
    
    NSString *percentEscapedString = [[string copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:percentEscapedString];
    return [NSURLRequest requestWithURL:URL];
}

-(NSURLRequest *)_loginRequestWithSchoolNumber:(NSString *)schoolNumber password:(NSString *)password andSchoolCode:(NSString *)schoolCode {
    NSMutableString *string = [NSMutableString stringWithString:@"http://my.eyuboglu.com/mobileapp/Default.aspx?"];
    NSString *loginString = [NSString stringWithFormat:@"%@:%@:%@", schoolCode, schoolNumber, password];
    
    [string appendString:@"par1=2"];
    [string appendFormat:@"&par2=%@", _sessionToken];
    [string appendFormat:@"&par3=%@", loginString];
    
    NSString *percentEscapedString = [[string copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:percentEscapedString];
    return [NSURLRequest requestWithURL:URL];
}

-(NSURL *)_cardRequestBaseURL {
    NSMutableString *string = [NSMutableString stringWithString:@"http://my.eyuboglu.com/mobileapp"];
    
    NSString *percentEscapedString = [[string copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:percentEscapedString];
    return URL;
}

-(NSURLRequest *)_additionalInfoRequest {
    NSMutableString *string = [NSMutableString stringWithString:@"http://my.eyuboglu.com/mobileapp/Default.aspx?"];
    
    [string appendString:@"par1=3"];
    [string appendFormat:@"&par2=%@", _sessionToken];
    [string appendString:@"&par3=0"];
    
    NSString *percentEscapedString = [[string copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:percentEscapedString];
    return [NSURLRequest requestWithURL:URL];
}
        
-(void)_saveCredentialsWithSchoolNumber:(NSString *)schoolNumber password:(NSString *)password schoolCode:(NSString *)schoolCode {
    self.savedNumber = schoolNumber;
    self.savedPassword = password;
    self.savedSchoolCode = schoolCode;
}

-(BOOL)_hasSavedCredentials {
    return (self.savedNumber || self.savedPassword || self.savedSchoolCode);
}

@end
