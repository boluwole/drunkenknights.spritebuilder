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

+ (void) sendEveryPositionToServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP;
+ (void) receiveEveryPositionFromServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP;

+ (void) sendItemToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition;
+ (void) sendItemInfoMsgToServer:(NSString *)info;
+ (void) sendActivatedToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition;
+ (void) updateItemInfoFromServer: (NSString*)msg;
+ (void) activateItemsFromServer:(NSString *)itemName iPosition:(CGPoint)itemPosition;

+ (void) sendItemVomitKillMsgToServer:(NSString *)index;



@end
