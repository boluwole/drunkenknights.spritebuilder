//
//  ItemManager.m
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "ItemManager.h"


@implementation ItemManager

+ (CCNode*)dropItem {
    
    //randomly choose a type of item to drop
    CCNode* item;
    int randomNum = rand() % 2;
    switch(randomNum) {
        case BARREL:
            item = [CCBReader load:@"Barrel"];
            break;
            
            
        case VOMIT:
            item = [CCBReader load:@"Vomit"];
            break;
    }
    
    //[_physicsNode addChild:currItem];
    item.scale*=0.2;
    item.position = [ItemManager itemDisplay];
    return item;
    
}

+ (CGPoint)itemDisplay{
    
    //   CCLOG(@"\nReached this method");
    
    CGPoint MidPoint, vToMidPoint, MidPointPerp, result;
    
    MidPoint = ccpMidpoint(_dave.position, _huey.position);
    vToMidPoint = ccpSub(MidPoint,_dave.position);
    MidPointPerp = (rand()%2 == 0) ? ccp(-vToMidPoint.y, vToMidPoint.x) : ccp(vToMidPoint.y, -vToMidPoint.x);
    MidPointPerp = ccpNormalize(MidPointPerp);
    
    result = ccpAdd(MidPoint, ccpMult(MidPointPerp, 50+(rand()%100)));
    if([PhysicsManager detectFallOff:result :uiimage] == NO) {
        return result;
    }
    else {
        float r = 100;
        float theta = ((rand()%6)*(360/6))*PI/180;
        result = ccpAdd(PRINCESS_START,ccp(r*cos(theta),r*sin(theta)));
        return result;
    }
}


+ (int) useItem : (__strong CCNode*[]) itemBoxes : (int) index : (int) itemsHeld {
    //[itemBoxes[index] removeAllChildren];


    for(int j = index+1; j < itemsHeld; j++) {
        NSArray* child = itemBoxes[j].children;
        CCNode* temp = (CCNode*)child[0];
        if(temp != nil) {
            [itemBoxes[j] removeChild:temp];
            [itemBoxes[j-1] addChild:temp];
        }
    }

     return itemsHeld-1;
}


@end
