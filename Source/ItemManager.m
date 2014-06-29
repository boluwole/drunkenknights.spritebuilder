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
    int randomNum = rand() % 3;
    switch(randomNum) {
        case BARREL:
            item = [CCBReader load:@"Barrel"];
            break;
            
            
        case VOMIT:
            item = [CCBReader load:@"Vomit"];
            break;
            
        case GHOST:
            item = [CCBReader load: @"Ghost"];
            break;
    }
    
    //[_physicsNode addChild:currItem];
    item.scale*=0.3;
    [item setColor:[CCColor colorWithWhite:0.5 alpha:1.0]];
    item.position = [ItemManager itemDisplay];
    item.physicsBody.collisionMask = @[];
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

+ (void) itemEntersInventory: (CCNode*) item {
    item.physicsBody.collisionMask = @[];
    item.anchorPoint = CGPointZero;
    item.scale = 0.3;
    if([item.name isEqual:@"Ghost"]) {
        item.scale = 1.0;
    }
    item.position = CGPointZero;
    item.opacity = 1.0;
}

+ (int) useItem: (__strong CCNode*[]) itemBoxes : (int) index : (int) itemsHeld {
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

+ (void) activateItemAbilities: (CCNode*) item {
    if([item.name  isEqual: @"Barrel"]) {
        item.physicsBody.collisionMask = NULL;
    }
    else if([item.name  isEqual: @"Vomit"]) {
        
    }
    else if([item.name  isEqual: @"Ghost"]){
        

        
    }
}

//activeBarrelLifetimes is stored as: barrel A, life, barrel B, life, barrel C, life... etc
+ (void) barrelCheck: (CCNode*) barrel : (NSMutableArray*) activeBarrelLifetimes {
    for(int i = 0; i < activeBarrelLifetimes.count; i+=2) {
        if((CCNode*)activeBarrelLifetimes[i] == barrel) {
            activeBarrelLifetimes[i+1] = [NSNumber numberWithInt:([activeBarrelLifetimes[i+1] intValue] - 1)];
            
            [NetworkManager sendDeActivateItemsToServer:@"Barrel" iPosition:CGPointZero playerInfo:@"dave" iIndex:[NSString stringWithFormat:@"%i", i]];
            
            [ItemManager barrelUpdate:activeBarrelLifetimes :i];
            
            break;
        }
    }
}

+ (void) barrelUpdate: (NSMutableArray*) activeBarrelLifetimes : (int) index {
    
    CCNode* barrel = (CCNode*) activeBarrelLifetimes[index];
    
    switch([activeBarrelLifetimes[index+1] intValue]) {
        case 3:
            barrel.opacity = 1.0f;
            break;
        case 2:
            barrel.opacity = 0.8f;
            break;
        case 1:
            barrel.opacity = 0.5f;
            break;
        case 0:
            //kill
            [barrel removeFromParent];
            [activeBarrelLifetimes removeObject:[activeBarrelLifetimes objectAtIndex:index+1]];
            [activeBarrelLifetimes removeObject:[activeBarrelLifetimes objectAtIndex:index]];
            break;
    }

}

+ (void) vomitCheck: (CCNode*) activeVomits : (NSMutableArray*) activeVomitLifetimes : (NSTimeInterval) currTime :
    (CCSprite*) dave : (CCSprite*) huey : (CCSprite*) princess {
    
    NSArray* allVomits = activeVomits.children;
    for(int i = 0; i < allVomits.count; i++) {
        
        //check if vomit duration is up
        double bt = [[activeVomitLifetimes objectAtIndex:i] doubleValue];
        
        if((currTime - bt) < VOMIT_LIFE) {
            [activeVomits removeChild:allVomits[i]];
            //Network
            [NetworkManager sendDeActivateItemsToServer:@"Vomit" iPosition:CGPointZero playerInfo:@"dave" iIndex:[NSString stringWithFormat:@"%i", i]];

            [activeVomitLifetimes removeObject:[activeVomitLifetimes objectAtIndex:i]];
            break;
        }
        
        //check against players and princess and apply acceleration effect
        //CCLOG(@"\n\n%f, %f",[allVomits[i] boundingBox].origin.x,[allVomits[i] boundingBox].origin.y);
        //CCLOG(@"\n\n%f, %f",davePos.x,davePos.y);
        if(CGRectContainsPoint([allVomits[i] boundingBox], dave.position)) {
            //CCLOG(@"\n\nvomit all up");
            dave.physicsBody.velocity = ccpMult(dave.physicsBody.velocity, VOMIT_MULTIPLIER);
        }
        if(CGRectContainsPoint([allVomits[i] boundingBox], huey.position)) {
            //CCLOG(@"\n\nvomit all up");
            huey.physicsBody.velocity = ccpMult(huey.physicsBody.velocity, VOMIT_MULTIPLIER);
        }
        if(CGRectContainsPoint([allVomits[i] boundingBox], princess.position)) {
            princess.physicsBody.velocity = ccpMult(princess.physicsBody.velocity, VOMIT_MULTIPLIER);
        }
    }
}




@end
