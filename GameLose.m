//
//  GameLose.m
//  DrunkenKNights
//
//  Created by Bankole O on 7/28/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameLose.h"


@implementation GameLose

- (void)didLoadFromCCB {
    
    [GameVariables setCurrentScene:@"GameLose"];
    
}

-(void) goMain
{
    CCScene *splashScene = [CCBReader loadAsScene:@"GameRoom"];
    [[CCDirector sharedDirector] replaceScene:splashScene];
}

@end
