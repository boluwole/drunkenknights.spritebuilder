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



// is called when CCB file has completed loading
- (void)didLoadFromCCB {

    
    checkEnd=YES;
    //load players & statue
    _dave = (CCSprite*)[CCBReader load:@"Dave"];
    [_physicsNode addChild:_dave];
    _dave.position = DAVE_START;
    _dave.scale *= 0.25;
    daveStart = _dave.position;
    
    _huey = (CCSprite*)[CCBReader load:@"Huey"];
    [_physicsNode addChild:_huey];
    _huey.position = HUEY_START;
    _huey.scale *= 0.25;
    hueyStart = _huey.position;
    
    _princess = (CCSprite*)[CCBReader load:@"Princess"];
    [_physicsNode addChild:_princess];
    _princess.position = PRINCESS_START;
    _princess.scale *= 0.30;
    princessStart = _princess.position;
    
    daveRess = (CCSprite*)[CCBReader load:@"DaveRess"];
    hueyRess = (CCSprite*)[CCBReader load:@"HueyRess"];
    [_physicsNode addChild: daveRess];
    [_physicsNode addChild: hueyRess];
    daveRess.position= DAVE_RESS;
    hueyRess.position= HUEY_RESS;
    daveRess.scale *= 0.4;
    hueyRess.scale *= 0.4;
    
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
    
    //always damp
    [self schedule:@selector(damping:) interval:0.02];

    
    //item node
    currItem = [[CCNode alloc] init];
    inventory = [[CCNode alloc] init];
    [self addChild:inventory];
    inventory.position = ccp(INVENTORY_POSITION,INVENTORY_POSITION);
    //inventory.zOrder = _stage.zOrder + INVENTORY_Z;
  
    for(int i = 0; i < 3; i++) {
        itemBox[i]=[CCBReader load: @"Box"];
        itemBox[i].scale *= 0.3;
        //[inventory addChild: itemBox[i]];
        [self addChild:itemBox[i]];
        itemBox[i].position = ccp(INVENTORY_POSITION + INVENTORY_DISTANCE*i,INVENTORY_POSITION);
        //itemBox[i].position = ccp(INVENTORY_DISTANCE*i,0);
        itemBox[i].opacity *= 0.6;
        itemBox[i].zOrder = _stage.zOrder + INVENTORY_Z;
    }
    
    itemsHeld = 0;
    
    //z orders
    currItem.zOrder = _stage.zOrder + ITEM_Z;
    _dave.zOrder = _stage.zOrder + DAVE_Z;
    _huey.zOrder = _stage.zOrder + HUEY_Z;
    _princess.zOrder = _stage.zOrder + PRINCESS_Z;
    
    //networking
    //_networkManager = [[NetworkManager alloc] init];
    //[_networkManager setOpponentAndPrincess:_huey :_princess];
    if(NETWORKED) {
        [[AppWarpHelper sharedAppWarpHelper] initializeAppWarp];
        [[AppWarpHelper sharedAppWarpHelper] connectToWarp];
    }
    
    //start game timer
    startTime = [NSDate date];
    
}
-(void)checkGameEnd{


   if(checkEnd && (CGRectContainsPoint([daveRess boundingBox], _princess.position) || CGRectContainsPoint([hueyRess boundingBox], _princess.position))) {
    
        CCLOG(@"\n BITCH IS HOME... FUCK U ASSHOLE");
        checkEnd=NO;
        [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"SplashScreen"]];
    }
    
    
 /*   if(checkEnd && (ccpDistanceSQ(daveRess.position, _princess.position) <= 25 || ccpDistanceSQ(hueyRess.position, _princess.position) <= 25)){
        
        CCLOG(@"\n BITCH IS HOME...");
        checkEnd=NO;
        
    }*/
    
    
}



- (void)update:(CCTime)delta {
    
    //items
    timeElapsed = [startTime timeIntervalSinceNow];
    
    //drop item
    if((int)timeElapsed == ITEM_DROP_PERIOD) {
        
        startTime = [NSDate date];
        if(itemHasDroppedForThisPeriod == NO) {
          //  CCLOG(@"DROP IT!\n");
            itemHasDroppedForThisPeriod = YES;
            currItem = [ItemManager dropItem];
            [_physicsNode addChild:currItem];
        }
    }
    [self checkGameEnd];
    //kill item
    if(itemHasDroppedForThisPeriod == YES) {
        if((int)timeElapsed == ITEM_ALIVE_PERIOD) {
            [_physicsNode removeChild:currItem];
            itemHasDroppedForThisPeriod = NO;
        }
        else {
            //item pickup
            currItem.rotation+=10;
            if(CGRectContainsPoint([_dave boundingBox], currItem.position)) {
                //CCLOG(@"pickup\n");
                if(itemsHeld < 3) {
                    currItem.rotation = 0;
                    currItem.anchorPoint = ccp(-0.15,-0.10);
                    currItem.scale = 0.7;
                    currItem.position = CGPointZero;
                    currItem.zOrder = itemBox[itemsHeld].zOrder - 1;
                    
                    [_physicsNode removeChild:currItem];
                    //[inventory addChild:currItem];
                    [itemBox[itemsHeld] addChild:currItem];
                    
                    itemsHeld++;
                    itemHasDroppedForThisPeriod = NO;
                    //send event over to kill this item and update _dave's inventory on huey's side too
                }
            }
        }
    }
    
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
        [self unschedule:@selector(revivePrincess:)];
    }
    
}

//TOUCH STUFF

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    //CCLOG(@"touch began");
    
    // start catapult dragging when a touch inside of the catapult arm occurs
    if (CGRectContainsPoint([_dave boundingBox], touchLocation))
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
        
        start = _dave.position;
        arrowNode.position = start;
        
        //update facing direction
        if((start.x - end.x) < 0) { if(_dave.flipX == NO) _dave.flipX = YES; }
        else { if(_dave.flipX == YES) _dave.flipX = NO; }
        
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
        [_physicsNode addChild:activatedItem];
        activatedItem.scale = 0.3;
        activatedItem.anchorPoint = ccp(0.5,0.5);
        activatedItem.opacity = 0.5;
        activatedItem.position = touchLocation;
    }
}

- (void)releaseTouch {
    
    if(validMove) {
        
        [NetworkManager sendCGPointToServer:launchDirection];
        [MoveManager movePlayer:_dave :launchDirection];
    }
    
    validMove = NO;
    arrowNode.visible = NO;
    
}

+ (void)updateOpponent:(CGPoint) msg {
    //CCLOG(@"\n\nupdating: %f, %f\n\n",msg.x,msg.y);
    [MoveManager movePlayer:_huey :msg];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches end, meaning the user releases their finger, release the catapult
    [self releaseTouch];
    
    CGPoint touchLocation = [touch locationInNode:self];
    if(validItemMove && (![PhysicsManager detectFallOff:touchLocation :uiimage])) {
        itemsHeld = [ItemManager useItem:(itemBox) :activatedItemIndex :itemsHeld];
        activatedItem.opacity = 1.0;
         //activatedItem.p
        activatedItem.scale = 0.2;
        validItemMove = NO;
    }
    else if(validItemMove) {
        activatedItem.anchorPoint = ccp(-0.15,-0.10);
        activatedItem.scale = 0.7;
        activatedItem.position = CGPointZero;
        activatedItem.zOrder = itemBox[activatedItemIndex].zOrder - 1;
        
        [_physicsNode removeChild:currItem];
        //[inventory addChild:currItem];
        [itemBox[activatedItemIndex] addChild:currItem];

        validItemMove = NO;
    }
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
    [self releaseTouch];
//    CGPoint touchLocation = [touch locationInNode:self];
//    if(validItemMove && [PhysicsManager detectFallOff:touchLocation :uiimage]) {
//        itemsHeld = [ItemManager useItem:(itemBox) :activateItemIndex :itemsHeld];
//        [_physicsNode addChild:activatedItem];
//        activatedItem.anchorPoint = CGPointZero;
//        activatedItem.scale = 0.3;
//        activatedItem.position = touchLocation;
//        
//        validItemMove = NO;
//    }
//    else {
//        activatedItem.position = itemBox[activateItemIndex].position;
//        validItemMove = NO;
//    }

}

@end
