//
//  MESchool.h
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MESchool : NSObject

-(instancetype)initWithJSONDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *name; // t key in dictionary
@property (nonatomic, copy) NSString *code; // v key in dictionary
@end
