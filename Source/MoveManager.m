//
//  MoveManager.m
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "MoveManager.h"


@implementation MoveManager

+ (void)drunkSwaying: (CCNode*) player :(float) playerDrunkeness :(float) time {
    CGPoint impulse = ccp((playerDrunkeness/10) * 6 * cos(2*time),(playerDrunkeness/10) * 10 * sin(2*time));
    [player.physicsBody applyImpulse:impulse];
    
    //player.rotation = playerDrunkeness*sin(time);
}

+ (void)movePlayer: (CCNode *) player :(CGPoint) launchDirection :(int) playerDrunkeness {
    
    if(player && launchDirection.x == launchDirection.x && launchDirection.y == launchDirection.y) {
    
    // manually create & apply a force to launch the knight
    
    CGPoint impulse = ccpMult(launchDirection, (MOVE_SPEED*(playerDrunkeness/10)) + MOVE_SPEED);
    
    [player.physicsBody applyImpulse:impulse];
        
    }
}

+ (CGPoint)calculateMoveVector: (CGPoint) start : (CGPoint) end {
    CGPoint launchDirection = ccpSub(start, end);
    double len = ccpLength(launchDirection);
    
    if(len > VECTOR_CAP) {
        launchDirection = ccpNormalize(launchDirection);
        launchDirection = ccpMult(launchDirection, VECTOR_CAP);
    }
    
    return launchDirection;
}


@end
