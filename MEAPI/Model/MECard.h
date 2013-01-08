//
//  MECard.h
//  MyEYB
//
//  Created by Mert Dümenci on 1/6/13.
//  Copyright (c) 2013 Mert D√ºmenci. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MEAPICardType) {
    MEAPICardTypeUpToDate,
    MEAPICardTypeOfficial
};

@interface MECard : NSObject

-(instancetype)initWithCardImage:(UIImage *)image type:(MEAPICardType)type;

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) MEAPICardType type;

@end
