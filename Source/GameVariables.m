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
<<<<<<< HEAD
static NSString* roomJoinSuccess;
static NSString* currentRoom;

=======
>>>>>>> 6f8224727a407b2e8ba232bb9d8980c5ae6f16d9

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

<<<<<<< HEAD

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


=======
>>>>>>> 6f8224727a407b2e8ba232bb9d8980c5ae6f16d9
@end
