//
//  GameRoom.m
//  DrunkenKNights
//
//  Created by Apple User on 6/22/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameRoom.h"


@implementation GameRoom
{
    NSMutableArray *rooms;
    int networkTimeLimit;
    CCLabelTTF *_lblUpdate;
    NSString* chosenRoomName;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    
    //get rooms (already done after connection)
    //[[WarpClient getInstance] getAllRooms];
    
    //callback for room list request status
    [self schedule:@selector(roomListMonitor:) interval:1] ;
    
}

//get list of room ids
-(void) roomListMonitor:(CCTime)delta
{
    if ([[GameVariables RoomList] count] == 5)
    {
        rooms = [GameVariables RoomList];
        [self loadRooms];
        
        [self unschedule:@selector(roomListMonitor:)];
    }
}

//get details from room ids
-(void) loadRooms
{
    //callback adds room info to an array in game variables
    for (NSString* roomId in rooms)
    {
        [[WarpClient getInstance] getLiveRoomInfo:roomId];
    }
    
    [self schedule:@selector(printRooms:) interval:1] ;
}


//load detailed room info into screen after rooms have loaded
//stop after 3 seconds
-(void) printRooms:(CCTime)delta
{
    NSMutableArray *array = [GameVariables RoomInfoList];
    
        if (array.count == 5)
        {
    
            _lblUpdate.visible = NO;
    
            int roomCount = 1; //for positioning label
    
            for (RemoteRoomData *room in [GameVariables RoomInfoList])
            {
                    
                    CCLabelTTF *lblRoomId ;
                    NSString* roomStatus = @" (empty)";
                    
                    if (room.roomOccupants.count == 1)
                        roomStatus = @" (player waiting)";
                    else if  (room.roomOccupants.count == 2)
                        roomStatus = @" (full room)";
                    
        
                    // Create a label for display purposes
                    lblRoomId = [CCLabelTTF labelWithString: [room.roomName.uppercaseString stringByAppendingString: roomStatus]
                                                   fontName:@"Helvetica" fontSize:12   ];
                    [lblRoomId setHorizontalAlignment:CCTextAlignmentLeft ];
                    lblRoomId.position = ccp(100, 230 - ( roomCount * 25));
                    lblRoomId.anchorPoint = ccp(0,0.5);
                    [self addChild:lblRoomId];
        
                    // Standard method to create a
                    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"ccbResources/ccbButtonNormal.png"];
                    CCButton *btnJoin = [CCButton buttonWithTitle:@"Join room"  spriteFrame:sprite.spriteFrame ];
                    [btnJoin setTarget:self selector:@selector(joinRoom:) ];
                    btnJoin.position = ccp(370, 230 -( roomCount * 25));
                    btnJoin.preferredSize = CGSizeMake(100.0, 20.0);
                    btnJoin.anchorPoint = ccp(0,0.5);
                    btnJoin.name = room.roomId;
                
                    if (room.roomOccupants.count == 2){
                        btnJoin.enabled = NO;
                    }
                
                    [self addChild:btnJoin];
                
                    roomCount++;
            }
            
    
            [self unschedule:@selector(printRooms:)];
    
        }
    
    networkTimeLimit++;
}

//button action to join room
- (void)joinRoom:(id)sender {
    
    CCButton *_sender = (CCButton*) sender;
    
    chosenRoomName = _sender.name;
    
    [[WarpClient getInstance]joinRoom: chosenRoomName];
    
    [GameVariables setJoinRoomSuccess:@"joining"];
    
    [self schedule:@selector(roomJoinMonitor:) interval:1] ;
}


//check if we were able to join room
-(void) roomJoinMonitor: (CCTime) delta
{
    NSString* status = [GameVariables getJoinRoomSuccess];
    
    if ( [status isEqualToString: @"joined"])
    {
        
        [self unschedule:@selector(roomJoinMonitor:)];
        
        CCScene *itemShopScene = [CCBReader loadAsScene:@"ItemShop"];
        [[CCDirector sharedDirector] replaceScene:itemShopScene];
        
        [GameVariables setCurrentRoom: chosenRoomName];
        
    }
    else if ([status isEqualToString: @"error"]) {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"We're really sorry."
                                                       message: @"There was a problem joining the room.\n"
                                                      delegate: self
                                             cancelButtonTitle:@"Try again"
                                             otherButtonTitles:nil,nil];
        
        [alert show];
        
        [self unschedule:@selector(roomJoinMonitor:)];

    }
    
}

@end