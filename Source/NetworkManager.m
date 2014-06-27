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

+ (void) sendItemToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"item_name",
                          NSStringFromCGPoint(itemPosition), @"item_position", nil];
    //NSLog(@"Item name %@ and position %@", itemName, NSStringFromCGPoint(itemPosition));
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) sendDaveActivatedToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"activateditem_name_dave",
                          NSStringFromCGPoint(itemPosition), @"activateditem_position_dave", nil];
    //CCLOG(@"ActivatedItem name %@ and position %@", itemName, NSStringFromCGPoint(itemPosition));
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) sendHueyActivatedToServer:(NSString *)itemName iPosition:(CGPoint)itemPosition
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"activateditem_name_huey",
                          NSStringFromCGPoint(itemPosition), @"activateditem_position_huey", nil];
    CCLOG(@"ActivatedItem name %@ and position %@", itemName, NSStringFromCGPoint(itemPosition));
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) sendItemInfoMsgToServer:(NSString *)info
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:info, @"item_info", nil];
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}


+ (void) sendItemVomitKillMsgToServer:(NSString *)index
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:index,@"vomit_index_kill", nil];
    CCLOG(@"index = %@", index);
    [[NFStoryBoardManager sharedNFStoryBoardManager] updatePlayerDataToServerWithDataDict:dict];
}

+ (void) killActivateVomit:(NSString *)vomitIndex
{
    if(vomitIndex != nil)
    {
        //[MainScene killVomit:vomitIndex];
    }
    
}


+ (void) updateItemInfoFromServer: (NSString*)msg
{
    [MainScene itemInfo:msg];
}

+ (void) activateItemsFromServer:(NSString *)itemName iPosition:(CGPoint)itemPosition
{
    if(itemName != nil) {
 //       [MainScene activateItems:itemName iPosition:itemPosition];
        //CCLOG(@"msg = %@ , name = %@", NSStringFromCGPoint(msg),name);
    }
}


+ (void) updateItemsFromServer:(CGPoint) msg name: (NSString*) name{
    //CCLOG(@"\n\nI got %f, %f\n\n",msg.x, msg.y);
    //_dave.position = ccp(abs(msg.x),abs(msg.y));
    if(name != nil) {
        //[MainScene updateItems:msg name: name];
    }
    
}
/*
+ (void) activateItemsFromServer:(CGPoint) msg name: (NSString*) name{
    if(name != nil) {
        [MainScene activateItems:msg name: name];
        //CCLOG(@"msg = %@ , name = %@", NSStringFromCGPoint(msg),name);
    }
}
*/
    
//+ (void) updateItemInfoFromServer: (NSString*) msg{
//    [MainScene killItem:msg];
//}






@end
