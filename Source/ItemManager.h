//
//  ItemManager.h
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConstants.h"
#import "PhysicsManager.h"
#import "NetworkManager.h"

@interface ItemManager : CCNode {
    
}


enum ItemType {
    BARREL = 0,
    SLIME = 1,
    GHOST = 2,
    POWERUP = 3,
};


+ (int) checkBeerBottles : (CCSprite*) dave :(CCSprite*) huey :(BOOL) daveFalling :(BOOL) hueyFalling :(float*) daveDrunkLevel :(float*) hueyDrunkLevel :(__strong CCNode*[]) beerNodes;
+ (CCNode*)dropItem;;
+ (CGPoint)itemDisplay;
+ (int) useItem: (__strong CCNode*[]) itemBoxes : (int) index : (int) itemsHeld;
+ (void) itemEntersInventory: (CCNode*) item;
+ (void) activateItemAbilities: (CCNode*) item;
+ (void) SlimeCheck: (CCNode*) activeSlimes : (NSMutableArray*) activeSlimeLifetimes : (NSTimeInterval) currTime :
    (CCSprite*) dave : (CCSprite*) huey : (CCSprite*) princess;
+ (void) barrelCheck: (CCNode*) barrel : (NSMutableArray*) activeBarrelLifetimes;
+ (void) barrelUpdate: (NSMutableArray*) activeBarrelLifetimes : (int) index : (int) life;

+ (bool) returnDaveSlime;
+ (bool) returnHueySlime;
+ (bool) returnPrincessSlime;

+(void) setDaveSlime: (bool) ds;
+(void) setHueySlime: (bool) hs;
+(void) setPrincessSlime: (bool) ps;

@end
