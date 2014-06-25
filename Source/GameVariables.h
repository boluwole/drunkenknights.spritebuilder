//
//  GameVariables.h
//  DrunkenKNights
//
//  Created by Student on 6/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameVariables : NSObject

+(int) getItemIndex1;
+(int) getItemIndex2;
<<<<<<< HEAD
+(NSString*) getJoinRoomSuccess;
+(NSString*) getInitConnectionStatus;
+(NSString*) getCurrentRoom;
+(NSMutableArray*) RoomList;
+(NSMutableArray*) RoomInfoList;
+ (void) setItemIndex1 :(int) value ;
+ (void) setItemIndex2 :(int) value ;
+ (void) setInitConnectionStatus :(NSString*) value ;
+ (void) setJoinRoomSuccess:(NSString*) value;
+ (void) setCurrentRoom:(NSString*) value;

=======
+(NSString*) getInitConnectionStatus;
+ (void) setItemIndex1 :(int) value ;
+ (void) setItemIndex2 :(int) value ;
+ (void) setInitConnectionStatus :(NSString*) value ;
>>>>>>> 6f8224727a407b2e8ba232bb9d8980c5ae6f16d9
@end
