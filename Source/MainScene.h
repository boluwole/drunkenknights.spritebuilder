//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "ManagerIncludes.h"
#import "GameItem.h"
#import "GameItemData.h"

#import "AppWarpHelper.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "CCPhysics+ObjectiveChipmunk.h"

@interface MainScene : CCScene <CCPhysicsCollisionDelegate> {
    
    BOOL gameResult;
    
    CCPhysicsNode *_physicsNode;
    CCPhysicsNode *_backPhysicsNode;
    CCPhysicsNode *_temp_PhysicsNode;
    
    
    CCSprite *_stage;
    CCNode *_cd_wheel;
    CCNode *arrow_down;
    CCNode *gong_wheel;
    CCNode *cloud1;
    CCNode *cloud2;
    CCNode *shadow_Dave;
    CCNode *shadow_Huey;
    CCNode *princess_end;
    
    int wheelStartCounter;
    bool startRotation;
    int slimeSound;
    int slimeSoundForDave;
    int magicianCounter;
    int gameStartTime;
    BOOL itemActivate;
    bool magicianAppear;
 
    //UI
    CCNode *itemBox[3];
    CCNode *iBox[3];
    CCNode *arrowNode;
    
    CCNode *drunkMeter;
    
    //network manager

    BOOL validMove;
    BOOL validItemMove;
    
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

    
    //check if falling
    BOOL falling[3];
    
    //ticker for revive
    int reviveCounter[3];
    
    //game timer
    NSDate *startTime;
    NSDate *portalTime;
    NSTimeInterval timeElapsed;
   // NSTimeInterval globalTimeElapsed;
    
    //for items
    BOOL itemHasDroppedForThisPeriod;

    int activatedItemIndex;
    int itemsHeld;
    NSTimeInterval currItemDropTime;

    //for RessStones
    CCNode* daveRess;
    CCNode* hueyRess;
    BOOL checkEnd;
    
    
    //for Gong
    CCNode* gong;
    BOOL gongAccess;
    BOOL gongColorChange;
    NSTimeInterval gongTime;
    int gongCounter;
    
    

    //Ghost
    CCNode* activeGhost;
    CCNode* ghostPrincess;
    int ghostCount;
}

//Update Client Side
+ (void) updateEveryPosition:(CGPoint)msgH positionDave:(CGPoint)msgD positionPrincess:(CGPoint)msgP :(NSString*)zH :(NSString*)zD :(NSString*)zP :(NSString*) fallingH :(NSString*) fallingD :(CGPoint) velocityH :(CGPoint) velocityD;

+ (void) itemInfo:(NSString *) msg;
+ (void) activateItems:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo: (NSString*)player;

+ (void) updateItems:(CGPoint) msg name: (NSString*) name;
+ (void) updateOpponent :(CGPoint) msg;

+ (void) deActivateItem:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString*) player iIndex:(NSString*) index;
+ (void) updateOpponentName:(NSString*)msg;
+ (void) playSound:(NSString*) name;
+(void) updateDaveDrunkIndex:(NSString *)index;
+(void) updateHueyDrunkIndex:(NSString *)index;
+ (CCSprite*) returnDave;
+ (CCSprite*) returnHuey;

//@property (nonatomic, retain) int time;

@end
