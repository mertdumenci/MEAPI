//
//  MEStudent.m
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import "MEStudent.h"

@implementation MEStudent
-(instancetype)initWithJSONDictionary:(NSDictionary *)dict {
    if (dict[@"err"] != nil) return nil;

    if (self = [super init]) {
        self.name = dict[@"ad"];
        self.surname = dict[@"soyad"];
        self.className = dict[@"sinif"];
        self.number = dict[@"no"];
        self.schoolCode = dict[@"okulkodu"];
    }
    
    return self;
}

-(BOOL)appendAdditionalInfoJSONDictionary:(NSDictionary *)dict {
    NSArray *infoArray = dict[@"l"];
    if (!infoArray || infoArray.count != 11) return NO;
    
    /*  Index 3 = Phone Number
        Index 4 = Email
        Index 5 = Project Lesson
        Index 6 = Student Club
        Index 7 = Joined Team
        Index 8 = Bus Number
        Index 9 = Bus Driver
        Index 10 = Bus Driver Phone Number
     
        v key = value
    */
    
    self.phoneNumber = infoArray[3][@"v"];
    self.email = infoArray[4][@"v"];
    self.projectLesson = infoArray[5][@"v"];
    self.club = infoArray[6][@"v"];
    self.team = infoArray[7][@"v"];
    self.schoolBusNumber = infoArray[8][@"v"];
    self.schoolBusDriver = [infoArray[9][@"v"] capitalizedString];
    self.schoolBusDriverPhoneNumber = infoArray[10][@"v"];

    return YES;
}

#pragma mark - Properties
-(NSString *)description {
    return [NSString stringWithFormat:@"[MEStudent] %@ — %@, %@", self.fullname, self.className, self.number];
}

-(NSString *)fullname {
    return [NSString stringWithFormat:@"%@ %@", [self.name capitalizedString], [self.surname capitalizedString]];
}

-(void)setPhoneNumber:(NSString *)phoneNumber {
    if ([phoneNumber isEqualToString:@""]) {
        _phoneNumber = nil;
        return;
    }
    
    if (_phoneNumber != phoneNumber) {
        _phoneNumber = phoneNumber;
        return;
    }
}

-(void)setEmail:(NSString *)email {
    if ([email isEqualToString:@""]) {
        _email = nil;
        return;
    }
    
    if (_email != email) {
        _email = email;
        return;
    }
}

-(void)setProjectLesson:(NSString *)projectLesson {
    if ([projectLesson isEqualToString:@""]) {
        _projectLesson = nil;
        return;
    }
    
    if (_projectLesson != projectLesson) {
        _projectLesson = projectLesson;
        return;
    }
}

-(void)setClub:(NSString *)club {
    if ([club isEqualToString:@""]) {
        _club = nil;
        return;
    }
    
    if (_club != club) {
        _club = club;
        return;
    }
}

-(void)setTeam:(NSString *)team {
    if ([team isEqualToString:@""]) {
        _team = nil;
        return;
    }
    
    if (_team != team) {
        _team = team;
        return;
    }
}

-(void)setSchoolBusNumber:(NSString *)schoolBusNumber {
    if ([schoolBusNumber isEqualToString:@""]) {
        _schoolBusNumber = nil;
        return;
    }
    
    if (_schoolBusNumber != schoolBusNumber) {
        _schoolBusNumber = schoolBusNumber;
        return;
    }
}

-(void)setSchoolBusDriver:(NSString *)schoolBusDriver {
    if ([schoolBusDriver isEqualToString:@""]) {
        _schoolBusDriver = nil;
        return;
    }
    
    if (_schoolBusDriver != schoolBusDriver) {
        _schoolBusDriver = schoolBusDriver;
        return;
    }
}

-(void)setSchoolBusDriverPhoneNumber:(NSString *)schoolBusDriverPhoneNumber {
    if ([schoolBusDriverPhoneNumber isEqualToString:@""]) {
        _schoolBusDriverPhoneNumber = nil;
        return;
    }
    
    if (_schoolBusDriverPhoneNumber != schoolBusDriverPhoneNumber) {
        _schoolBusDriverPhoneNumber = schoolBusDriverPhoneNumber;
        return;
    }
}

@end
