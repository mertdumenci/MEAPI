//
//  MEStudent.h
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEStudent : NSObject

-(instancetype)initWithJSONDictionary:(NSDictionary *)dict;
-(BOOL)appendAdditionalInfoJSONDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *name; // ad key in dictionary
@property (nonatomic, copy) NSString *surname; // soyad key in dictionary
@property (nonatomic, readonly) NSString *fullname;
@property (nonatomic, copy) NSString *className; // sinif key in dictionary
@property (nonatomic, copy) NSString *number; // no key in dictionary
@property (nonatomic, copy) NSString *schoolCode; // okulkodu key in dictionary

// Set later with [MEAPI] -getAndAppendAdditionalInfoToStudent:
@property (nonatomic, retain) NSURL *pictureURL;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *projectLesson;
@property (nonatomic, copy) NSString *club;
@property (nonatomic, copy) NSString *team;
@property (nonatomic, copy) NSString *schoolBusNumber;
@property (nonatomic, copy) NSString *schoolBusDriver;
@property (nonatomic, copy) NSString *schoolBusDriverPhoneNumber;

@end
