//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "ManagerIncludes.h"

#import "AppWarpHelper.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>

@interface MainScene : CCScene <CCPhysicsCollisionDelegate> {
    
    enum ItemType {
        BARREL = 0,
        VOMIT = 1,
        BAIT = 2,
        POWERUP = 3,
    };
    
    CCPhysicsNode *_physicsNode;
    CCPhysicsNode *_backPhysicsNode;

    CCSprite *_stage;
    CCSprite *_barrel;
    CCSprite *_vomit;
    CCNode *itemBox[3];
    
    CCNode *arrowNode;
    
    //network manager

    BOOL validMove;
    
    //drag vector for movement
    CGPoint start;
    CGPoint end;
    CGPoint launchDirection;
    //int facingDirection;
    
    //starting locations
    CGPoint daveStart;
    CGPoint hueyStart;
    CGPoint princessStart;
    
    //starting z order
    int daveZ;
    int hueyZ;
    int princessZ;
    
    //stage image for falloff detection
    UIImage* uiimage;
    
    //check if falling
    BOOL falling[3];
    
    //ticker for revive
    int reviveCounter[3];
    
    //game timer
    NSDate *startTime;
    NSTimeInterval timeElapsed;
    
    //for items
    BOOL itemHasDroppedForThisPeriod;
    //CCNode *itemNode;
    CCNode* currItem;
    CCNode* chosenItem;
    CGPoint itemMid;
    CCNode* inventory;
    int itemsHeld;
}

+(void) updateOpponent :(CGPoint) msg;

//@property (nonatomic, retain) int time;

@end
