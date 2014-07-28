//
//  Tutorial2.m
//  DrunkenKNights
//
//  Created by Bankole O on 7/27/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Tutorial2.h"


@implementation Tutorial2

-(void) next
{
    CCScene *splashScene = [CCBReader loadAsScene:@"SplashScreen"];
    [[CCDirector sharedDirector] replaceScene:splashScene];
    
}

-(void) previous
{
    CCScene *tutorialScene = [CCBReader loadAsScene:@"Tutorial1"];
    [[CCDirector sharedDirector] replaceScene:tutorialScene];
}

@end
