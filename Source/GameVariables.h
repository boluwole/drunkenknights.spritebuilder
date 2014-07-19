//
//  GameVariables.h
//  DrunkenKNights
//
//  Created by Student on 6/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteRoomData.h"
@interface GameVariables : NSObject

//@property int roomPosition;

+(int) getItemIndex1;
+(int) getItemIndex2;
+(NSString*) getCurrentRoomName;
+(NSString*) getJoinRoomSuccess;
+(NSString*) getInitConnectionStatus;
+(NSString*) getCurrentRoom;
+(NSMutableArray*) RoomList;
+(NSMutableArray*) RoomInfoList;

+ (void) setCurrentRoomName: (NSString*) currentRoom;
+ (void) setPlayerName: (NSString*) inputName;
+ (NSString*) getPlayerName;
+(void) setDPlayerName: (NSString*) inputName;
+(NSString*) getDPlayerName;

+ (int) getRoomPosition;

+ (void) setItemIndex1 :(int) value ;
+ (void) setItemIndex2 :(int) value ;
+ (void) setInitConnectionStatus :(NSString*) value ;
+ (void) setJoinRoomSuccess:(NSString*) value;
+ (void) setCurrentRoom:(NSString*) value;

+ (int) getNoOfRoomOccupants:(NSString*) roomId;
+ (void) setRoomPosition :(int) value;

+(void) setCurrentScene: (NSString*) sceneName;
+(NSString*) getCurrentScene;

@end
