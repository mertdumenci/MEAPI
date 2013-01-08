//
//  MENews.h
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MENews : NSObject
-(instancetype)initWithJSONDictionary:(NSDictionary *)dict;
-(BOOL)appendAdditionalInfoJSONDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *id; // i in JSON dictionary
@property (nonatomic, copy) NSString *title; // t in JSON dictionary

// Set later with -appendAdditionalInfoJSONDictionary:
@property (nonatomic, copy) NSString *text; // c in JSON dictionary
@end
