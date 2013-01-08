//
//  MECard.m
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import "MECard.h"

@implementation MECard
-(instancetype)initWithCardImage:(UIImage *)image type:(MEAPICardType)type {
    if (self = [super init]) {
        _image = image;
        _type = type;
    }
    
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"[MECard] Image : %@ Type : %d", self.image, self.type];
}

@end
