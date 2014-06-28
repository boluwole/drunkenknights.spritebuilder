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

@interface NetworkManager : CCNode {
    
}

+ (void) sendRandomNum:(NSString *)num;
+ (void) receieRandomNum:(NSString *)num;


+ (void) sendCGPointToServer:(CGPoint) msg;
+ (void) receiveCGPointFromServer:(CGPoint) msg;
//Movement
+ (void) sendEveryPositionToServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP;
+ (void) receiveEveryPositionFromServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP;


//Item Pickup Kill
+ (void) sendItemToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition;
//+ (void) receiveItemFromServer:(NSString *)itemName iPosition:(CGPoint)itemPosition;


+ (void) updateItemsFromServer:(CGPoint) msg name: (NSString*) name;
//---Item Info---
+ (void) sendItemInfoMsgToServer:(NSString *)info;
+ (void) updateItemInfoFromServer: (NSString*)msg;






+ (void) sendDaveActivatedToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition;
+ (void) sendHueyActivatedToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition;

+ (void) sendActivatedToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition player:(NSString*) player;
+ (void) activateItemsFromServer:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString*) player;

+ (void) sendItemVomitKillMsgToServer:(NSString *)index;
+ (void) killActivateVomit: (NSString *)vomitIndex;



@end
