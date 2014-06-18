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

@interface ItemManager : CCNode {
    
}

enum ItemType {
    BARREL = 0,
    VOMIT = 1,
    BAIT = 2,
    POWERUP = 3,
};

+ (CCNode*)dropItem;;
+ (CGPoint)itemDisplay;
+ (int) useItem: (__strong CCNode*[]) itemBoxes : (int) index : (int) itemsHeld;
+ (void) itemEntersInventory: (CCNode*) item;
+ (void) activateItemAbilities: (CCNode*) item;

@end
