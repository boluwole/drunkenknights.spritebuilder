//
//  Tutorial1.m
//  DrunkenKNights
//
//  Created by Bankole O on 7/27/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Tutorial1.h"


@implementation Tutorial1

-(void) next
{
    CCScene *tutorialScene = [CCBReader loadAsScene:@"Tutorial2"];
    [[CCDirector sharedDirector] replaceScene:tutorialScene];
    
}
-(void) previous
{
    CCScene *splashScene = [CCBReader loadAsScene:@"SplashScreen"];
    [[CCDirector sharedDirector] replaceScene:splashScene];
}
@end
