//
//  MoveManager.m
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "MoveManager.h"


@implementation MoveManager

+ (void)movePlayer: (CCNode *) player :(CGPoint) launchDirection {
    
    // manually create & apply a force to launch the knight
    
    CGPoint impulse = ccpMult(launchDirection, MOVE_SPEED);
    
    [player.physicsBody applyImpulse:impulse];
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