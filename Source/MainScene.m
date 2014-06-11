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

#define DAVE 0
#define HUEY 1
#define PRINCESS 2

#define MOVE_SPEED (20)
#define VECTOR_CAP (150)
#define DAMPING (0.95)

#define PLAYER_REVIVE_TIME (3.0f)
#define STATUE_REVIVE_TIME (2.0f)

MainScene{
    CCPhysicsNode *_physicsNode;
    CCPhysicsNode *_backPhysicsNode;
    CCSprite *_dave;
    CCSprite *_huey;
    CCSprite *_princess;
    CCSprite *_stage;
    
    BOOL validMove;
    
    //drag vector for movement
    CGPoint start;
    CGPoint end;
    
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
    
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    //initializations
    validMove = NO;

    for(int i = DAVE; i < HUEY; i++) {
        falling[i] = NO;
        reviveCounter[i] = 0;
    }
    
    daveStart = _dave.position;
    hueyStart = _huey.position;
    princessStart = _princess.position;
    //daveZ = _dave.zOrder;
    //hueyZ = _huey.zOrder;
    //princessZ = _princess.zOrder;
    
    //intialize stage image for falloff detection
    CCRenderTexture *renderer =
        [CCRenderTexture renderTextureWithWidth:_stage.contentSize.width height:_stage.contentSize.height];
    _stage.anchorPoint = CGPointZero;
    [renderer begin];
    
    [_stage visit];
    
    [renderer end];
    
    uiimage = [renderer getUIImage];
    

    
}

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    //CCLOG(@"touch began");
    
    // start catapult dragging when a touch inside of the catapult arm occurs
    if (CGRectContainsPoint([_dave boundingBox], touchLocation))
        //&& abs(_dave.physicsBody.velocity.x) < 0.5 && abs(_dave.physicsBody.velocity.y) < 0.5)
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


- (BOOL)detectFallOff:(CCSprite*) player {
    
    int x = player.position.x;
    int y = player.position.y;
    
    unsigned char pixel[1] = {0};
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1, 1, 8, 1, NULL,
                                                 (CGBitmapInfo)kCGImageAlphaOnly);
    UIGraphicsPushContext(context);
    [uiimage drawAtPoint:CGPointMake(-x, -y)];
    UIGraphicsPopContext();
    CGContextRelease(context);
    CGFloat alpha = pixel[0]/255.0;

    if(alpha < 0.001) {
        return YES;
    }
    else return NO;

}


- (void)update:(CCTime)delta {
    
    //detect falloff
    if([self detectFallOff:_dave]) {
        if(falling[DAVE] == NO) [self dropPlayer:_dave :DAVE];
    }
    if([self detectFallOff:_huey]) {
        if(falling[HUEY] == NO) [self dropPlayer:_huey :HUEY];
    }
    if([self detectFallOff:_princess]) {
        if(falling[PRINCESS] == NO) [self dropPlayer:_princess :PRINCESS];
    }
    
    if(_dave.physicsBody.velocity.x < 0) {
        if(_dave.scaleX > 0) _dave.scaleX *= -1;
    }
    else {
        if(_dave.scaleX < 0) _dave.scaleX *= -1;
    }
    
    //damping
    if(falling[DAVE] == NO) {
        if(_dave.physicsBody.velocity.x != 0 || _dave.physicsBody.velocity.y != 0) _dave.physicsBody.velocity = ccpMult(_dave.physicsBody.velocity, DAMPING);
    }
    if(falling[HUEY] == NO) {
        if(_huey.physicsBody.velocity.x != 0 || _huey.physicsBody.velocity.y != 0) _huey.physicsBody.velocity = ccpMult(_huey.physicsBody.velocity, DAMPING);
    }
    if(falling[PRINCESS] == NO) {
        if(_princess.physicsBody.velocity.x != 0 || _princess.physicsBody.velocity.y != 0) _princess.physicsBody.velocity = ccpMult(_princess.physicsBody.velocity, DAMPING);
    }
    
}

//drops the player, sends it behind the platform
- (void)dropPlayer: (CCNode*) player : (int) playerNum {
    
    player.zOrder = _stage.zOrder - 1;
    player.physicsBody.collisionMask = @[];
    
    CGPoint launchDirection = ccp(0, -1);
    float fallSpeed = (playerNum < PRINCESS) ? 6000 : 10000;
    CGPoint impulse = ccpMult(launchDirection, fallSpeed);
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
        _dave.zOrder = _stage.zOrder + 1;
        _princess.zOrder = _dave.zOrder + 1;
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
        _huey.zOrder = _stage.zOrder + 1;
        _princess.zOrder = _huey.zOrder + 1;
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
        _princess.zOrder = _stage.zOrder + 1;
        _princess.position = princessStart;
        _princess.physicsBody.collisionMask = NULL;
        _princess.physicsBody.velocity = ccp(0,0);
        [self unschedule:@selector(revivePrincess:)];
    }
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //CCLOG(@"touch moved");
    // whenever touches move, update the position of the mouseJointNode to the touch position
    if (validMove){
        CGPoint touchLocation = [touch locationInNode:self];
        end = touchLocation;
    }
}

- (void)releaseTouch {
    
    if(validMove) {
        
        //CGPoint touchLocation = [touch locationInNode:self];
        //end = touchLocation;
        [self movePlayer:_dave];
    }
    
    validMove = NO;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //CCLOG(@"touch end");
    // when touches end, meaning the user releases their finger, release the catapult
    [self releaseTouch];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    //CCLOG(@"touch cancel");
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
    [self releaseTouch];
}



- (double)getLength: (CGPoint) v{
    
    return sqrt((v.x*v.x) + (v.y*v.y));
    
}

- (CGPoint)normalize: (CGPoint) v{
    
    return ccpMult(v, 1/[self getLength:v]);
    
}

- (void)movePlayer: (CCNode *) player {
    
    // manually create & apply a force to launch the knight
    
    CGPoint launchDirection = ccpSub(start, end);
    double len = [self getLength:launchDirection];
    //CCLOG(@"vector %f",len);
    
    if(len > VECTOR_CAP) {
        launchDirection = [self normalize:launchDirection];
        launchDirection = ccpMult(launchDirection, VECTOR_CAP);
    }
    
    CGPoint impulse = ccpMult(launchDirection, MOVE_SPEED);

    [player.physicsBody applyImpulse:impulse];
    
}

@end
