//
//  ItemShop.m
//  DrunkenKNights
//
//  Created by Apple User on 6/14/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "ItemShop.h"
#import "GameItemData.h"
#import "GameItem.h"


@implementation ItemShop
{
    CCButton* _btnStartGame;
    CCSprite* _itemImage;
    CCLabelTTF* _itemName;
    CCLabelTTF* _itemDescription;
    int _currentItem;
    int _item1Index;
    int _item2Index;
    
    CCSprite* animatedItem;
    CCSprite* _item1;
    CCSprite* _item2;
    
    BOOL buyItem;
    
    
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    _currentItem = 0;
    
    //load first game item
    [self loadItem: _currentItem : _itemImage];
    
    //load game item images into memory
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"assets.plist"];
    
    //load animation item
    animatedItem = [[CCSprite alloc] init];
    [self addChild:animatedItem];
    animatedItem.scale *= 0.5;
    [animatedItem setOpacity: 0.5];
    
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    
    //markers to show that we have not selected an item
    _item1Index = -1;
    _item2Index = -1;
}


//monitor selection of items to display 'start game' button
- (void)update:(CCTime)delta {
    
    //check if we have two items selected.
    if (_item1Index != -1 && _item2Index != -1 )
    {
        [_btnStartGame setVisible: YES];
    }
    else
    {
        [_btnStartGame setVisible: NO];
    }
}



//TOUCH STUFF

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    //in case item in shopping window (buy)
    if (CGRectContainsPoint([_itemImage boundingBox], touchLocation))
    {
        buyItem = YES;
        
        [animatedItem setVisible: YES];
        
        [self loadItem : _currentItem : animatedItem];
    }
    
}


- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    if (buyItem)
    {
        //move animation
        animatedItem.position = touchLocation;
        
    }
    
}


-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    //animatedItem = [[CCSprite alloc] init];
    
    if (buyItem)
    {
        
        //if it enters item1 circle, release touch
        if (CGRectIntersectsRect([_item1 boundingBox], [animatedItem boundingBox]))
        {
            if (_item1Index !=  _currentItem)
            {
                buyItem = NO;
                
                
                [animatedItem setVisible: NO];
                [self loadItem : _currentItem : _item1];
                
                if (_item1Index == -1) //don't scale if already scaled
                    _item1.scale *= 0.5;
                
                _item1Index = _currentItem;
                [GameVariables setItemIndex1:_currentItem];
            }
            
        }
        //if it enters item2 circle, release touch
        else if (CGRectIntersectsRect([_item2 boundingBox], [animatedItem boundingBox]))
        {
            if (_item2Index !=  _currentItem)
            {
                buyItem = NO;
                
                [animatedItem setVisible: NO];
                [self loadItem : _currentItem : _item2];
                
                if (_item2Index == -1) //don't scale if already scaled
                    _item2.scale *= 0.5;
                
                _item2Index = _currentItem;
                [GameVariables setItemIndex2:_currentItem];
            }
        }
    }
    
    
    [animatedItem setPosition: ccp(-100,-100)];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    [animatedItem setVisible: NO];
    [animatedItem setPosition: ccp(-100,-100)];
    //[animatedItem setPosition: _itemImage.position];
}


- (void) loadItem : (int) itemIndex : (CCSprite*) loadableItem
{
    //get item from static class and load data into UI screen
    GameItemData* currentItem = [[GameItem getGameItems] objectAtIndex: itemIndex];
    [loadableItem setSpriteFrame:[CCSpriteFrame frameWithImageNamed: currentItem.itemImage]];
    
    _itemName.string = currentItem.itemName;
    _itemDescription.string =  currentItem.itemDescription;
    
}


- (void)startGame {

    //steps
    //check that there are two people in room
    //first remove all rooms
    NSMutableArray* allrooms = [GameVariables RoomInfoList];
    [allrooms  removeAllObjects];
    
    
    NSString* roomSelected= [GameVariables getCurrentRoom];
    [[WarpClient getInstance] getLiveRoomInfo:roomSelected];
    
    //check if player in room
    [self schedule:@selector(checkRoomUpdate:) interval:1] ;
}


-(void) checkRoomUpdate:(CCTime)delta
{
    NSMutableArray *allRooms = [GameVariables RoomInfoList];
    
    if ([allRooms count] == 1)
    {
        RemoteRoomData *room = [allRooms objectAtIndex:0];
        int noOfPlayers =  room.roomOccupants.count;
        
        if (noOfPlayers == 1)
        {
            //startgame
            CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
            [[CCDirector sharedDirector] replaceScene:mainScene];
        }
        else{
            //ask to wait or leave to game room
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Hold your horses!"
                                                           message: @"Still waiting for an opponent.\n"
                                                          delegate: self
                                                 cancelButtonTitle:@"Wait"
                                                 otherButtonTitles:@"Game room",nil];
            [alert show];
        }
        
        
        [self unschedule:@selector(checkRoomUpdate:)];
    }
}


//delegate for alert on click start button
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    if (buttonIndex == 1){
        
        [[WarpClient getInstance] leaveRoom: [GameVariables getCurrentRoom]];
        
        
        NSMutableArray* allrooms = [GameVariables RoomInfoList];
        [allrooms  removeAllObjects];
        
        NSMutableArray* allroomsids = [GameVariables RoomList];
        [allroomsids  removeAllObjects];
        
        //just in case we decide to go back, we need a fresh copy of room info
        [[WarpClient getInstance] getAllRooms];
        
        //reset selected items
        [GameVariables setItemIndex1:-1];
        [GameVariables setItemIndex2:-1];
        
        //gameroom
        CCScene *gameRoomScene = [CCBReader loadAsScene:@"GameRoom"];
        [[CCDirector sharedDirector] replaceScene:gameRoomScene];
    }
}


- (void)skipLeft {
    if (_currentItem >0)
    {
        _currentItem--;
        [self loadItem: _currentItem : _itemImage];
    }
    
}

- (void)skipRight{
    
    NSArray* itemArray = [GameItem getGameItems] ;
    NSInteger itemCacheCount = [itemArray count];
     if (_currentItem < itemCacheCount - 1)
     {
         _currentItem++;
         [self loadItem: _currentItem : _itemImage];
     }
}

@end
