//
//  MoveManager.h
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConstants.h"

@interface MoveManager : CCNode {
    

}

+ (void)movePlayer: (CCNode *) player :(CGPoint) launchDirection :(int) playerDrunkeness;
+ (CGPoint)calculateMoveVector: (CGPoint) start : (CGPoint) end;
+ (void)drunkSwaying: (CCNode*) player :(float) playerDrunkeness :(float) time;

@end
