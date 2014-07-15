//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10ƒ/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"


@implementation MainScene{
    
    
}
static CCPhysicsNode *globalPhysicsNode;
static CCNode* currItem;
static CCNode* activatedItem;
static CCNode* opponentActivatedItem;
static CCNode* activeSlimes;
static CCNode* beerNodes[NUM_BEER_NODES];
static int beerNodesCounters[NUM_BEER_NODES];
static NSMutableArray *activeSlimeLifetimes;
static NSMutableArray *activeBarrelLifetimes;
static bool isFallingHuey;
static int _drunkLevelDave;
static int _drunkLevelHuey;
bool playerCharacterSet;

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    
    globalPhysicsNode = _physicsNode;
    _physicsNode.collisionDelegate = self;
    opponentActivatedItem = nil;
    
    gongColorChange=YES;
    gongAccess=YES;
    gongCounter = 0;
    
    checkEnd=YES;
    //load players & statue
    _dave = (CCSprite*)[CCBReader load:@"_Dave"];
    [_physicsNode addChild:_dave];
    _dave.position = DAVE_START;
    _dave.scale *= 0.25;
    daveStart = _dave.position;
    _drunkLevelDave = 0;
    
    _huey = (CCSprite*)[CCBReader load:@"_Huey"];
    [_physicsNode addChild:_huey];
    _huey.position = HUEY_START;
    _huey.scale *= 0.25;
    hueyStart = _huey.position;
    _drunkLevelHuey = 0;
    
    _princess = (CCSprite*)[CCBReader load:@"Princess"];
    [_physicsNode addChild:_princess];
    _princess.position = PRINCESS_START;
    _princess.scale *= 0.30;
    princessStart = _princess.position;
    
    //decide plyaer is dave or huey based on itemshops update
    if([[GameVariables getDPlayerName] isEqualToString:@"_dave"]){
        _player = _dave;
    }
    else{
        _player = _huey;
    }
    
    
    daveRess = (CCSprite*)[CCBReader load:@"DaveRess"];
    hueyRess = (CCSprite*)[CCBReader load:@"HueyRess"];
    [_physicsNode addChild: daveRess];
    [_physicsNode addChild: hueyRess];
    daveRess.position= DAVE_RESS;
    hueyRess.position= HUEY_RESS;
    daveRess.scale *= 0.4;
    hueyRess.scale *= 0.4;
    
    gong=(CCSprite*)[CCBReader load: @"Gongs"];
    [_physicsNode addChild: gong];
    gong.position= GONG_POSITION;
    gong.scale *= 0.3;
    
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    //uiimage for stage falloff detection
    //intialize stage image for falloff detection
    CCRenderTexture *renderer =
    [CCRenderTexture renderTextureWithWidth:_stage.contentSize.width height:_stage.contentSize.height];
    _stage.anchorPoint = CGPointZero;
    [renderer begin];
    [_stage visit];
    [renderer end];
    uiimage = [renderer getUIImage];
    
    
    //initializations
    validMove = NO;
    validItemMove = NO;
    
    for(int i = DAVE; i < HUEY; i++) {
        falling[i] = NO;
        reviveCounter[i] = 0;
    }
    
    
    
    //UI arrow indicator
    arrowNode = [[CCNode alloc] init];
    arrowNode.visible = NO;
    CCNode *arrow;
    for(int i = 0; i < ARROW_DOTS -1; i++) {
        arrow = [CCBReader load:@"ArrowBody"];
        [arrowNode addChild:arrow];
        arrow.scale *= 0.3;
        arrow.opacity *= 0.5;
    }
    
    
    arrow = [CCBReader load:@"ArrowHead"];
    [arrowNode addChild:arrow];
    arrow.scale *= 1.5;
    arrow.opacity *= 0.5;
    
    [self addChild:arrowNode];
    
    //UI drunk meter
    drunkMeter = [CCBReader load:@"Box"];
    drunkMeter.position = ccp(10, 300);
    drunkMeter.anchorPoint = ccp(0,0.5);
    drunkMeter.scaleY *= 0.1;
    [self addChild:drunkMeter];
    
    //always damp
    [self schedule:@selector(damping:) interval:0.02];
    
    
    //item node
    currItem = [[CCNode alloc] init];
    
    for(int i = 0; i < 3; i++) {
        itemBox[i]=[CCBReader load: @"Box"];
        itemBox[i].scale *= 0.3;
        [_physicsNode addChild:itemBox[i]];
        itemBox[i].position = ccp(INVENTORY_POSITION + INVENTORY_DISTANCE*i,INVENTORY_POSITION);
        itemBox[i].opacity *= 0.6;
        itemBox[i].zOrder = _stage.zOrder + INVENTORY_Z;
    }
    
    itemsHeld = 0;
    
    //initialize original two items
    NSArray* gameItems = [GameItem getGameItems];
    CCNode* tempItem;
    GameItemData *data = [gameItems objectAtIndex:[GameVariables getItemIndex1]];
    tempItem = [CCBReader load:data.itemName];
    [ItemManager itemEntersInventory:tempItem];
    tempItem.zOrder = itemBox[itemsHeld].zOrder - 1;
    [tempItem setColor:[CCColor colorWithWhite:1.0 alpha:1.0]];
    [itemBox[itemsHeld] addChild:tempItem];
    itemsHeld++;
    
    data = [gameItems objectAtIndex:[GameVariables getItemIndex2]];
    tempItem = [CCBReader load:data.itemName];
    [ItemManager itemEntersInventory:tempItem];
    tempItem.zOrder = itemBox[itemsHeld].zOrder - 1;
    [tempItem setColor:[CCColor colorWithWhite:1.0 alpha:1.0]];
    [itemBox[itemsHeld] addChild:tempItem];
    itemsHeld++;
    
    //beer bottles
    for(int i = 0; i < NUM_BEER_NODES; i++) {
        CCNode* beerBottle = [CCBReader load:@"Barrel"];
        beerBottle.scale *= 0.3;
        beerBottle.scaleX *= 0.2;
        beerBottle.rotation -= 25;
        beerNodes[i] = [[CCNode alloc] init];
        beerNodes[i].position = ccpAdd(princessStart, ccp(-120 + i*80,-60));
        [beerNodes[i] addChild:beerBottle];
        beerBottle.physicsBody.sensor = true;
        [_physicsNode addChild:beerNodes[i]];
        
        beerNodesCounters[i] = BEER_BOTTLE_RESPAWN_TIME;
    }
    [self schedule:@selector(respawnBeerBottles:) interval:1.0f];
    
    //item effects
    activeSlimes = [[CCNode alloc] init];
    [_physicsNode addChild:activeSlimes];
    activeSlimeLifetimes = [[NSMutableArray alloc] init];
    
    activeBarrelLifetimes = [[NSMutableArray alloc] init];
    
    activeGhost=[[CCNode alloc] init];
    [_physicsNode addChild: activeGhost];
    
    //z orders
    currItem.zOrder = _stage.zOrder + ITEM_Z;
    _dave.zOrder = _stage.zOrder + DAVE_Z;
    _huey.zOrder = _stage.zOrder + HUEY_Z;
    _princess.zOrder = _stage.zOrder + PRINCESS_Z;
    
    
    [GameVariables setCurrentScene:@"MainScene"];
    //start game timer
    startTime = [NSDate date];
    
}


-(void)checkGameEnd{
    
    
    if(checkEnd && (CGRectContainsPoint([daveRess boundingBox], _princess.position) || CGRectContainsPoint([hueyRess boundingBox], _princess.position))) {
        
        checkEnd=NO;
        
        NSString* gameEndMessage;
        NSString* victory = @"The Day Is Yours!";
        NSString* defeat = @"Sorry, You Sad Drunk";
        if(CGRectContainsPoint([daveRess boundingBox], _princess.position)) {
            gameEndMessage = (_player == _dave) ? victory : defeat;
        }
        else {
            gameEndMessage = (_player == _dave) ? defeat : victory;
        }
        
        _dave.physicsBody.velocity = CGPointZero;
        _huey.physicsBody.velocity = CGPointZero;
        _princess.physicsBody.velocity = CGPointZero;
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"GG Nubs!"
                                                       message: gameEndMessage
                                                      delegate: self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"Return to Lobby",nil];
        [alert show];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //CCLOG(@"\n\nBUTTON INDEX %d \n\n",buttonIndex);
    if (buttonIndex == 0) {
        
        _dave = nil;
        _princess = nil;
        _huey = nil;
        
        
        
        //gameroom
        CCScene *gameRoomScene = [CCBReader loadAsScene:@"GameRoom"];
        [[CCDirector sharedDirector] replaceScene:gameRoomScene];    }
}



- (void)update:(CCTime)delta {
    
    //items
    timeElapsed = [startTime timeIntervalSinceNow];
    
    if(_player == _huey) {
        _dave.physicsBody.sensor = true;
        _huey.physicsBody.sensor = true;
        _princess.physicsBody.sensor = true;
    }
    
    if(ccpLengthSQ(_player.physicsBody.velocity) > 100) {
        [_player.animationManager runAnimationsForSequenceNamed:@"Walk"];
    }
    else {
        [_dave.animationManager runAnimationsForSequenceNamed:@"Idle"];
    }
    
    if (_princess.zOrder > _stage.zOrder)[self checkGameEnd];
    [self checkGong];
    
    //dave authorities over beer bottle pickups
    if(_player == _dave) {
        int beerPickedUp =
        [ItemManager checkBeerBottles:_dave :_huey :(&_drunkLevelDave) :(&_drunkLevelHuey) :beerNodes];
        if(beerPickedUp >= 0) {
            beerNodesCounters[beerPickedUp] = 0;
        }
        
        drunkMeter.scaleX = (_drunkLevelDave + 1);
        
        if(_drunkLevelDave > BUZZ_LEVEL) {
            [MoveManager drunkSwaying:_dave :_drunkLevelDave :timeElapsed];
        }
        if(_drunkLevelHuey > BUZZ_LEVEL) {
            [MoveManager drunkSwaying:_huey :_drunkLevelHuey :timeElapsed];
        }
    }
    else {
        drunkMeter.scaleX = (_drunkLevelHuey + 1);
    }
    
    
    //drop item
    if(timeElapsed < -5) {
        if (_player == _dave) {
            if(((int)timeElapsed % ITEM_DROP_PERIOD) == 0) {
                if(itemHasDroppedForThisPeriod == NO) {
                    itemHasDroppedForThisPeriod = YES;
                    currItem = [ItemManager dropItem];
                    [_physicsNode addChild:currItem];
                    currItemDropTime = timeElapsed;
                    //Networking - Send info
                    [NetworkManager sendItemToServer:currItem.name iPosition:currItem.position];
                }
            }
        }
        
        //kill item
        if(currItem != nil) {
            currItem.rotation+=10;
            bool isFalling = (_player == _dave) ? falling[DAVE] : isFallingHuey;
            //item pickup
            if(CGRectContainsPoint([_player boundingBox], currItem.position) && !isFalling) {
                if(itemsHeld < 3) {
                    currItem.rotation = 0;
                    [ItemManager itemEntersInventory:currItem];
                    currItem.zOrder = itemBox[itemsHeld].zOrder - 1;
                    [currItem setColor:[CCColor colorWithWhite:1.0 alpha:1.0]];
                    
                    [_physicsNode removeChild:currItem];
                    currItem.scale = 1.0;
                    
                    //Networking - Notice
                    if(_player == _dave) {
                        [NetworkManager sendItemInfoMsgToServer:@"KILL_HUEY_ITEM"];
                    }
                    else {
                        [NetworkManager sendItemInfoMsgToServer:@"KILL_DAVE_ITEM"];
                    }
                    
                    
                    [itemBox[itemsHeld] addChild:currItem];
                    
                    itemsHeld++;
                    //itemHasDroppedForThisPeriod = NO;
                    currItem = nil;
                    
                }
            }
            
            
            
            
            if (_player == _dave) {
                if((timeElapsed - currItemDropTime) <= ITEM_ALIVE_PERIOD) {
                    //CCLOG(@"kill\n");
                    
                    
                    [_physicsNode removeChild:currItem];
                    [NetworkManager sendItemInfoMsgToServer:@"KILL_HUEY_ITEM"];
                    currItem = nil;
                    
                    //itemHasDroppedForThisPeriod = NO;
                }
            }
            
            
            
        }
        
        if(currItem == nil) itemHasDroppedForThisPeriod = NO;
        
    }
    
    if(_player == _dave) {
        //detect falloff
        if([PhysicsManager detectFallOff:_dave.position :uiimage]) {
            if(falling[DAVE] == NO) [self dropPlayer:_dave :DAVE];
        }
        if([PhysicsManager detectFallOff:_huey.position :uiimage]) {
            if(falling[HUEY] == NO) [self dropPlayer:_huey :HUEY];
        }
        if([PhysicsManager detectFallOff:_princess.position :uiimage]) {
            if(falling[PRINCESS] == NO) [self dropPlayer:_princess :PRINCESS];
        }
        
        //zorder check against princess
        if(falling[PRINCESS] == NO) {
            if(falling[DAVE] == NO) {
                if(_dave.position.y <= _princess.position.y) _dave.zOrder = _princess.zOrder+1;
                else _dave.zOrder = _princess.zOrder-1;
            }
            if(falling[HUEY] == NO) {
                if(_huey.position.y <= _princess.position.y) _huey.zOrder = _princess.zOrder+1;
                else _huey.zOrder = _princess.zOrder-1;
                
            }
        }
    }
    
    //NSArray* allSlimes = activeSlimes.children;
    //CCLOG(@"\activeSlimes: %d\n",allSlimes.count);
    //Activated Item - Opponent
    if (opponentActivatedItem != nil) {
        [self activateItemAbilities:opponentActivatedItem];
        opponentActivatedItem = nil;
    }
    
    //Slime check
    if (_player == _dave) {
        [ItemManager SlimeCheck:activeSlimes :activeSlimeLifetimes :timeElapsed :_dave :_huey :_princess];
        
    }
    
    //NetWorking
    //Server
    if (_player == _dave) {
        [NetworkManager sendEveryPositionToServer:_huey.position poitionDave:_dave.position poitionPrincess:_princess.position
                                                 :[NSString stringWithFormat:@"%i",_huey.zOrder] :[NSString stringWithFormat:@"%i",_dave.zOrder] :[NSString stringWithFormat:@"%i",_princess.zOrder]
                                                 :[NSString stringWithFormat:@"%i",falling[HUEY]]];
        
    }
    
    
}

+ (void)itemInfo:(NSString *) msg
{
    //CCLOG(@"KILL = %@", msg);
    if ( [msg isEqualToString:@"KILL"] ) {
        //CCLOG(@"KILL = %@", msg);
        [globalPhysicsNode removeChild:currItem];
        currItem = nil;
    }
    
    if ( [msg isEqualToString:@"KILL_HUEY_ITEM"] ) {
        if(_player == _huey) {
            [globalPhysicsNode removeChild:currItem];
            currItem = nil;
        }
    }
    
    if ( [msg isEqualToString:@"KILL_DAVE_ITEM"] ) {
        if(_player == _dave) {
            [globalPhysicsNode removeChild:currItem];
            currItem = nil;
        }
    }
}

+ (void)updateItems:(CGPoint) msg name: (NSString*) name
{
    if(_player == _huey) {
        currItem = [CCBReader load:name];
        currItem.scale*=0.3;
        [currItem setColor:[CCColor colorWithWhite:0.5 alpha:1.0]];
        currItem.position = msg;
        currItem.physicsBody.collisionMask = @[];
        
        //currItem = item;
        [globalPhysicsNode addChild:currItem];
        
    }
}

- (void)respawnBeerBottles:(CCTime)delta {
    for(int i = 0; i < NUM_BEER_NODES; i++) {
        if(beerNodesCounters[i] < BEER_BOTTLE_RESPAWN_TIME) {
            beerNodesCounters[i]++;
            
            //time to respawn
            if(beerNodesCounters[i] == BEER_BOTTLE_RESPAWN_TIME) {
                CCNode* beerBottle = [CCBReader load:@"Barrel"];
                beerBottle.scale *= 0.3;
                beerBottle.scaleX *= 0.2;
                beerBottle.rotation -= 25;
                [beerNodes[i] addChild:beerBottle];
                beerBottle.physicsBody.sensor = true;
            }
        }
    }
}



//damping
- (void)damping:(CCTime)delta {
    //damping && zorder check against princess
    if(falling[DAVE] == NO) [PhysicsManager doDamping:_dave :DAMPING];
    if(falling[HUEY] == NO) [PhysicsManager doDamping:_huey :DAMPING];
    if(falling[PRINCESS] == NO) [PhysicsManager doDamping:_princess :DAMPING_STATUE];
}

//drops the player, sends it behind the platform
- (void)dropPlayer: (CCNode*) player : (int) playerNum {
    
    player.zOrder = _stage.zOrder - 1;
    player.physicsBody.collisionMask = @[];
    
    CGPoint fallDirection = ccp(0, -1);
    float fallSpeed = (playerNum < PRINCESS) ? 6000 : 10000;
    CGPoint impulse = ccpMult(fallDirection, fallSpeed);
    [player.physicsBody applyImpulse:impulse];
    
    falling[playerNum] = YES;
    
    switch(playerNum) {
        case DAVE:
            [self schedule:@selector(reviveDave:) interval:1.0f];
            break;
        case HUEY:
            [self schedule:@selector(reviveHuey:) interval:1.0f];
            break;
        case PRINCESS:
            [self schedule:@selector(revivePrincess:) interval:1.0f];
            break;
    }
}

- (void)reviveDave:(CCTime)delta {
    
    reviveCounter[DAVE]++;
    
    if ( reviveCounter[DAVE] >= PLAYER_REVIVE_TIME)
    {
        falling[DAVE] = NO;
        reviveCounter[DAVE] = 0;
        //facingDirection = 1;
        _dave.flipX = NO;
        _dave.zOrder = _stage.zOrder + DAVE_Z;
        _dave.position = daveStart;
        _dave.physicsBody.collisionMask = NULL;
        _dave.physicsBody.velocity = ccp(0,0);
        _drunkLevelDave = 0;
        [self unschedule:@selector(reviveDave:)];
    }
    
}

- (void)reviveHuey:(CCTime)delta {
    
    reviveCounter[HUEY]++;
    
    if ( reviveCounter[HUEY] >= PLAYER_REVIVE_TIME)
    {
        falling[HUEY] = NO;
        reviveCounter[HUEY] = 0;
        //facingDirection = 1;
        _huey.flipX = NO;
        _huey.zOrder = _stage.zOrder + HUEY_Z;
        _huey.position = hueyStart;
        _huey.physicsBody.collisionMask = NULL;
        _huey.physicsBody.velocity = ccp(0,0);
        _drunkLevelHuey = 0;
        //TODO : network updated drunklevel to huey, or send it over in sendEveryPositionToServer
        [NetworkManager sendDeActivateItemsToServer:@"DrunkLevel"
                                          iPosition:CGPointZero
                                         playerInfo:[NSString stringWithFormat:@"%i", _drunkLevelHuey]
                                             iIndex:[NSString stringWithFormat:@"%i", _drunkLevelHuey]];
        [self unschedule:@selector(reviveHuey:)];
    }
    
}
- (void)revivePrincess:(CCTime)delta {
    
    reviveCounter[PRINCESS]++;
    
    if ( reviveCounter[PRINCESS] >= STATUE_REVIVE_TIME)
    {
        falling[PRINCESS] = NO;
        reviveCounter[PRINCESS] = 0;
        _princess.zOrder = _stage.zOrder + PRINCESS_Z;
        _princess.position = princessStart;
        _princess.physicsBody.collisionMask = NULL;
        _princess.physicsBody.velocity = ccp(0,0);
        _princess.opacity = 1.0;
        [self unschedule:@selector(revivePrincess:)];
    }
    
}




-(void) princessGoThru{
    
    
    if([activatedItem.name isEqual:@"Ghost"]){
        itemsHeld = [ItemManager useItem:(itemBox) :activatedItemIndex :itemsHeld];
        validItemMove = NO;
        [activatedItem.parent removeChild:activatedItem];
        _princess.opacity=0.3;
        _princess.physicsBody.collisionMask=@[];
        
        if(_player == _dave) {
            [NetworkManager sendActivatedToServer:activatedItem.name iPosition:CGPointZero player:@"dave"];
        }
        else {
            [NetworkManager sendActivatedToServer:activatedItem.name iPosition:CGPointZero player:@"huey"];
        }
        
        [self schedule:@selector(princessMist:) interval:1.0f];
        
    }
    
    
}

-(void) princessMist:(CCTime) delta{
    
    ghostCount++;
    
    if(ghostCount>=PRINCESS_GHOST_PERIOD){
        
        ghostCount=0;
        _princess.opacity=1;
        _princess.physicsBody.collisionMask=NULL;
        
        if ( _player == _dave ) {
            [NetworkManager sendDeActivateItemsToServer:activatedItem.name iPosition:activatedItem.position playerInfo:@"dave" iIndex:[NSString stringWithFormat:@"-1"]];
        }
        else {
            [NetworkManager sendDeActivateItemsToServer:activatedItem.name iPosition:activatedItem.position playerInfo:@"huey" iIndex:[NSString stringWithFormat:@"-1"]];
        }
        
        [self unschedule:@selector(princessMist:)];
        
        
    }
    
}

//TOUCH STUFF

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    //CCLOG(@"touch began");
    
    float w = _player.boundingBox.size.width;
    float h = _player.boundingBox.size.height;
    CGRect playerTouchBounds = CGRectMake([_player boundingBox].origin.x-w, [_player boundingBox].origin.y-h, w*2, h*2);
    //CGRect playerTouchBounds = CGRectMake(_player.position.x-200,_player.position.y-200,400,400);

    
    // start catapult dragging when a touch inside of the catapult arm occurs
    if (CGRectContainsPoint(playerTouchBounds, touchLocation))
        //&& abs(ccpLengthSQ(_dave.physicsBody.velocity)) < 64)//abs(_dave.physicsBody.velocity.x) < 0.5 && abs(_dave.physicsBody.velocity.y) < 0.5)
    {
        validMove = YES;
        
        start = touchLocation;
        end = touchLocation;
        
    }
    else
    {
        validMove = NO;
    }
    
    //item usage
    for(int i = 0; i < itemsHeld; i++) {
        if(CGRectContainsPoint([itemBox[i] boundingBox], touchLocation)) {
            NSArray* child = itemBox[i].children;
            activatedItem = (CCNode*)child[0];
            activatedItemIndex = i;
            validItemMove = YES;
            [self princessGoThru];
            break;
        }
    }
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint touchLocation = [touch locationInNode:self];
    //CCLOG(@"touch moved");
    // whenever touches move, update the position of the mouseJointNode to the touch position
    if (validMove){
        
        end = touchLocation;
        
        start = _player.position;
        arrowNode.position = start;
        
        //update facing direction
        if (_player == _dave) {
            if((start.x - end.x) < 0) { if(_player.flipX == NO) _player.flipX = YES; }
            else { if(_player.flipX == YES) _player.flipX = NO; }
        }
        else {
            if((end.x - start.x) < 0) { if(_player.flipX == NO) _player.flipX = YES; }
            else { if(_player.flipX == YES) _player.flipX = NO; }
        }
        
        
        //place arrow
        launchDirection = [MoveManager calculateMoveVector:start :end];
        
        float len = ccpLength(launchDirection) / ARROW_DOTS;
        
        CGPoint arrowDirection = (ccpNormalize(launchDirection));
        
        NSArray *arrowChildren = arrowNode.children;
        for(int i = 0; i < arrowChildren.count; i++) {
            CCNode* dots = arrowChildren[i];
            dots.position = ccpMult(arrowDirection, len*(i+1));
        }
        
        
        arrowNode.visible = YES;
    }
    
    if(validItemMove) {
        //touchLocation = [touch locationInNode:self];
        [activatedItem.parent removeChild:activatedItem];
        activatedItem.scale = 0.5;
        [_physicsNode addChild:activatedItem];
        activatedItem.anchorPoint = ccp(0.5,0.5);
        activatedItem.opacity = 0.5;
        activatedItem.position = touchLocation;
    }
}

- (void)releaseTouch {
    
    if(validMove) {
        
        if (_player == _dave) {//Server
            [MoveManager movePlayer:_dave :launchDirection :_drunkLevelDave];
        }
        else {
            [NetworkManager sendCGPointToServer:launchDirection];
        }
        
    }
    
    validMove = NO;
    arrowNode.visible = NO;
    
}

+ (void)updateOpponent:(CGPoint) msg
{
    if (_player == _dave && msg.x == msg.x && msg.y == msg.y && _huey != nil) {//Server
        [MoveManager movePlayer:_huey :msg :_drunkLevelHuey];
    }
}

+ (void) updateOpponentName:(NSString*)msg
{
    NSComparisonResult result = [[GameVariables getPlayerName] compare:msg];
    NSLog(@"my name is %@", [GameVariables getPlayerName]);
    NSLog(@"opponent name is %@", msg);
    if(![msg isEqualToString:[GameVariables getPlayerName]] ){
        
        if(result == NSOrderedAscending){
            _player = _dave;
            NSLog(@"im dave");
        }
        else
        {
            _player = _huey;
            NSLog(@"im huey");
        }
    }
}

+ (void)updateEveryPosition:(CGPoint)msgH positionDave:(CGPoint)msgD positionPrincess:(CGPoint)msgP :(NSString*)zH :(NSString*)zD :(NSString*)zP :(NSString*) fallingH
{
    if (_player == _huey) {
        if (msgH.x != 0 && msgH.y != 0) {
            _huey.position = msgH;
            _huey.zOrder = [zH intValue];
        }
        
        if (msgD.x != 0 && msgD.y != 0) {
            _dave.position = msgD;
            _dave.zOrder = [zD intValue];
        }
        
        if (msgP.x != 0 && msgP.y != 0) {
            _princess.position = msgP;
            _princess.zOrder = [zP intValue];
        }
        
        isFallingHuey = [fallingH intValue];
        
    }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches end, meaning the user releases their finger, release the catapult
    [self releaseTouch];
    
    CGPoint touchLocation = [touch locationInNode:self];
    if(validItemMove && (![PhysicsManager detectFallOff:touchLocation :uiimage])) {
        //valid use of item
        
        itemsHeld = [ItemManager useItem:(itemBox) :activatedItemIndex :itemsHeld];
        [activatedItem.parent removeChild:activatedItem];
        activatedItem.scale = 0.4;
        [_physicsNode addChild:activatedItem];
        activatedItem.opacity = 1.0;
        //activatedItem.scale = 0.4;
        activatedItem.zOrder = _stage.zOrder+1;//(_player == _dave) ? ((falling[DAVE]) ? _stage.zOrder + 1 : _player.zOrder - 1) : ((isFallingHuey) ? _stage.zOrder + 1 : _player.zOrder - 1);
        
        [self activateItemAbilities:activatedItem];
        if (_player == _dave) {
            [NetworkManager sendActivatedToServer:activatedItem.name iPosition:activatedItem.position player:@"dave"];
        }
        else {
            [NetworkManager sendActivatedToServer:activatedItem.name iPosition:activatedItem.position player:@"huey"];
            
        }
        
    }
    else if(validItemMove) {
        [ItemManager itemEntersInventory:activatedItem];
        activatedItem.zOrder = itemBox[activatedItemIndex].zOrder - 1;
        [activatedItem.parent removeChild:activatedItem];
        activatedItem.scale = 1.0;
        [itemBox[activatedItemIndex] addChild:activatedItem];
    }
    validItemMove = NO;
}




+(void) activateItems:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString *)player
{
    //if this is activated by opposing player
    if ((_player == _dave && [player isEqual:@"huey"]) || (_player == _huey &&  [player isEqual:@"dave"])) {
        if([itemName isEqual:@"Ghost"]) {
            _princess.opacity=0.3;
            _princess.physicsBody.collisionMask=@[];
        }
        else {
            opponentActivatedItem = [CCBReader load:itemName];
            opponentActivatedItem.scale = 0.4;
            opponentActivatedItem.anchorPoint = ccp(0.5,0.5);
            //CCLOG(@"opponenetActiveted in activateItems = %@", opponentActivatedItem.name);
            [globalPhysicsNode addChild:opponentActivatedItem];
            
            opponentActivatedItem.position = itemPosition;
            opponentActivatedItem.opacity = 1.0;
            opponentActivatedItem.zOrder = _player.zOrder - 1;
        }
    }
    
    
}

+ (void) deActivateItem:(NSString *)itemName iPosition:(CGPoint)itemPosition playerInfo:(NSString*) player iIndex:(NSString*) index
{
    if (_player == _huey && [itemName isEqual:@"Slime" ]) {
        if (index.intValue >= 0){
            
            NSArray* allSlimes = activeSlimes.children;
            //CCLOG(@"\nallSlimes: %d\n",allSlimes.count);
            if(allSlimes.count > 0) {
            [activeSlimes removeChild:allSlimes[index.intValue]];
            [activeSlimeLifetimes removeObject:[activeSlimeLifetimes objectAtIndex:index.intValue]];
            }
        }
    }
    else if(_player == _huey && [itemName isEqual:@"Barrel"]) {
        
        if (index.intValue >= 0 && activeBarrelLifetimes.count > 0){
            //life time is stored in position x
            [ItemManager barrelUpdate:activeBarrelLifetimes :[index intValue] :itemPosition.x];
        }
    }
    else if ( [itemName isEqual:@"Ghost"] ) {
        if(_player != _huey) {
            _princess.physicsBody.collisionMask = NULL;
        }
        _princess.opacity = 1.0f;
    }
    else if ( _player == _huey && [itemName isEqual:@"Beer"] ){
        if([index intValue] >= 0) {
            beerNodesCounters[[index intValue]] = 0;
            NSArray* child = beerNodes[[index intValue]].children;
            if(child.count > 0) {
            CCNode* temp = (CCNode*)child[0];
            [temp removeFromParent];
            if ( ![player isEqual:@"DAVE"] ) {
                _drunkLevelHuey = [player intValue];
            }
            }
        }
    }
    else if( _player == _huey && [itemName isEqual:@"DrunkLevel"] ){
        _drunkLevelHuey = [player intValue];
    }
}


-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
    [self releaseTouch];
    if(validItemMove) {
        [ItemManager itemEntersInventory:activatedItem];
        activatedItem.zOrder = itemBox[activatedItemIndex].zOrder - 1;
        [_physicsNode removeChild:activatedItem];
        [itemBox[activatedItemIndex] addChild:activatedItem];
    }
    validItemMove = NO;
    
}

-(void) checkGong{
    
    if((CGRectContainsPoint([gong boundingBox] , _dave.position) || CGRectContainsPoint([gong boundingBox] , _huey.position))  && gongAccess){
        
        if(gongColorChange){
            [gong setColor:[CCColor colorWithRed:0.5 green:0.8 blue:0.9 alpha:1.0]];
            gongColorChange=NO;
        }
        CGPoint daveRes = daveRess.position;
        daveRess.position = hueyRess.position;
        hueyRess.position = daveRes;
        gongAccess = NO ;
        gongCounter = 0 ;
        
        [self schedule:@selector(reactivateGong:) interval:1.0f];
        
    }
}

-(void) reactivateGong: (CCTime)delta {
    
    gongCounter++;
    
    if(gongCounter == GONG_DURATION) {
        CGPoint daveRes = daveRess.position;
        daveRess.position = hueyRess.position;
        hueyRess.position = daveRes;
    }
    
    if(gongCounter == GONG_COOLDOWN) {
        gongColorChange=YES;
        gongAccess = YES;
        [gong setColor:[CCColor colorWithRed:0.5 green:(1/(0.80f)) blue:(1/(0.90f)) alpha:1.0]];
        [self unschedule:@selector(reactivateGong:)];
    }
}


- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair barrel:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    if(_player == _dave) {
        
        float energy = [pair totalKineticEnergy];
        
        // if energy is large enough, remove the seal
        if (energy > 20000.f) {
            [[_physicsNode space] addPostStepBlock:^{
                //[self sealRemoved:nodeA];
                
                [ItemManager barrelCheck:nodeA :activeBarrelLifetimes];
                
                //[nodeA setColor:[CCColor colorWithWhite:0.5 alpha:1.0]];
                //CCLOG(@"\n\n\nbarrel hit\n\n\n");
            } key:nodeA];
        }
        
    }
}

- (void) activateItemAbilities: (CCNode*) item {
    if([item.name  isEqual: @"Barrel"]) {
        if (_player == _dave) {
            item.physicsBody.collisionMask = NULL;
            item.physicsBody.collisionType = @"barrel";
        }
        [activeBarrelLifetimes addObject:item];
        [activeBarrelLifetimes addObject:[NSNumber numberWithInt:3]];
    }
    else if([item.name  isEqual: @"Slime"]) {
        [item removeFromParent];
        
        item.physicsBody.collisionMask = @[];
        //CCLOG(@"opponenetActiveted in Abilities = %@", item.name);
        [activeSlimes addChild:item];
        [activeSlimeLifetimes addObject:[NSNumber numberWithFloat:timeElapsed]];
    }
    
    else if([item.name isEqual:@"Ghost"]){
        
        [item removeFromParent];
        if (_player == _huey) {
            item.physicsBody.collisionMask = @[];
        }
        [activeGhost addChild:item];
        
    }
}

+ (CCSprite*) returnDave {
    return _dave;
}
+ (CCSprite*) returnHuey {
    return _huey;
}

@end
