//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10ƒ/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"


@implementation MainScene{
    
    CCNodeColor* _drunkenMeter;
    
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
static bool isFallingDave;
static CGPoint velocityHuey;
static CGPoint velocityDave;
static float _drunkLevelDave;
static float _drunkLevelHuey;
static bool gongHit;
static CCParticleSystem *dave_drunk_bubble;
static CCParticleSystem *huey_drunk_bubble;

bool gongActive;
bool playSlime;
bool daveSlip;
bool hueySlip;
bool princessSlip;
bool playerCharacterSet;
bool ghostOn;
bool replayVomit;
bool replayVomit_dave;
bool gameEnd;
OALSimpleAudio *aud;
OALSimpleAudio *aud2;
CCNode* tempItem1;
CCNode* tempItem2;

CCParticleSystem *dave_stone_smoke;
CCParticleSystem *huey_stone_smoke;
CCParticleSystem *DaveWinParticle;
CCParticleSystem *HueyWinParticle;

CGPoint _oldVelocities[3];
CGPoint _oldPositions[3];
BOOL _oldFalling[3];

int gameTime;

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    gameEnd=NO;
    gameTime=0;
    gongActive=NO;
    slimeSound=0;
    slimeSoundForDave=0;
    daveSlip=YES;
    hueySlip=YES;
    princessSlip=YES;
    magicianAppear=YES;
    magicianCounter=0;
    startRotation=YES;
    wheelStartCounter   =0;
    replayVomit=YES;
    replayVomit_dave=YES;
    [self schedule:@selector(rotateWheel:) interval:0.01f];
    [self schedule:@selector(playTing:) interval:1.0f];
    [self schedule:@selector(keepStartTime:) interval:1.0f];

    aud=[OALSimpleAudio sharedInstance];
    [aud playEffect:@"StartGame.wav"];
    globalPhysicsNode = _physicsNode;
    _physicsNode.collisionDelegate = self;
    opponentActivatedItem = nil;
    itemActivate=YES;
    gameStartTime=0;
    checkEnd=YES;
    //load players & statue
    _dave = (CCSprite*)[CCBReader load:@"_Dave"];
    [_physicsNode addChild:_dave];
    _dave.position = DAVE_START;
    _dave.scale *= 0.25;
    daveStart = _dave.position;
    _drunkLevelDave = 20;
    //_daveOldVelocity = _dave.physicsBody.velocity;
    _oldVelocities[DAVE] = _dave.physicsBody.velocity;
    _oldPositions[DAVE] = _dave.position;
    
    //bubble
    dave_drunk_bubble = (CCParticleSystem *)[CCBReader load:@"bubble"];
    //dave_drunk_bubble.autoRemoveOnFinish = TRUE;
    [_dave.physicsNode addChild:dave_drunk_bubble];
    
    _huey = (CCSprite*)[CCBReader load:@"_Huey"];
    [_physicsNode addChild:_huey];
    _huey.position = HUEY_START;
    _huey.scale *= 0.25;
    hueyStart = _huey.position;
    _drunkLevelHuey = 20;
    //_hueyOldVelocity = _huey.physicsBody.velocity;
    _oldVelocities[HUEY] = _huey.physicsBody.velocity;
    _oldPositions[HUEY] = _huey.position;
    
    //Shadows
    shadow_Dave=(CCSprite*)[CCBReader load: @"Shadows"];
    shadow_Huey=(CCSprite*)[CCBReader load: @"Shadows"];

    
    //Princess End
    princess_end=(CCSprite*)[CCBReader load: @"Princess_Normal"];
    princess_end.scale*=2;
    princess_end.position=PRINCESS_END;
    

    
    //bubble
    huey_drunk_bubble = (CCParticleSystem *)[CCBReader load:@"bubble"];
    //huey_drunk_bubble.autoRemoveOnFinish = TRUE;
    //huey_drunk_bubble.position = _huey.position;
    [_huey.physicsNode addChild:huey_drunk_bubble];
    
    _princess = (CCSprite*)[CCBReader load:@"Princess"];
    [_physicsNode addChild:_princess];
    _princess.position = PRINCESS_START;
    _princess.scale = 0.35;
    princessStart = _princess.position;
    //_princessOldVelocity = _princess.physicsBody.velocity;
    _oldVelocities[PRINCESS] = _princess.physicsBody.velocity;
    _oldPositions[PRINCESS] = _princess.position;
    
    //decide plyaer is dave or huey based on itemshops update
    if([[GameVariables getDPlayerName] isEqualToString:@"_dave"]){
        _player = _dave;
    }
    else{
        _player = _huey;
    }
    
    //indicator for player
    CCSprite* indicator = (CCSprite*)[CCBReader load:@"Indicator"];
    indicator.position = ccp(80,250);
    //indicator.scale = 0.3;
    [_player addChild:indicator];
    
    
    daveRess = (CCSprite*)[CCBReader load:@"DaveRess"];
    hueyRess = (CCSprite*)[CCBReader load:@"HueyRess"];
    [_physicsNode addChild: daveRess];
    [_physicsNode addChild: hueyRess];
    daveRess.position= DAVE_RESS;
    hueyRess.position= HUEY_RESS;
    //daveRess.scale *= 0.4;
    //hueyRess.scale *= 0.4;
    
    //clouds
  //  CGSize size=[[CCDirector sharedDirector] viewSize ];
    
    cloud1=(CCSprite*)[CCBReader load:@"clouds"];
    cloud2=(CCSprite*)[CCBReader load:@"clouds"];
    cloud1.anchorPoint = ccp(0,0);
    cloud1.scaleY *= 1.2;
    cloud1.position = CLOUD1_POSN;
    cloud1.opacity *= 0.38;
    [_physicsNode addChild: cloud1];
    
    cloud2.anchorPoint = ccp(0,0);
    cloud2.scaleY *= 1.2;
    cloud2.opacity *= 0.38;
    cloud2.position=ccp([cloud1 boundingBox].size.width,0);
    [_physicsNode addChild:cloud2];
    
    arrow_down=(CCSprite*)[CCBReader load:@"Arrow_down"];
    arrow_down.position =  ARROW_POSN;
    arrow_down.scale *= 0.05;
    [_physicsNode addChild: arrow_down];
    
    _cd_wheel=(CCSprite*)[CCBReader load:@"wheel_cooldown"];
    _cd_wheel.position = CD_WHEEL_POSITION;
    _cd_wheel.scale *= 0.6;
    arrow_down.zOrder=_cd_wheel.zOrder+1;
    [_physicsNode addChild:_cd_wheel];
    
    
    [self schedule:@selector(moveClouds:) interval: 0.009f];
    //GONG
    gong=(CCSprite*)[CCBReader load: @"Gongs"];
    [_physicsNode addChild: gong];
    gong.position= GONG_POSITION;
    gong.physicsBody.collisionType = @"gong";
    
    gongColorChange=YES;
    gongAccess=YES;
    gongCounter = 0;
    gongHit = NO;
    
    
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
        _oldFalling[i] = NO;
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
    //drunkMeter = [CCBReader load:@"Box"];
    //drunkMeter.position = ccp(10, 300);
    //drunkMeter.anchorPoint = ccp(0,0.5);
    //drunkMeter.scaleY *= 0.1;
    //[self addChild:drunkMeter];
    
    
    //_drunkenMeter.scaleX = 0.5;
    
    //sobering up
    [self schedule:@selector(drunkDecrease:) interval:2.0];
    
    //always damp
    [self schedule:@selector(damping:) interval:0.02];
    
    
    //item node
    currItem = [[CCNode alloc] init];
    
    for(int i = 0; i < 3; i++) {
        itemBox[i]=[CCBReader load: @"Box"];
        itemBox[i].scale *= 0.5;
        [_physicsNode addChild:itemBox[i]];
        itemBox[i].position = ccp(INVENTORY_POSITION + INVENTORY_DISTANCE*i,INVENTORY_POSITION);
        //itemBox[i].opacity *= 0.6;
        itemBox[i].zOrder = _stage.zOrder + INVENTORY_Z;
    }
    
    itemsHeld = 0;
    
    //initialize original two items
    NSArray* gameItems = [GameItem getGameItems];
    GameItemData *data = [gameItems objectAtIndex:[GameVariables getItemIndex1]];
    tempItem1= [CCBReader load:data.itemName];
    [ItemManager itemEntersInventory:tempItem1];
    tempItem1.zOrder = itemBox[itemsHeld].zOrder - 1;
    [tempItem1 setColor:[CCColor colorWithWhite:1.0 alpha:1.0]];
    [itemBox[itemsHeld] addChild:tempItem1];
    itemsHeld++;
    
    data = [gameItems objectAtIndex:[GameVariables getItemIndex2]];
    tempItem2 = [CCBReader load:data.itemName];
    [ItemManager itemEntersInventory:tempItem2];
    tempItem2.zOrder = itemBox[itemsHeld].zOrder - 1;
    [tempItem2 setColor:[CCColor colorWithWhite:1.0 alpha:1.0]];
    [itemBox[itemsHeld] addChild:tempItem2];
    itemsHeld++;
    
    //beer bottles
    for(int i = 0; i < NUM_BEER_NODES; i++) {
        CCNode* beerBottle = [CCBReader load:@"Beer"];
        beerBottle.scale = 0.3;
        beerNodes[i] = [[CCNode alloc] init];
        switch(i)
        {
            case 1:
                beerNodes[i].position = ccpAdd(princessStart, ccp(-40,-60));
                break;
            case 2:
                beerNodes[i].position = ccpAdd(princessStart, ccp(-40,60));
                break;
            case 3:
                beerNodes[i].position = ccpAdd(princessStart, ccp(40,-60));
                break;
            case 0:
                beerNodes[i].position = ccpAdd(princessStart, ccp(40,60));
                break;
                
        }
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
    cloud1.zOrder=_princess.zOrder+3;
    cloud2.zOrder=_princess.zOrder+3;
    
    shadow_Dave.zOrder= -1;
    shadow_Huey.zOrder= -1;
    shadow_Dave.position=SHADOW_OFFSET;
    shadow_Huey.position=SHADOW_OFFSET;
    shadow_Dave.scale = 1.8;
    shadow_Dave.opacity = 0.6;
    shadow_Huey.scale = 1.8;
    shadow_Huey.opacity = 0.6;
    [_dave addChild:shadow_Dave];
    [_huey addChild:shadow_Huey];
    [GameVariables setCurrentScene:@"MainScene"];
    //start game timer
    startTime = [NSDate date];
    
}


-(void) moveClouds:(CCTime) delta{
    
    cloud1.position=ccp(cloud1.position.x-1, cloud1.position.y);
    cloud2.position=ccp(cloud2.position.x-1, cloud2.position.y);
    if(cloud1.position.x<-[cloud1 boundingBox].size.width){
        
        cloud1.position=ccp(cloud2.position.x+ [cloud2 boundingBox].size.width,cloud1.position.y);
        
    }
    if(cloud2.position.x<-[cloud2 boundingBox].size.width){
        
        cloud2.position=ccp(cloud1.position.x+ [cloud1 boundingBox].size.width,cloud2.position.y);
        
    }
    
}

-(void)makePrincessDisappear: (CCTime) delta{
    
    _princess.opacity=_princess.opacity-0.1;
    gong.opacity=gong.opacity-0.1;
    daveRess.opacity=daveRess.opacity-0.1;
    hueyRess.opacity=hueyRess.opacity-0.1;
    if(_princess.opacity <= 0){
        
        [self unschedule:@selector(makePrincessDisappear:)];
        
    }
    
}

-(void) keepGameEndTime: (CCTime) delta{
    
    gameTime++;
    if(gameTime>=3){
        
        //gameEnd=YES;
        //CCLOG(@"\nGameEnd is ON");
        [self unschedule:@selector(keepGameEndTime:)];
        
        if(gameResult) {
            CCScene *GameWin = [CCBReader loadAsScene:@"GameWin"];
            [[CCDirector sharedDirector] replaceScene:GameWin];
        }
        else {
            CCScene *GameLose = [CCBReader loadAsScene:@"GameLose"];
            [[CCDirector sharedDirector] replaceScene:GameLose];
        }
        
    }
    
}

-(void)checkGameEnd{
    
//    BOOL daveFalling = CGRectContainsPoint([daveRess boundingBox], _princess.position);
//    BOOL hueyFalling = CGRectContainsPoint([hueyRess boundingBox], _princess.position);
    
    BOOL daveFalling = (ccpDistance(daveRess.position, _princess.position) <= 15) ? YES : NO;
    BOOL hueyFalling = (ccpDistance(hueyRess.position, _princess.position) <= 15) ? YES : NO;;
    
    
//    DaveWinParticle=(CCParticleSystem*)[CCBReader load: @"Princess_Particle_Dave"];
//    HueyWinParticle=(CCParticleSystem*)[CCBReader load: @"Princess_Particle_Huey"];
    
    if(checkEnd && ( daveFalling | hueyFalling) ) {
        
        checkEnd=NO;
       // [aud playEffect:@"Game_Over.mp3"];
        
        NSString* victory = @"The Day Is Yours!";
        NSString* defeat = @"Sorry, You Sad Drunk";
        NSString* gameEndMessage;
        
        if(CGRectContainsPoint([daveRess boundingBox], _princess.position)) {
            
            _princess.opacity=1;
            DaveWinParticle=(CCParticleSystem*)[CCBReader load: @"Princess_Particle_Dave"];
            [_princess addChild:DaveWinParticle];
            DaveWinParticle.zOrder=_princess.zOrder-1;
            DaveWinParticle.position=ccp(50,50);
            DaveWinParticle.autoRemoveOnFinish = TRUE;

            [self schedule:@selector(makePrincessDisappear:) interval:0.1f];
            [self schedule:@selector(keepGameEndTime:) interval: 1.0f];
            
            gameEndMessage = (_player == _dave) ? victory : defeat;
            gameResult = (_player == _dave) ? YES : NO;
            
            if(gameEndMessage == victory){
                
                [aud playEffect:@"gameOverWin.mp3"];
//                if(gameEnd){
//                //[NSThread sleepForTimeInterval:3];
//                CCScene *GameWin = [CCBReader loadAsScene:@"GameWin"];
//                [[CCDirector sharedDirector] replaceScene:GameWin];
//               }
                
            }
            
            else{
                
                [aud playEffect:@"gameOverLoser.wav"];
                
//                if(gameEnd){
//                
//                 CCScene *GameLose = [CCBReader loadAsScene:@"GameLose"];
//                [[CCDirector sharedDirector] replaceScene:GameLose];
//                }
                
            }
            
            
        }
        else {
            _princess.opacity=1;
            HueyWinParticle=(CCParticleSystem*)[CCBReader load: @"Princess_Particle_Huey"];
            [_princess addChild:HueyWinParticle];
            HueyWinParticle.zOrder=_princess.zOrder-1;
            HueyWinParticle.position=ccp(50,50);
            HueyWinParticle.autoRemoveOnFinish=TRUE;
            [self schedule:@selector(makePrincessDisappear:) interval:0.1f];
            [self schedule:@selector(keepGameEndTime:) interval: 1.0f];

            gameEndMessage = (_player == _dave) ? defeat : victory;
            gameResult = (_player == _dave) ? NO : YES;
            
            if(gameEndMessage == victory){
                
                [aud playEffect:@"gameOverWin.mp3"];
                
//                if(gameEnd){
//                CCScene *GameWin = [CCBReader loadAsScene:@"GameWin"];
//                [[CCDirector sharedDirector] replaceScene:GameWin];
//                }
                
            }
            
            else{
                
                [aud playEffect:@"gameOverLoser.wav"];
                
//                if(gameEnd){
//                CCScene *GameWin = [CCBReader loadAsScene:@"GameWin"];
//                [[CCDirector sharedDirector] replaceScene:GameWin];
//                }
                
            }

        }
        
        _dave.physicsBody.velocity = CGPointZero;
        _huey.physicsBody.velocity = CGPointZero;
        _princess.physicsBody.velocity = CGPointZero;
        
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"GG Nubs!"
//                                                       message: gameEndMessage
//                                                      delegate: self
//                                             cancelButtonTitle:nil
//                                             otherButtonTitles:@"Return to Lobby",nil];
//        [alert show];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //CCLOG(@"\n\nBUTTON INDEX %d \n\n",buttonIndex);
    if (buttonIndex == 0) {
        
        _dave = nil;
        _princess = nil;
        _huey = nil;
        _player = nil;
        
        //gameroom
        CCScene *gameRoomScene = [CCBReader loadAsScene:@"GameRoom"];
        [[CCDirector sharedDirector] replaceScene:gameRoomScene];    }
}

-(void)checkGhostIntersection{
    
    if(ghostOn){
        if(CGRectContainsPoint([_princess boundingBox] , _dave.position))
            [aud playEffect:@"PassThroughGhost.wav"];
        if(CGRectContainsPoint([_princess boundingBox] , _huey.position))
            [aud playEffect:@"PassThroughGhost.wav"];
        ghostOn=NO;
    }
    
    
}



-(void)keepStartTime:(CCTime)delta{
    
    gameStartTime++;
    if(gameStartTime == TIME_FOR_ITEM_ACTIVATION ){
        
        itemActivate=YES;
        for(int i=0 ; i<3 ; i++)
            
            tempItem1.opacity=1;
            tempItem2.opacity=1;
        
        [self unschedule:@selector(keepStartTime:)];
        
    }
    else if(gameStartTime  < TIME_FOR_ITEM_ACTIVATION  ){
        for(int i = 0; i < 3; i++) {
        
            tempItem1.opacity=0.3;
            tempItem2.opacity=0.3;
            
        }
        
        
    }
    
    
}

-(void) slimeSoundCounter: (CCTime) delta{
    
    slimeSound++;
    
    if (slimeSound >=7){
        
        daveSlip=YES;
        hueySlip=YES;
        princessSlip=YES;
        slimeSound=0;
        replayVomit=YES;
        [self unschedule:@selector(slimeSoundCounter:)];
    }
    
}

-(void) reactivateSlimeSound{
    
    if((!daveSlip || !hueySlip || !princessSlip) && replayVomit) {
        
        replayVomit=NO;
        [self schedule:@selector(slimeSoundCounter:) interval:1.0f];
        
        
    }
    
}

-(void) slimeSoundCounterForDave: (CCTime) delta{
    
    
    slimeSoundForDave++;
    if (slimeSoundForDave >=7){
        [ItemManager setDaveSlime: YES ];
        [ItemManager setHueySlime: YES ];
        [ItemManager setPrincessSlime:YES];
        slimeSoundForDave=0;
        replayVomit_dave=YES;
        [self unschedule:@selector(slimeSoundCounterForDave:)];
    }
    
}


-(void) reactivateSlimeSoundForDave{
    
    [self schedule:@selector(slimeSoundCounterForDave:) interval:1.0f];
    
}

- (void)update:(CCTime)delta {
    
    //items
    timeElapsed = [startTime timeIntervalSinceNow];
    
    [self reactivateSlimeSound];
    
     bool dave_Slip=[ItemManager returnDaveSlime];
     bool huey_Slip=[ItemManager returnHueySlime];
     bool princess_Slip=[ItemManager returnPrincessSlime];
    
    if((!dave_Slip || !huey_Slip || !princess_Slip) && replayVomit_dave)
    {
        replayVomit_dave=NO;
        [self reactivateSlimeSoundForDave];
        
    }
    
    //to make sure velocity doesn't go out of control;
    //if current velocity is too different from last frame's velocity, cap it at past frame's velocity * cap_factor
    //CCLOG(@"\n\n\nDAVE VELOCITY: %f, %f\n",_dave.physicsBody.velocity.x,_dave.physicsBody.velocity.y);
    
    if(_player == _dave) {
        if(ccpLength(ccpSub(_dave.physicsBody.velocity, _oldVelocities[DAVE])) > VELOCITY_DIFF_CAP && !_oldFalling[DAVE]) {
            _dave.physicsBody.velocity = ccpMult(_oldVelocities[DAVE], VELOCITY_CAP_FACTOR);
            _dave.position = ccpAdd(_oldPositions[DAVE],_dave.physicsBody.velocity);
        }
        if(ccpLength(ccpSub(_huey.physicsBody.velocity, _oldVelocities[HUEY])) > VELOCITY_DIFF_CAP && !_oldFalling[HUEY]) {
            _huey.physicsBody.velocity = ccpMult(_oldVelocities[HUEY], VELOCITY_CAP_FACTOR);
            _huey.position = ccpAdd(_oldPositions[HUEY],_huey.physicsBody.velocity);
        }
        if(ccpLength(ccpSub(_princess.physicsBody.velocity, _oldVelocities[PRINCESS])) > VELOCITY_DIFF_CAP && !_oldFalling[PRINCESS]) {
            _princess.physicsBody.velocity = ccpMult(_oldVelocities[PRINCESS], VELOCITY_CAP_FACTOR);
            _princess.position = ccpAdd(_oldPositions[PRINCESS],_princess.physicsBody.velocity);
        }
    }
    
    //CCLOG(@"\nDAVE VELOCITY REDONE: %f, %f\n\n\n",_dave.physicsBody.velocity.x,_dave.physicsBody.velocity.y);
    
    [self checkGhostIntersection];
    
    if(_player == _huey) {
        _dave.physicsBody.sensor = true;
        _huey.physicsBody.sensor = true;
        _princess.physicsBody.sensor = true;
    }
    
    
    //current animation based on velocity
    CGPoint daveVelocity = (_player == _dave) ? _player.physicsBody.velocity : velocityDave;
    CGPoint hueyVelocity = (_player == _dave) ? _huey.physicsBody.velocity : velocityHuey;
    
    //CCLOG(@"\n\n\nHUEY V: %f, %f\n\n\n",hueyVelocity.x,hueyVelocity.y);
    
    if(ccpLengthSQ(daveVelocity) > 25) {
        if(![[_dave.animationManager runningSequenceName] isEqual:@"Walk"])
                [_dave.animationManager runAnimationsForSequenceNamed:@"Walk"];
    }
    else {
        if(![[_dave.animationManager runningSequenceName] isEqual:@"Idle"])
                    [_dave.animationManager runAnimationsForSequenceNamed:@"Idle"];
    }
    
    if(ccpLengthSQ(hueyVelocity) > 25) {
        if(![[_huey.animationManager runningSequenceName] isEqual:@"Walk"])
            [_huey.animationManager runAnimationsForSequenceNamed:@"Walk"];
    }
    else {
        if(![[_huey.animationManager runningSequenceName] isEqual:@"Idle"])
            [_huey.animationManager runAnimationsForSequenceNamed:@"Idle"];
    }
    
    
    if (_princess.zOrder > _stage.zOrder)[self checkGameEnd];
    if(gongAccess && gongHit) [self checkGong];
    gongHit = NO;
    
    //dave authorities over beer bottle pickups
    if(_player == _dave) {
        int beerPickedUp =
        [ItemManager checkBeerBottles:_dave :_huey :falling[DAVE] :falling[HUEY] :(&_drunkLevelDave) :(&_drunkLevelHuey) :beerNodes];
        if(beerPickedUp >= 0) {
            beerNodesCounters[beerPickedUp] = 0;
        }
        
        //drunkMeter.scaleX = ((_drunkLevelDave/10) + 0.5);
        
        if (_drunkLevelDave > 50)
            _drunkenMeter.scaleX = 1;
        else
            _drunkenMeter.scaleX = _drunkLevelDave/50 ;
        
        if(_drunkLevelDave > BUZZ_LEVEL) {
            [MoveManager drunkSwaying:_dave :_drunkLevelDave :timeElapsed];
        }
        if(_drunkLevelHuey > BUZZ_LEVEL) {
            [MoveManager drunkSwaying:_huey :_drunkLevelHuey :timeElapsed];
        }
    }
    else {
        
        if (_drunkLevelHuey > 50)
            _drunkenMeter.scaleX = 1;
        else
            _drunkenMeter.scaleX = _drunkLevelHuey/50 ;
    }
    
    
    //drop item
    if(timeElapsed < -12) {
        if (_player == _dave) {
            if(((int)timeElapsed % ITEM_DROP_PERIOD) == 0) {
                if(itemHasDroppedForThisPeriod == NO) {
                    itemHasDroppedForThisPeriod = YES;
                    currItem = [ItemManager dropItem];
                    [_physicsNode addChild:currItem];
                    currItemDropTime = timeElapsed;
                    //Networking - Send info
                    [NetworkManager sendItemToServer:currItem.name iPosition:currItem.position];
                    [NetworkManager sendSound:@"item_drop"];
                }
            }
        }
        
        //kill item
        if(currItem != nil) {
            //currItem.rotation+=10;
            bool isFalling = (_player == _dave) ? falling[DAVE] : isFallingHuey;
            //item pickup
            if(CGRectContainsPoint([_player boundingBox], currItem.position) && !isFalling) {
                if(itemsHeld < 3) {
                    //currItem.rotation = 0;
                    //[ItemManager itemEntersInventory:currItem];
                    
                    //[currItem setColor:[CCColor colorWithWhite:1.0 alpha:1.0]];
                    [ItemManager itemEntersInventory:currItem];
                    currItem.zOrder = itemBox[itemsHeld].zOrder - 1;
                    currItem.scale = 1.0;
                    [_physicsNode removeChild:currItem];
                    
                    
                    //Networking - Notice
                    if(_player == _dave) {
                        [NetworkManager sendItemInfoMsgToServer:@"KILL_HUEY_ITEM"];
                    }
                    else {
                        [NetworkManager sendItemInfoMsgToServer:@"KILL_DAVE_ITEM"];
                    }
                    
                    
                    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"assets.plist"];
                    if([currItem.name isEqualToString:@"BoxBarrel"]) {
                        //[(CCSprite*)currItem setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Assets/barrel.png"]];
                        currItem = [CCBReader load:@"Barrel"];
                    }
                    else if([currItem.name isEqualToString:@"BoxSlime"]) {
                        //[(CCSprite*)currItem setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Assets/vomit.png"]];
                        currItem = [CCBReader load:@"Slime"];
                    }
                    else if([currItem.name isEqualToString:@"BoxGhost"]) {
                        //[(CCSprite*)currItem setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Assets/ghost.png"]];
                        currItem = [CCBReader load:@"Ghost"];
                    }
                  
                   // CCLOG(@"\n\nanchor point 1: %f, %f\n",currItem.anchorPoint.x,currItem.anchorPoint.y);
                    [itemBox[itemsHeld] addChild:currItem];
                    
            
                    currItem.position = ccp(60.0,60.0);
                    // CCLOG(@"\n\nanchor point 2: %f, %f\n",currItem.anchorPoint.x,currItem.anchorPoint.y);
                    
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
    
    if(_player == _dave) {
        _oldVelocities[DAVE] = _dave.physicsBody.velocity;
        _oldVelocities[HUEY] = _huey.physicsBody.velocity;
        _oldVelocities[PRINCESS] = _princess.physicsBody.velocity;
        
        _oldFalling[DAVE] = falling[DAVE];
        _oldFalling[HUEY] = falling[HUEY];
        _oldFalling[PRINCESS] = falling[PRINCESS];
    }
    
    //NetWorking
    //Server
    //CCLOG(@"\n\nFALLINGHUEY: %i\n\n",(falling[HUEY]+1));
    if (_player == _dave) {
        [NetworkManager sendEveryPositionToServer:_huey.position poitionDave:_dave.position poitionPrincess:_princess.position
                                                 :[NSString stringWithFormat:@"%i",_huey.zOrder] :[NSString stringWithFormat:@"%i",_dave.zOrder] :[NSString stringWithFormat:@"%i",_princess.zOrder]
                                                 :[NSString stringWithFormat:@"%i",(falling[HUEY]+1)] :[NSString stringWithFormat:@"%i",(falling[DAVE]+1)]
                                                 :ccpAdd(_huey.physicsBody.velocity,ccp(0.001,0.001)) :ccpAdd(_dave.physicsBody.velocity,ccp(0.001,0.001))];
        
    
    }
    //update bubble

    dave_drunk_bubble.position = ccpAdd(_dave.position, ccp(0, 10));
    huey_drunk_bubble.position = ccpAdd(_huey.position, ccp(0, 10));
    //CCLOG(@"dave drunkness:%f and huey drunkness:%f", _drunkLevelDave, _drunkLevelHuey);

    //[NetworkManager sendDaveDrunknessToServer:[NSString stringWithFormat:@"%f", _drunkLevelDave] huey_index:[NSString stringWithFormat:@"%f",_drunkLevelHuey]];
    if(_player == _dave){
        [NetworkManager sendDaveDrunknessToServer:[NSString stringWithFormat:@"%f", _drunkLevelDave]];
    }
    else{
        [NetworkManager sendHueyDrunknessToServer:[NSString stringWithFormat:@"%f", _drunkLevelHuey]];
    }
    
    //update shadows
    bool fallingHuey = (_player == _dave) ? falling[HUEY] : isFallingHuey;
    bool fallingDave = (_player == _dave) ? falling[DAVE] : isFallingDave;
    
    //CCLOG(@"\n\nFALLING HUEY: %d\n\n",fallingHuey);
    if(fallingHuey) shadow_Huey.visible = NO;
    else shadow_Huey.visible = YES;
    
    if(fallingDave) shadow_Dave.visible = NO;
    else shadow_Dave.visible = YES;
    
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

-(void) rotateWheel: (CCTime)delta{
    
    
    if(startRotation){
        int k=ITEM_DROP_PERIOD;
        float ti=(360.0f/k)/100;
        _cd_wheel.rotation+=ti;
    

    }
}


-(void) playTing: (CCTime)delta{
    magicianCounter++;
    wheelStartCounter++;
    if(wheelStartCounter  >=  9 && wheelStartCounter   <= 11)
        [aud playEffect:@"item_ping.wav"];
    if(wheelStartCounter >= ITEM_DROP_PERIOD)
        wheelStartCounter = 0;
    if(magicianCounter >= MAGICIAN_INTERFERENCE && magicianAppear){
        magicianCounter=0;
        [aud playEffect:@"Evil Magician Random DIalogue.mp3"];
        [self moveRessurectionStone];
    }
    
}


-(void) moveRessurectionStone{
    int sign;
    float dist = ccpDistance(daveRess.position, princessStart);
    if( (int)dist >= DISTANCE_FROM_PRINCESS_START ){
        
        
        bool gongOn=[self returnGongActive];
        
//        if(daveRess.position.x > princessStart.x){
//            sign= -1 ;
//        }
//        else{
//            sign= 1 ;
//        }
        float daveMove= DISTANCE_RESS_STONES_MOVE  ;
        float hueyMove= (-1)*DISTANCE_RESS_STONES_MOVE  ;
        
        if(!gongOn){
            id moveActionDaveRess = [CCActionMoveBy actionWithDuration:DURATION_STONES_MOVE position:ccp((daveMove),0)];
            id moveActionHueyRess = [CCActionMoveBy actionWithDuration:DURATION_STONES_MOVE position:ccp((hueyMove),0)];
            [daveRess runAction: [CCActionSequence actions:moveActionDaveRess,nil]];
            [hueyRess runAction: [CCActionSequence actions:moveActionHueyRess,nil]];
            sign = 1;
        }
        else{
            
            id moveActionDaveRess = [CCActionMoveBy actionWithDuration:DURATION_STONES_MOVE position:ccp((-1 * daveMove),0)];
            id moveActionHueyRess = [CCActionMoveBy actionWithDuration:DURATION_STONES_MOVE position:ccp((-1 * hueyMove),0)];
            [daveRess runAction: [CCActionSequence actions:moveActionDaveRess,nil]];
            [hueyRess runAction: [CCActionSequence actions:moveActionHueyRess,nil]];
            sign=0;
        }
        //smoke
        dave_stone_smoke = (CCParticleSystem *)[CCBReader load:@"Smoke_Dave"];
        dave_stone_smoke.autoRemoveOnFinish = TRUE;
        
        huey_stone_smoke = (CCParticleSystem *)[CCBReader load:@"Smoke_Huey"];
        huey_stone_smoke.autoRemoveOnFinish = TRUE;

        if(sign == 1){
            [daveRess addChild:dave_stone_smoke];
            [hueyRess addChild:huey_stone_smoke];
        }
        else{
            [daveRess addChild:huey_stone_smoke];
            [hueyRess addChild:dave_stone_smoke];
        }
    }
    
    else{
        
        magicianAppear=NO;
        
    }
}


+ (void)updateItems:(CGPoint) msg name: (NSString*) name
{
    if(_player == _huey) {
        currItem = [CCBReader load:name];
        currItem.scale*=0.3;
      //  [currItem setColor:[CCColor colorWithWhite:0.5 alpha:1.0]];
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
            
            NSArray* child = beerNodes[i].children;
            CCNode* temp = (CCNode*)child[0];
            float rot = (360.0f/BEER_BOTTLE_RESPAWN_TIME);
            if(temp != nil) temp.rotation += rot;
            
            //time to respawn
            if(beerNodesCounters[i] == BEER_BOTTLE_RESPAWN_TIME) {
                [beerNodes[i] removeAllChildrenWithCleanup:YES];
                CCNode* beerBottle = [CCBReader load:@"Beer"];
                beerBottle.scale = 0.3;
                [beerNodes[i] addChild:beerBottle];
                beerBottle.physicsBody.sensor = true;
            }
        }
    }
}

//sobering
- (void)drunkDecrease:(CCTime)delta {
    if(_player == _dave) {
        if(_drunkLevelDave > 1) _drunkLevelDave *= 0.95;
        if(_drunkLevelDave < 1) _drunkLevelDave = 1;
        
//        if(_drunkLevelHuey > 0) _drunkLevelHuey *= 0.9;
//        if(_drunkLevelHuey < 1) _drunkLevelHuey = 0;
    }
    else {
        if(_drunkLevelHuey > 1) _drunkLevelHuey *= 0.95;
        if(_drunkLevelHuey < 1) _drunkLevelHuey = 1;
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
            [aud playEffect:@"Stage_Fall_Player.wav"];
            //shadow_Dave.visible=NO;
            [self schedule:@selector(reviveDave:) interval:1.0f];
            [NetworkManager sendSound:(@"dave_drop")];
            break;
        case HUEY:
            [aud playEffect:@"Stage_Fall_Player.wav"];
            //shadow_Huey.visible=NO;
            [self schedule:@selector(reviveHuey:) interval:1.0f];
            [NetworkManager sendSound:(@"huey_drop")];
            break;
        case PRINCESS:
            [aud playEffect:@"Stage_Fall_Princess.wav"];
            [self schedule:@selector(revivePrincess:) interval:1.0f];
            [NetworkManager sendSound:(@"princess_drop")];
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
        //_drunkLevelDave = 0;
        [self unschedule:@selector(reviveDave:)];
        [NetworkManager sendSound:@"dave_revive"];
        [aud playEffect:@"Dave_Laugh.mp3"];
        //shadow_Dave.visible=YES;
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
        //_drunkLevelHuey = 0;
        //TODO : network updated drunklevel to huey, or send it over in sendEveryPositionToServer
//        [NetworkManager sendDeActivateItemsToServer:@"DrunkLevel"
//                                          iPosition:CGPointZero
//                                         playerInfo:[NSString stringWithFormat:@"%i", _drunkLevelHuey]
//                                             iIndex:[NSString stringWithFormat:@"%i", _drunkLevelHuey]];
        [self unschedule:@selector(reviveHuey:)];
        [NetworkManager sendSound:@"huey_revive"];
        [aud playEffect:@"Huey_Laugh.mp3"];
        //shadow_Huey.visible=YES;
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
        
        
        if ( _player == _dave ) {
            _princess.physicsBody.collisionMask=NULL;
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
    CGRect playerTouchBounds = CGRectMake([_player boundingBox].origin.x-w, [_player boundingBox].origin.y-h, w*4, h*4);
    //CGRect playerTouchBounds = CGRectMake(_player.position.x-200,_player.position.y-200,400,400);

    
    //item usage
    bool usingItems = NO;
    if(itemActivate){
        for(int i = 0; i < itemsHeld; i++) {
            if(CGRectContainsPoint([itemBox[i] boundingBox], touchLocation)) {
                NSArray* child = itemBox[i].children;
                activatedItem = (CCNode*)child[0];
                activatedItemIndex = i;
                validItemMove = YES;
                usingItems = YES;
                [self princessGoThru];
                break;
            }
        }
    }
    
    // start catapult dragging when a touch inside of the catapult arm occurs
    if (CGRectContainsPoint(playerTouchBounds, touchLocation) && !usingItems)
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
        
//        //update facing direction
//        if (_player == _dave) {
//            if((start.x - end.x) < 0) { if(_player.scaleX > 0) _player.scaleX*=-1; }
//            else { if(_player.scaleX < 0) _player.scaleX*=-1; }
//            
//            //if((start.x - end.x) < 0) { if(_player.flipX == NO) _player.flipX = YES; }
//            //else { if(_player.flipX == YES) _player.flipX = NO; }
//        }
//        else {
//            if((start.x - end.x) > 0) { if(_player.scaleX > 0) _player.scaleX*=-1; }
//            else { if(_player.scaleX < 0) _player.scaleX*=-1; }
//            
//            //if((end.x - start.x) < 0) { if(_player.flipX == NO) _player.flipX = YES; }
//            //else { if(_player.flipX == YES) _player.flipX = NO; }
//        }
       
        
        //place arrow
        launchDirection = [MoveManager calculateMoveVector:start :end];
        
        float len = (ccpLength(launchDirection) / ARROW_DOTS) / 2;
        
        CGPoint arrowDirection = (ccpNormalize(launchDirection));
        
        NSArray *arrowChildren = arrowNode.children;
        for(int i = 0; i < arrowChildren.count; i++) {
            CCNode* dots = arrowChildren[i];
            dots.position = ccpMult(arrowDirection, len*(i+1));
        }
        
        
        arrowNode.visible = YES;
    }
    
    if(validItemMove && itemActivate) {
        //touchLocation = [touch locationInNode:self];
        activatedItem.physicsBody.collisionMask = @[];
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
        //dave_drunk_bubble.position = _dave.position;
        //huey_drunk_bubble.position = _huey.position;
        
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

+ (void)updateEveryPosition:(CGPoint)msgH positionDave:(CGPoint)msgD positionPrincess:(CGPoint)msgP :(NSString*)zH :(NSString*)zD :(NSString*)zP
                           :(NSString*) fallingH :(NSString*) fallingD :(CGPoint) velocityH :(CGPoint) velocityD
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
        
        if([fallingH intValue] != 0) {
            isFallingHuey = [fallingH intValue]-1;
        }
        if([fallingD intValue] != 0) {
            isFallingDave = [fallingD intValue]-1;
        }
        //CCLOG(@"\n\n\nisFALLINGHUEY: %d\n\n\n",isFallingHuey);
        
        if(ccpLengthSQ(velocityH) != 0) velocityHuey = ccpSub(velocityH,ccp(0.001,0.001));
        if(ccpLengthSQ(velocityD) != 0) velocityDave = ccpSub(velocityD,ccp(0.001,0.001));
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
        
         //CCLOG(@"\n\nanchor point 3: %f, %f\n",activatedItem.anchorPoint.x,activatedItem.anchorPoint.y);
        
        [ItemManager itemEntersInventory:activatedItem];
        activatedItem.zOrder = itemBox[activatedItemIndex].zOrder - 1;
        [activatedItem.parent removeChild:activatedItem];
        activatedItem.scale = 1.0;
        [itemBox[activatedItemIndex] addChild:activatedItem];
    }
    validItemMove = NO;
}


-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
    [self releaseTouch];
    if(validItemMove) {
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
    if([itemName isEqual:@"Gong"]) {
        if([player isEqual:@"YES"]) gongHit = YES;
    }
    else {
    
    if ((_player == _dave && [player isEqual:@"huey"]) || (_player == _huey &&  [player isEqual:@"dave"])) {
        if([itemName isEqual:@"Ghost"]) {
            _princess.opacity=0.3;
            _princess.physicsBody.collisionMask=@[];
            ghostOn=YES;
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
        ghostOn=NO;
        if(_player == _dave) {
            _princess.physicsBody.collisionMask = NULL;
        }
        _princess.opacity = 1.0f;
        
    }
    else if ( _player == _huey && [itemName isEqual:@"Beer"] ){
      
        OALSimpleAudio *aud2=[OALSimpleAudio    sharedInstance];
        [aud2 playEffect:@"Beer.wav"];
        if([index intValue] >= 0) {
            beerNodesCounters[[index intValue]] = 0;
            NSArray* child = beerNodes[[index intValue]].children;
            if(child.count > 0) {
            CCNode* temp = (CCNode*)child[0];
            [temp removeFromParentAndCleanup:YES];
            temp = [CCBReader load:@"BeerWheel"];
            temp.opacity = 0.8;
            temp.scale = 0.2;
            [beerNodes[[index intValue]] addChild:temp];

            if ( ![player isEqual:@"DAVE"] ) {
                //_drunkLevelHuey = [player floatValue];
                _drunkLevelHuey += 10;
            }
            }
        }
    }
    else if( _player == _huey && [itemName isEqual:@"DrunkLevel"] ){
        //_drunkLevelHuey = [player floatValue];
        _drunkLevelHuey += 10;
    }
}

+ (void) playSound:(NSString *)name{
    if(_player == _huey){
        if([name isEqualToString:@"item_drop"]){
            [aud playEffect:@"Item_PickUp.mp3"];
            [NetworkManager sendSound:@"blank"];
            OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
            [aud1 playEffect:@"Item_PickUp.mp3"];
        }
        
        if([name isEqualToString:@"dave_drop"] || [name isEqualToString:@"huey_drop"]){
            [aud playEffect:@"Stage_Fall_Player.wav"];
            [NetworkManager sendSound:@"blank"];
            OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
            [aud1 playEffect:@"Stage_Fall_Player.wav"];
        }
        
        if([name isEqualToString:@"princess_drop"]){
            [aud playEffect:@"Stage_Fall_Princess.wav"];
            [NetworkManager sendSound:@"blank"];
            OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
            [aud1 playEffect:@"Stage_Fall_Princess.wav"];
        }
        
        if([name isEqualToString:@"huey_vomit"] && hueySlip){
            hueySlip=NO;
            [aud playEffect:@"Vomit_slip.wav"];
            [NetworkManager sendSound:@"blank"];
            OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
            [aud1 playEffect:@"Vomit_slip.wav"];
        }
        if([name isEqualToString:@"dave_vomit"] && daveSlip){
            daveSlip=NO;
            [aud playEffect:@"Vomit_slip.wav"];
            [NetworkManager sendSound:@"blank"];
            OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
            [aud1 playEffect:@"Vomit_slip.wav"];
        }

        if([name isEqualToString:@"princess_vomit"] && princessSlip){
            princessSlip=NO;
            [NetworkManager sendSound:@"blank"];
            OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
            [aud1 playEffect:@"Vomit_slip.wav"];
        }

        
        if([name isEqualToString:@"dave_revive"]){
            [aud playEffect:@"Dave_Laugh.mp3"];
            [NetworkManager sendSound:@"blank"];
            OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
            [aud1 playEffect:@"Dave_Laugh.mp3"];
        }
        
        if([name isEqualToString:@"huey_revive"]){
            [aud playEffect:@"Huey_Laugh.mp3"];
            [NetworkManager sendSound:@"blank"];
            OALSimpleAudio *aud1=[OALSimpleAudio sharedInstance];
            [aud1 playEffect:@"Huey_Laugh.mp3"];
        }
    }
    
}

+(void) updateDaveDrunkIndex:(NSString *)index{
    if(_player == _huey && [index floatValue] >=1){
        _drunkLevelDave = [index floatValue];
        
    }
    if(_drunkLevelDave >= 30.0){
        dave_drunk_bubble.scale = 1.0;
    }
    else{
        dave_drunk_bubble.scale = 0.1;
    }
}

+(void) updateHueyDrunkIndex:(NSString *)index{
    if(_player == _dave && [index floatValue] >=1){
        _drunkLevelHuey = [index floatValue];
    }
    if(_drunkLevelHuey >= 30.0){
        huey_drunk_bubble.scale = 1.0;
    }
    else{
        huey_drunk_bubble.scale = 0.1;
    }

}

-(void) checkGong{
    
    //if((CGRectContainsPoint([gong boundingBox] , _dave.position) || CGRectContainsPoint([gong boundingBox] , _huey.position))  && gongAccess){
        
        
        [aud playEffect:@"export.mp3"];
        gongActive=YES;
        if(gongColorChange){
            [gong setColor:[CCColor colorWithRed:0.5 green:0.8 blue:0.9 alpha:0.5]];
            gongColorChange=NO;
        }
    gong_wheel=(CCSprite*)[CCBReader load:@"BeerWheel"];

    gong_wheel.position=ccp(32.5,32);
    gong_wheel.zOrder=gong.zOrder+1;
    gong_wheel.scale=0.2;
    gong_wheel.opacity=0.5;

        [gong addChild: gong_wheel];
    
        CGPoint daveRes = daveRess.position;
        daveRess.position = hueyRess.position;
        hueyRess.position = daveRes;
        gongAccess = NO ;
        //gongHit = NO;
    
        [self schedule:@selector(reactivateGong:) interval:1.0f];
        
    //}
}

-(void) reactivateGong: (CCTime)delta {
    
    gongCounter++;
    float rot=(360.0f/GONG_COOLDOWN);
    gong_wheel.rotation+=rot;
    
    if(gongCounter == GONG_DURATION) {
       [aud playEffect:@"gong_reactivate.wav"];
        gongActive=NO;
        CGPoint daveRes = daveRess.position;
        daveRess.position = hueyRess.position;
        hueyRess.position = daveRes;
    }
    
    if(gongCounter == GONG_COOLDOWN) {
        [gong removeAllChildren];
        gongCounter = 0 ;
        [aud playEffect:@"gong_reactivate.wav"];
        gongColorChange=YES;
        gongAccess = YES;
        [gong setColor:[CCColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        [self unschedule:@selector(reactivateGong:)];
    }
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair gong:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    if(nodeB == _dave || nodeB == _huey) {
        if(gongAccess && gongHit == NO) {
            [[_physicsNode space] addPostStepBlock:^{
                gongHit = YES;
                [NetworkManager sendActivatedToServer:@"Gong" iPosition:CGPointZero player:@"YES"];
            } key:nodeA];
        }
        
    }
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair barrel:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    if(_player == _dave) {
        
        float energy = [pair totalKineticEnergy];
        
        // if energy is large enough, remove the seal
        if (energy > 100.f) {
            [[_physicsNode space] addPostStepBlock:^{
                //[self sealRemoved:nodeA];
                
                [ItemManager barrelCheck:nodeA :activeBarrelLifetimes];
                
                //[nodeA setColor:[CCColor colorWithWhite:0.5 alpha:1.0]];
                //CCLOG(@"\n\n\nbarrel hit\n\n\n");
            } key:nodeA];
        }
        
    }
}

-(bool) returnGongActive{
    
    return gongActive;
    
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
        ghostOn=YES;
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
