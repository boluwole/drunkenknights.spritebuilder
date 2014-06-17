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


@end
