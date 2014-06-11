//
//  Item.m
//  DrunkenKNights
//
//  Created by Student on 6/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Item.h"

@implementation Item

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"item";
}

- (void)setItemType: (int)t {

}

@end
