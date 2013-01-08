//
//  MEJSONRequestOperation.m
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import "MEJSONRequestOperation.h"

@implementation MEJSONRequestOperation
+ (NSSet *)acceptableContentTypes {
    NSSet *superSet = [super acceptableContentTypes];
    NSMutableSet *mutableSet = [NSMutableSet set];
    [mutableSet setSet:superSet];
    [mutableSet addObject:@"text/html"];
    return (NSSet *)mutableSet;
}

@end
