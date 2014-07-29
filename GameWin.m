//
//  GameWin.m
//  DrunkenKNights
//
//  Created by Bankole O on 7/28/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameWin.h"


@implementation GameWin

- (void)didLoadFromCCB {

    [GameVariables setCurrentScene:@"GameWin"];

}


-(void) goMain
{
    CCScene *splashScene = [CCBReader loadAsScene:@"GameRoom"];
    [[CCDirector sharedDirector] replaceScene:splashScene];
}
@end
