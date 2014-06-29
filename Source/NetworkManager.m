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

+ (void) sendRandomNum:(NSString *)num
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:num, @"random_num", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) receieRandomNum:(NSString *)num
{
    
}

+ (void) sendCGPointToServer:(CGPoint) msg {
    //CCLOG(@"\n\nSending %f, %f\n\n",msg.x,msg.y);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NSStringFromCGPoint(msg), @"impulse", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) receiveCGPointFromServer:(CGPoint) msg {
    //CCLOG(@"\n\nI got %f, %f\n\n",msg.x, msg.y);
    //_dave.position = ccp(abs(msg.x),abs(msg.y));
    [MainScene updateOpponent:msg];
}

+ (void) sendEveryPositionToServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NSStringFromCGPoint(msgH), @"position_huey",
                          NSStringFromCGPoint(msgD), @"position_dave",
                          NSStringFromCGPoint(msgP), @"position_princess", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) receiveEveryPositionFromServer:(CGPoint)msgH poitionDave:(CGPoint)msgD poitionPrincess:(CGPoint)msgP
{
    [MainScene updateEveryPosition:msgH positionDave:msgD positionPrincess:msgP];
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




+ (void) sendItemVomitKillMsgToServer:(NSString *)index
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:index,@"vomit_index_kill", nil];
    CCLOG(@"index = %@", index);
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
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





@end
