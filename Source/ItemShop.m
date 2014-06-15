//
//  ItemShop.m
//  DrunkenKNights
//
//  Created by Apple User on 6/14/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "ItemShop.h"


@implementation ItemShop


- (void)startGame {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)skipLeft {
    
}

- (void)skipRight{
    
}

@end
