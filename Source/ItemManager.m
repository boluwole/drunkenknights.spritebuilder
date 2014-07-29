//
//  ItemManager.m
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "ItemManager.h"


@implementation ItemManager


static bool daveSlime=YES;
static bool hueySlime=YES;
static bool princessSlime=YES;

//return index of beer bottle that needs to start a respawn counter, -1 if none
+ (int) checkBeerBottles : (CCSprite*) dave :(CCSprite*) huey :(BOOL) daveFalling :(BOOL) hueyFalling :(float*) daveDrunkLevel :(float*) hueyDrunkLevel :(__strong CCNode*[]) beerNodes {
    
    for(int i = 0; i < NUM_BEER_NODES; i++) {
        
        NSArray* child = beerNodes[i].children;
        
        if(child.count > 0) {
            if(CGRectContainsPoint([dave boundingBox], beerNodes[i].position) && (*daveDrunkLevel) < DRUNK_METER_CAP && !daveFalling) {
                
                CCNode* temp = (CCNode*)child[0];
                
                if([temp.name isEqualToString:@"BeerWheel"]) return -1;
                
                OALSimpleAudio *aud2=[OALSimpleAudio    sharedInstance];
                [aud2 playEffect:@"Beer.wav"];
                (*daveDrunkLevel)+=10;

                
                [temp removeFromParentAndCleanup:YES];
                //temp = nil;
                temp = [CCBReader load:@"BeerWheel"];
                temp.opacity = 0.8;
                temp.scale = 0.2;
                [beerNodes[i] addChild:temp];
                
                //TODO: network index i to Huey to kill child of beerNode[i]
                // & and set beerNodesCounters[i] to 0
                [NetworkManager sendDeActivateItemsToServer:@"Beer" iPosition:beerNodes[i].position playerInfo:@"DAVE" iIndex:[NSString stringWithFormat:@"%i",i]];
                
                return i;
            }
            else if(CGRectContainsPoint([huey boundingBox], beerNodes[i].position) && (*hueyDrunkLevel) < DRUNK_METER_CAP && !hueyFalling) {
                
                CCNode* temp = (CCNode*)child[0];
                
                if([temp.name isEqualToString:@"BeerWheel"]) return -1;
                
                //(*hueyDrunkLevel)+=10;
                OALSimpleAudio *aud2=[OALSimpleAudio    sharedInstance];
                [aud2 playEffect:@"Beer.wav"];
                
                [temp removeFromParentAndCleanup:YES];
                temp = [CCBReader load:@"BeerWheel"];
                temp.opacity = 0.8;
                temp.scale = 0.2;
                [beerNodes[i] addChild:temp];

                
                //TODO: network index i to Huey to kill child of beerNode[i]
                // & and set beerNodesCounters[i] to 0
                // & network hueyDrunkLevel to update _hueyDrunkLevel on his side
                [NetworkManager sendDeActivateItemsToServer:@"Beer"
                                                  iPosition:beerNodes[i].position
                                                 playerInfo:[NSString stringWithFormat:@"%f", *hueyDrunkLevel]
                                                     iIndex:[NSString stringWithFormat:@"%i", i]];
                return i;
            }
        }
        
    }
    
    return -1;
    
}

+ (CCNode*)dropItem {
    
    //randomly choose a type of item to drop
    CCNode* item;
    OALSimpleAudio *itemsSound=[OALSimpleAudio sharedInstance];
    [itemsSound playEffect:@"Item_PickUp.mp3"];
    int randomNum = arc4random() % 3;
    //CCLOG(@"\n\n RAND = %d \n\n", randomNum);
    switch(randomNum) {
        case BARREL:
            item = [CCBReader load:@"BoxBarrel"];
            break;
            
        case SLIME:
            item = [CCBReader load:@"BoxSlime"];
            break;
            
        case GHOST:
            item = [CCBReader load: @"BoxGhost"];
            break;
    }
    
    //[_physicsNode addChild:currItem];
    item.scale = 0.3;
    //[item setColor:[CCColor colorWithWhite:0.5 alpha:1.0]];
    item.position = [ItemManager itemDisplay];
    item.physicsBody.collisionMask = @[];
    return item;
    
}

+ (CGPoint)itemDisplay{
    
    //   CCLOG(@"\nReached this method");
    
    CGPoint MidPoint, vToMidPoint, MidPointPerp, result;
    
    MidPoint = ccpMidpoint([MainScene returnDave].position, [MainScene returnHuey].position);
    
    vToMidPoint = ccpSub(MidPoint,[MainScene returnDave].position);
    
    MidPointPerp = (arc4random()%2 == 0) ? ccp(-vToMidPoint.y, vToMidPoint.x) : ccp(vToMidPoint.y, -vToMidPoint.x);
    MidPointPerp = ccpNormalize(MidPointPerp);
    
    result = ccpAdd(MidPoint, ccpMult(MidPointPerp, 50+(arc4random()%50)));
    
    if([PhysicsManager detectFallOff:result :uiimage] == NO) {
        return result;
    }
    else {
        float r = 100;
        float theta = ((arc4random()%6)*(360/6))*PI/180;
        result = ccpAdd(PRINCESS_START,ccp(r*cos(theta),r*sin(theta)));
        return result;
    }
}

+ (void) itemEntersInventory: (CCNode*) item {
    item.physicsBody.collisionMask = @[];
    item.anchorPoint = CGPointZero;
    item.position = CGPointZero;
    item.opacity = 1.0;
}

+ (int) useItem: (__strong CCNode*[]) itemBoxes : (int) index : (int) itemsHeld {
    //[itemBoxes[index] removeAllChildren];
    //shifts inventory items forward

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
    else if([item.name  isEqual: @"Slime"]) {
        
    }
    else if([item.name  isEqual: @"Ghost"]){
        

        
    }
}

//activeBarrelLifetimes is stored as: barrel A, life, barrel B, life, barrel C, life... etc
+ (void) barrelCheck: (CCNode*) barrel : (NSMutableArray*) activeBarrelLifetimes {
    for(int i = 0; i < activeBarrelLifetimes.count; i+=2) {
        if((CCNode*)activeBarrelLifetimes[i] == barrel) {
            activeBarrelLifetimes[i+1] = [NSNumber numberWithInt:([activeBarrelLifetimes[i+1] intValue] - 1)];
            
            [NetworkManager sendDeActivateItemsToServer:@"Barrel" iPosition:ccp([activeBarrelLifetimes[i+1] intValue],0) playerInfo:@"dave" iIndex:[NSString stringWithFormat:@"%i", i]];
            
            [ItemManager barrelUpdate:activeBarrelLifetimes :i :[activeBarrelLifetimes[i+1] intValue]];
            
            break;
        }
    }
}

+ (void) barrelUpdate: (NSMutableArray*) activeBarrelLifetimes : (int) index : (int) life {
    
    //load game item images into memory
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"assets.plist"];
    
    CCSprite* barrel = (CCSprite*) activeBarrelLifetimes[index];
    activeBarrelLifetimes[index+1] = [NSNumber numberWithInt:life];
    
    CCLOG(@"\n\nthis barrel has %d lives left\n\n", [activeBarrelLifetimes[index+1] intValue]);
    
    OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
    [aud1 playEffect:@"Barrel_Hit.wav"];
    switch(life) {
        case 3:
            barrel.opacity = 1.0f;
            break;
        case 2:
            //barrel.opacity = 0.8f;
            [barrel setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Assets/barrel_cracked.png"]];
            break;
        case 1:
            //barrel.opacity = 0.5f;
            [barrel setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Assets/barrel_broken.png"]];
            break;
        case 0:
            //kill
            [barrel removeFromParent];
            [activeBarrelLifetimes removeObject:[activeBarrelLifetimes objectAtIndex:index+1]];
            [activeBarrelLifetimes removeObject:[activeBarrelLifetimes objectAtIndex:index]];
            break;
    }

}

+ (void) SlimeCheck: (CCNode*) activeSlimes : (NSMutableArray*) activeSlimeLifetimes : (NSTimeInterval) currTime :
(CCSprite*) dave : (CCSprite*) huey : (CCSprite*) princess {
    
    NSArray* allSlimes = activeSlimes.children;
    for(int i = 0; i < allSlimes.count; i++) {
        
        //check if Slime duration is up
        double bt = [[activeSlimeLifetimes objectAtIndex:i] doubleValue];
        
        if((currTime - bt) < Slime_LIFE) {
            [activeSlimes removeChild:allSlimes[i]];
            //Network
            [NetworkManager sendDeActivateItemsToServer:@"Slime" iPosition:CGPointZero playerInfo:@"dave" iIndex:[NSString stringWithFormat:@"%i", i]];

            [activeSlimeLifetimes removeObject:[activeSlimeLifetimes objectAtIndex:i]];
            break;
        }
        
        //check against players and princess and apply acceleration effect
        //CCLOG(@"\n\n%f, %f",[allSlimes[i] boundingBox].origin.x,[allSlimes[i] boundingBox].origin.y);
        //CCLOG(@"\n\n%f, %f",davePos.x,davePos.y);
        if(CGRectContainsPoint([allSlimes[i] boundingBox], dave.position)) {
            //CCLOG(@"\n\nSlime all up");
            dave.physicsBody.velocity = ccpMult(dave.physicsBody.velocity, Slime_MULTIPLIER);
            if(daveSlime){
                OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
                [aud1 playEffect:@"Vomit_slip.wav"];
                [NetworkManager sendSound:@"dave_vomit"];
                daveSlime=NO;
            }
        }
        if(CGRectContainsPoint([allSlimes[i] boundingBox], huey.position) ) {
            //CCLOG(@"\n\nSlime all up");
            huey.physicsBody.velocity = ccpMult(huey.physicsBody.velocity, Slime_MULTIPLIER);
            if(hueySlime){
                OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
                [aud1 playEffect:@"Vomit_slip.wav"];
                [NetworkManager sendSound:@"huey_vomit"];
                hueySlime = NO;
            }
        }
        if(CGRectContainsPoint([allSlimes[i] boundingBox], princess.position) && princessSlime) {
            princess.physicsBody.velocity = ccpMult(princess.physicsBody.velocity, Slime_MULTIPLIER);
            if(princessSlime){
                OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
                [aud1 playEffect:@"Vomit_slip.wav"];
                [NetworkManager sendSound:@"princess_vomit"];
                princessSlime=NO;
            }
        }
    }
}


+(bool) returnDaveSlime{
    
    return daveSlime;
    
}

+(bool) returnHueySlime{
    
    return hueySlime;
}

+(bool) returnPrincessSlime{
    
    return princessSlime;
    
}

+(void) setDaveSlime: (bool) ds{
    
    daveSlime=ds;
    
}
+(void) setHueySlime: (bool) hs{
    
    hueySlime=hs;
    
}
+(void) setPrincessSlime: (bool) ps{
    
    princessSlime=ps;
    
}



@end
