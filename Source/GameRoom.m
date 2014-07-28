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
    CCLabelTTF *_lblUpdate;
    NSString* chosenRoomId;
    NSString* chosenRoomName;
    NSMutableArray *labels;
    NSMutableArray *buttons;
    BOOL newScreen;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    
    [[WarpClient getInstance] leaveRoom: [GameVariables getCurrentRoom]];
    
    //reset selected items
    [GameVariables setItemIndex1:-1];
    [GameVariables setItemIndex2:-1];
    
    [self initiateRoomLoad];
    
    labels = [[NSMutableArray alloc] init];
    buttons = [[NSMutableArray alloc] init];
    
    for (int i=0; i<5; i++)
    {
        
        CCLabelTTF *lblRoomId ;
        
        lblRoomId = [CCLabelTTF labelWithString: @"" fontName:@"Helvetica" fontSize:15   ];
        [lblRoomId setHorizontalAlignment:CCTextAlignmentLeft ];
        lblRoomId.position = ccp(80, 250 - ( (i+1) * 35));
        lblRoomId.anchorPoint = ccp(0,0.5);
        [labels addObject:lblRoomId];
        
        // create a join button if first time checking for rooms
        CCSprite *sprite = [CCSprite spriteWithImageNamed:@"ccbResources/ccbButtonNormal.png"];
        CCButton *btnJoin = [CCButton buttonWithTitle:@"Join room"  spriteFrame:sprite.spriteFrame ];
        [btnJoin setTarget:self selector:@selector(joinRoom:) ];
        btnJoin.position = ccp(410, 250 -( (i+1) * 35));
        btnJoin.preferredSize = CGSizeMake(100.0, 30.0);
        btnJoin.anchorPoint = ccp(0,0.5);
        [buttons addObject:btnJoin];

        
    }
    
    //decides if to add labels and buttons to screen or jsut update labels
    newScreen = YES;
}


- (void) initiateRoomLoad
{
    
    [GameVariables setCurrentScene:@"GameRoom"];
    
    
    NSMutableArray* allrooms = [GameVariables RoomInfoList];
    [allrooms  removeAllObjects];
    
    NSMutableArray* allroomsids = [GameVariables RoomList];
    [allroomsids  removeAllObjects];
    
    // we need a fresh copy of room info
    [[WarpClient getInstance] getAllRooms];
    
    //callback for room list request status
    [self schedule:@selector(roomListMonitor:) interval:1] ;
}

//get list of room ids
-(void) roomListMonitor:(CCTime)delta
{
    
    int countt = [[GameVariables RoomList] count];
    if (countt == 5)
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
-(void) printRooms:(CCTime)delta
{
    
    NSMutableArray *array = [GameVariables RoomInfoList];
    int countt = array.count;
        if (countt == 5)
        {
            
            _lblUpdate.visible = NO;
    
            int roomCount = 1; //for positioning label
    
            for (RemoteRoomData *room in [GameVariables RoomInfoList])
            {
                    
                    CCLabelTTF *lblRoomId ;
                    CCButton    *btnJoin;
                    NSString* roomStatus = @" (empty)";
                    
                    if (room.roomOccupants.count == 1)
                        roomStatus = @" (player waiting)";
                    else if  (room.roomOccupants.count == 2)
                        roomStatus = @" (full room)";
                    
        
                    // Create a label for display purposes
                    lblRoomId = labels[roomCount-1];
                    lblRoomId.string = [room.roomName stringByAppendingString:  roomStatus];
                
                    //create button for joining room
                    btnJoin = buttons[roomCount-1];
                    NSString* btnMessage = [[room.roomId stringByAppendingString:@"-"] stringByAppendingString:room.roomName ];
                    CCLOG(@"%@", btnMessage);
                    btnJoin.name = btnMessage;
                
                    if (room.roomOccupants.count == 2){
                        btnJoin.enabled = NO;
                    }
                    else{
                        btnJoin.enabled = YES;
                    }
                
                    if ( newScreen )
                    {
                        //add views to scene if first time checking for rooms
                        [self addChild:lblRoomId];
                        [self addChild:btnJoin];
                    }
                
                
                    roomCount++;
            }
            
            newScreen =NO;
            
            [self schedule:@selector(updateRoomList:) interval: ROOM_REFRESH] ;
            [self unschedule:@selector(printRooms:)];
            
    
        }
    
}

//load detailed room info into screen after rooms have loaded
-(void) updateRoomList:(CCTime)delta
{
    [self initiateRoomLoad];
    [self unschedule:@selector(updateRoomList:)];
}


//button action to join room
- (void)joinRoom:(id)sender {
    
    CCButton *_sender = (CCButton*) sender;
    
    NSArray *_split = [_sender.name componentsSeparatedByString:@"-"];
    chosenRoomId = _split[0];
    chosenRoomName = _split[1];
    //int roomJoinPosition  = [GameVariables getNoOfRoomOccupants:chosenRoomId] + 1;
    //[GameVariables : roomJoinPosition ];
    
    //[GameVariables setRoomPosition: roomJoinPosition];
    
    //CCLOG(@"roomPosition = %i", [GameVariables getRoomPosition]);
    
    [[WarpClient getInstance]joinRoom: chosenRoomId];
    
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
        
        CCLOG(@"%@", chosenRoomName);
        [GameVariables setCurrentRoom: chosenRoomId];
        [GameVariables setCurrentRoomName: chosenRoomName];
        
        CCScene *itemShopScene = [CCBReader loadAsScene:@"ItemShop"];
        [[CCDirector sharedDirector] replaceScene:itemShopScene];
        
    }
    else if ([status isEqualToString: @"error"]) {
        
        [GameVariables setRoomPosition:-1];
        //roomPosition = -1;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"We're really sorry."
                                                       message: @"There was a problem joining the room.\n"
                                                      delegate: self
                                             cancelButtonTitle:@"Try again"
                                             otherButtonTitles:nil,nil];
        
        [alert show];
        
        
        [self unschedule:@selector(roomJoinMonitor:)];

    }
    
}


- (void)goBack {
    
    [[WarpClient getInstance] leaveRoom: [GameVariables getCurrentRoom]];
    
    CCScene *gameRoomScene = [CCBReader loadAsScene:@"SplashScreen"];
    [[CCDirector sharedDirector] replaceScene:gameRoomScene];
}


@end
