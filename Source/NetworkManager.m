//
//  NetworkManager.m
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "NetworkManager.h"


@implementation NetworkManager {

}

+ (void) sendGameStart:(NSString *)info
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:info, @"game_start", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) receiveGameStart:(NSString *)info
{
    if(info)
    [ItemShop enterMainScene:info];
}

+ (void) sendNameToServer:(NSString*)name
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:name, @"opponent_name", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}



+ (void) sendCGPointToServer:(CGPoint) msg {
    //CCLOG(@"\n\nSending %f, %f\n\n",msg.x,msg.y);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NSStringFromCGPoint(msg), @"impulse", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) receiveCGPointFromServer:(CGPoint) msg {
    //CCLOG(@"\n\nI got %f, %f\n\n",msg.x, msg.y);
    //_dave.position = ccp(abs(msg.x),abs(msg.y));
    
   // if([MainScene returnDave] == nil) CCLOG(@"\n\n dave is nil\n\n");
    //if([MainScene returnHuey] == nil) CCLOG(@"\n\n huey is nil\n\n");
    
    
    if(msg.x == msg.x && msg.y == msg.y && [MainScene returnHuey] != nil && [MainScene returnDave] != nil)
    [MainScene updateOpponent:msg];
}

+ (void) sendEveryPositionToServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP :(NSString*)zH : (NSString*)zD : (NSString*) zP :(NSString*) fallingH :(NSString*) fallingD :(CGPoint) velocityH :(CGPoint) velocityD
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NSStringFromCGPoint(msgH), @"position_huey",
                          NSStringFromCGPoint(msgD), @"position_dave",
                          NSStringFromCGPoint(msgP), @"position_princess",
                          zH, @"zorder_huey",
                          zD, @"zorder_dave",
                          zP, @"zorder_princess",
                          fallingH, @"falling_huey",
                          fallingD, @"falling_dave",
                          NSStringFromCGPoint(velocityD), @"velocity_dave",
                          NSStringFromCGPoint(velocityH), @"velocity_huey",
                          nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) receiveEveryPositionFromServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP :(NSString*)zH : (NSString*)zD : (NSString*) zP :(NSString*) fallingH :(NSString*) fallingD :(CGPoint) velocityH :(CGPoint) velocityD
{
    //CCLOG(@"\n\n\nVELOCITY_H: %f, %f",velocityH.x,velocityH.y);
    [MainScene updateEveryPosition:msgH positionDave:msgD positionPrincess:msgP :zH :zD :zP :fallingH :fallingD :velocityH :velocityD];
}

+ (void) updateNameFromServer : (NSString*) name
{
    [ItemShop checkOpponentName:name];
}



+ (void) sendItemInfoMsgToServer:(NSString *)info
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:info, @"item_info", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}


+ (void) sendItemToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"item_name",
                          NSStringFromCGPoint(itemPosition), @"item_position", nil];
    //NSLog(@"Item name %@ and position %@", itemName, NSStringFromCGPoint(itemPosition));
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}



//---Activated Item---Sending---
+ (void) sendActivatedToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition player:(NSString*) player
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"activateditem_name",
                          NSStringFromCGPoint(itemPosition), @"activateditem_position",
                          player, @"player_info",  nil];
    CCLOG(@"ActivatedItem name %@ and position %@", itemName, NSStringFromCGPoint(itemPosition));
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];

}


//---Item Activated---Update----
+ (void) activateItemsFromServer:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString *)player
{
    if(itemName != nil) {
        [MainScene activateItems:itemName iPosition:itemPosition playerInfo: player];
    }
}



+ (void) sendDeActivateItemsToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString*) player iIndex:(NSString*) index
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"deActivatedItem_name",
                                            NSStringFromCGPoint(itemPosition), @"deActivatedItem_position",
                                            player, @"deplayer_info",
                                            index, @"index_info", nil];
    //NSLog(@"Item name %@ and position %@", itemName, NSStringFromCGPoint(itemPosition));
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];

}



+ (void) deActivateItemsFromServer:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString*) player iIndex:(NSString*) index
{
    if(itemName != nil && index != nil)
    {
        
        [MainScene deActivateItem:itemName iPosition:itemPosition playerInfo:player iIndex:index];
    }

}


//item events
+ (void) updateItemInfoFromServer: (NSString*)msg
{
    [MainScene itemInfo:msg];
}



//item dropping
+ (void) updateItemsFromServer:(CGPoint) msg name: (NSString*) name
{
    if(name != nil) {
        [MainScene updateItems:msg name: name];
    }
    
}

//send sounds

+ (void) sendSound:(NSString*) name
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"sounds", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) updateMainSceneSound:(NSString*) name {
    [MainScene playSound:name];

}
//update drunkness index
+ (void) updateDaveDrunkIndex:(NSString*) index {
    [MainScene updateDaveDrunkIndex:index];
}
+ (void) updateHueyDrunkIndex:(NSString *)index{
    [MainScene updateHueyDrunkIndex:index];
}

+ (void) sendDaveDrunknessToServer:(NSString *)daveDrunkIndex
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:daveDrunkIndex, @"dave_drunkness", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) sendHueyDrunknessToServer:(NSString *)hueyDrunkIndex
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:hueyDrunkIndex,@"huey_drunkness", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}


@end
