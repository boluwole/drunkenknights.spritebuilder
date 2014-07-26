//
//  GameVariables.m
//  DrunkenKNights
//
//  Created by Student on 6/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameVariables.h"

@implementation GameVariables


static int itemIndex1 = 0;
static int itemIndex2 = 0;
static NSString* initConnectionStatus ;
static NSString* roomJoinSuccess;
static NSString* currentRoom;
static int roomPosition=0;
static NSString* currentScene;
static NSString* playername;
static NSString* decidePlayer;
static NSString* currentRoomName;


+(void) setDPlayerName: (NSString*) inputName
{
    decidePlayer = inputName;
}

+(NSString*) getDPlayerName
{
    return decidePlayer;
}


+(void) setCurrentRoomName: (NSString*) input
{
    currentRoomName = input;
}

+(NSString*) getCurrentRoomName
{
    return currentRoomName;
}


+ (void) setPlayerName: (NSString*) inputName
{
    playername = inputName;
}

+(NSString*) getPlayerName
{
    return playername;
}

+(void) setCurrentScene: (NSString*) sceneName {
    currentScene = sceneName;
}
+(NSString*) getCurrentScene {
    return currentScene;
}

+(int) getItemIndex1
{
    return itemIndex1;
}

+(void) setItemIndex1 : (int) value
{
    itemIndex1 = value;
}

+(int) getItemIndex2
{
    return itemIndex2;
}

+(void) setItemIndex2 : (int) value
{
    itemIndex2 = value;
}

+(NSString*) getInitConnectionStatus
{
    return initConnectionStatus;
}

+(void) setInitConnectionStatus : (NSString*) value
{
    initConnectionStatus = value;
}


+(NSString*) getJoinRoomSuccess
{
    return roomJoinSuccess;
}

+(void) setJoinRoomSuccess : (NSString*) value
{
    roomJoinSuccess = value;
}


+(NSString*) getCurrentRoom
{
    return currentRoom;
}

+(void) setCurrentRoom : (NSString*) value
{
    currentRoom = value;
}


+(NSMutableArray*) RoomList
{
    static NSMutableArray* theArray = nil;
    if (theArray == nil)
    {
        theArray = [[NSMutableArray alloc] init];
    }
    return theArray;
}

+(NSMutableArray*) RoomInfoList
{
    static NSMutableArray* theArray = nil;
    if (theArray == nil)
    {
        theArray = [[NSMutableArray alloc] init];
    }
    return theArray;
}

+(int) getNoOfRoomOccupants:(NSString *)roomId
{
    NSMutableArray *allRooms = [GameVariables RoomInfoList];
    
    if ([allRooms count ] > 0)
    {
        for (RemoteRoomData *room in allRooms)
        {
            if ([room.roomId isEqualToString: roomId] )
            {
                return room.roomOccupants.count;
                break;
            }
        }
    }
    
    return  -1;
}

+(int) getRoomPosition
{
    return roomPosition;
}

+(void) setRoomPosition:(int)value
{
    roomPosition = value;
}

@end
