//
//  MENews.m
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import "MENews.h"

@implementation MENews
-(instancetype)initWithJSONDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.id = dict[@"i"];
        self.title = dict[@"t"];
    }
    
    return self;
}

-(BOOL)appendAdditionalInfoJSONDictionary:(NSDictionary *)dict {
    self.text = dict[@"c"];
    return YES;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"[MENews] %@ - %@", self.title, self.text];
}

@end
