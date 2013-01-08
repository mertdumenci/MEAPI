//
//  MESchool.m
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import "MESchool.h"

@implementation MESchool
-(instancetype)initWithJSONDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.name = dict[@"t"];
        self.code = dict[@"v"];
    }
    
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"[MESchool] %@, %@", self.name, self.code];
}

@end
