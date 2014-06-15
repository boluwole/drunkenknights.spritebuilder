//
//  SplashScreen.m
//  DrunkenKNights
//
//  Created by Apple User on 6/14/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "SplashScreen.h"


@implementation SplashScreen

- (void)enterGame {
    CCScene *itemShopScene = [CCBReader loadAsScene:@"ItemShop"];
    [[CCDirector sharedDirector] replaceScene:itemShopScene];
}

@end
