//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Dave.h"

@implementation

//@synthesize revive = time;


MainScene{
    enum ItemType {
        BARREL = 0,
        VOMIT = 1,
        BAIT = 2,
        POWERUP = 3,
    };
    
    CCPhysicsNode *_physicsNode;
    CCPhysicsNode *_backPhysicsNode;
    CCSprite *_dave;
    CCSprite *_huey;
    CCSprite *_princess;
    CCSprite *_stage;
    CCSprite *_barrel;
    CCSprite *_vomit;
    CCNode *itemBox[3];
    
    CCNode *arrowNode;
    
    
    BOOL validMove;
    
    //drag vector for movement
    CGPoint start;
    CGPoint end;
    CGPoint launchDirection;
    //int facingDirection;
    
    //starting locations
    CGPoint daveStart;
    CGPoint hueyStart;
    CGPoint princessStart;
    
    //starting z order
    int daveZ;
    int hueyZ;
    int princessZ;
    
    //stage image for falloff detection
    UIImage* uiimage;
    
    //check if falling
    BOOL falling[3];
    
    //ticker for revive
    int reviveCounter[3];
    
    //game timer
    NSDate *startTime;
    NSTimeInterval timeElapsed;
    
    //for items
    BOOL itemHasDroppedForThisPeriod;
    //CCNode *itemNode;
    CCNode* currItem;
    CCNode* chosenItem;
    CGPoint itemMid;
    CCNode* inventory;
    int itemsHeld;
    
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    
    //start game timer
    startTime = [NSDate date];
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    _physicsNode.collisionDelegate = self;
    
    //initializations
    validMove = NO;

    for(int i = DAVE; i < HUEY; i++) {
        falling[i] = NO;
        reviveCounter[i] = 0;
    }
    
    daveStart = _dave.position;
    hueyStart = _huey.position;
    princessStart = _princess.position;

    
    //intialize stage image for falloff detection
    CCRenderTexture *renderer =
        [CCRenderTexture renderTextureWithWidth:_stage.contentSize.width height:_stage.contentSize.height];
    _stage.anchorPoint = CGPointZero;
    [renderer begin];
    
    [_stage visit];
    
    [renderer end];
    
    uiimage = [renderer getUIImage];
    
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
    //[_physicsNode addChild:currItem];
    //itemNode.zOrder = _dave.zOrder + 1;
    
    inventory = [[CCNode alloc] init];
    [self addChild:inventory];
    
    inventory.position = ccp(INVENTORY_POSITION,INVENTORY_POSITION);
  
    for(int i = 0; i < 3; i++) {
        itemBox[i]=[CCBReader load: @"Box"];
        itemBox[i].scale *= 0.3;
        [inventory addChild: itemBox[i]];
        itemBox[i].position = ccp(INVENTORY_DISTANCE*i,0);
        itemBox[i].opacity *= 0.6;
    }
    
    itemsHeld = 0;
    
    //z orders
    currItem.zOrder = _stage.zOrder + ITEM_Z;
    _dave.zOrder = _stage.zOrder + DAVE_Z;
    _huey.zOrder = _stage.zOrder + HUEY_Z;
    _princess.zOrder = _stage.zOrder + PRINCESS_Z;
    
}

- (void)damping:(CCTime)delta {
    //damping && zorder check against princess
    if(falling[DAVE] == NO) [PhysicsManager doDamping:_dave :DAMPING];
    if(falling[HUEY] == NO) [PhysicsManager doDamping:_huey :DAMPING];
    if(falling[PRINCESS] == NO) [PhysicsManager doDamping:_princess :DAMPING_STATUE];
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
            [self dropItem];
        }
    }
    
    //kill item
    if(itemHasDroppedForThisPeriod == YES) {
        if((int)timeElapsed == ITEM_ALIVE_PERIOD) {
            [_physicsNode removeChild:currItem];
            itemHasDroppedForThisPeriod = NO;
        }
        else {
            if(CGRectContainsPoint([_dave boundingBox], currItem.position)) {
                //CCLOG(@"pickup\n");
                if(itemsHeld < 3) {
                    currItem.position = itemBox[itemsHeld].position;
                    [_physicsNode removeChild:currItem];
                    [inventory addChild:currItem];
                    itemsHeld++;
                    itemHasDroppedForThisPeriod = NO;
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


//items

- (void)dropItem {

    int randomNum = rand() % 2;
    switch(randomNum) {
        case BARREL:
            //CCLOG(@"\nBarrel Selected");
            currItem = [CCBReader load:@"Barrel"];
            break;
            
            
        case VOMIT:
           // CCLOG(@"\nVomit Selected");
            currItem = [CCBReader load:@"Vomit"];
            break;
    }
    [_physicsNode addChild:currItem];
    currItem.scale*=0.2;
    currItem.position = [self itemDisplay];

}

-(CGPoint)itemDisplay{
    
 //   CCLOG(@"\nReached this method");
    
    CGPoint MidPoint, vToMidPoint, MidPointPerp, result;
    
    MidPoint = ccpMidpoint(_dave.position, _huey.position);
    vToMidPoint = ccpSub(MidPoint,_dave.position);
    MidPointPerp = (rand()%2 == 0) ? ccp(-vToMidPoint.y, vToMidPoint.x) : ccp(vToMidPoint.y, -vToMidPoint.x);
    MidPointPerp = ccpNormalize(MidPointPerp);
    
    result = ccpAdd(MidPoint, ccpMult(MidPointPerp, 50+(rand()%100)));
    if([PhysicsManager detectFallOff:result :uiimage] == NO) {
        return result;
    }
    else {
        float r = 100;
        float theta = ((rand()%6)*(360/6))*PI/180;
        result = ccpAdd(princessStart,ccp(r*cos(theta),r*sin(theta)));
        return result;
    }
}

- (void)itemDropAnim:(CCTime)delta {
    
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
    
    
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    //CCLOG(@"touch moved");
    // whenever touches move, update the position of the mouseJointNode to the touch position
    if (validMove){
        CGPoint touchLocation = [touch locationInNode:self];
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
}

- (void)releaseTouch {
    
    if(validMove) {
        
        [MoveManager movePlayer:_dave :launchDirection];
    }
    
    validMove = NO;
    arrowNode.visible = NO;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches end, meaning the user releases their finger, release the catapult
    [self releaseTouch];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
    [self releaseTouch];
}




@end
