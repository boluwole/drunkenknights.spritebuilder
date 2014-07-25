//
//  NetworkManager.h
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "NFStoryBoardManager.h"
#import "MainScene.h"
#import "ManagerIncludes.h"
#import "ItemShop.h"

@interface NetworkManager : CCNode {
    
}

+ (void) sendGameStart:(NSString *)info;
+ (void) receiveGameStart:(NSString *)info;
+ (void) sendNameToServer:(NSString*)name;
+ (void) sendCGPointToServer:(CGPoint) msg;
+ (void) receiveCGPointFromServer:(CGPoint) msg;
//Movement
+ (void) sendEveryPositionToServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP :(NSString*)zH : (NSString*)zD : (NSString*) zP : (NSString*) fallingH : (NSString*) fallingD :(CGPoint) velocityH :(CGPoint) velocityD;
+ (void) receiveEveryPositionFromServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP :(NSString*)zH : (NSString*)zD : (NSString*) zP : (NSString*) fallingH : (NSString*) fallingD :(CGPoint) velocityH :(CGPoint) velocityD;

//receive opponent's name
+ (void) updateNameFromServer : (NSString*) name;


//Item Pickup Kill
+ (void) sendItemToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition;
//+ (void) receiveItemFromServer:(NSString *)itemName iPosition:(CGPoint)itemPosition;


+ (void) updateItemsFromServer:(CGPoint) msg name: (NSString*) name;
//---Item Info---
+ (void) sendItemInfoMsgToServer:(NSString *)info;
+ (void) updateItemInfoFromServer: (NSString*)msg;



+ (void) sendActivatedToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition player:(NSString*) player;
+ (void) activateItemsFromServer:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString*) player;

+ (void) sendDeActivateItemsToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString*) player iIndex:(NSString*) index;
+ (void) deActivateItemsFromServer:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString*) player iIndex:(NSString*) index;

//+ (void) sendItemSlimeKillMsgToServer:(NSString *)index;
//+ (void) killActivateSlime: (NSString *)SlimeIndex;
//sound stuff
+ (void) sendSound:(NSString*) name;
+ (void) updateMainSceneSound:(NSString*) name;
//update drunkness for bubble
+ (void) updateDaveDrunkIndex:(NSString*) index;
+ (void) updateHueyDrunkIndex:(NSString*) index;
+ (void) sendDaveDrunknessToServer:(NSString *)daveDrunkIndex;
+ (void) sendHueyDrunknessToServer:(NSString *)hueyDrunkIndex;

@end
