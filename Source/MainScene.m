//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene{
    CCPhysicsNode *_physicsNode;
    CCSprite *_dave;
    CCSprite *_huey;
    CCSprite *_princess;
    CCNode* _mouseJointNode;
    CCNode* _fixedJointNode;
    CCPhysicsJoint* _mouseJoint;
    CCPhysicsJoint* _fixedJoint;
    CCSprite *_stage;
    BOOL validMove;
    CGPoint location;
    
    CGPoint start;
    CGPoint end;
    
    
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    //[_physicsNode addChild:_dave];
    //[_physicsNode addChild:_huey];
    
    //setup a fixed node at dave's position
    _fixedJointNode.position = _dave.position;
    
    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    
    validMove = NO;
    
    _physicsNode.collisionDelegate = self;
    _stage.physicsBody.collisionType = @"stage";
}

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    CCLOG(@"touch began");
    
    // start catapult dragging when a touch inside of the catapult arm occurs
    if (CGRectContainsPoint([_dave boundingBox], touchLocation))
    {
        validMove = YES;
        
        
        // dave and nodes shall not collide
        _mouseJointNode.physicsBody.collisionMask = @[];
        _fixedJointNode.physicsBody.collisionMask = @[];
        
        
        //setup a fixed node at dave's position
        _fixedJointNode.position = _dave.position;
        
        // move the mouseJointNode to the touch position
        _mouseJointNode.position = touchLocation;
        
        //create a fixed joint to hold dave in place with the fixed node
        _fixedJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:_fixedJointNode.physicsBody bodyB:_dave.physicsBody anchorA:_dave.anchorPointInPoints];
        
        // setup a spring joint between the mouseJointNode and the dave
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_dave.physicsBody anchorA:ccp(0, 0) anchorB:ccp(72, 60) restLength:0.f stiffness:12000.f damping:150.f];
    
        location = touchLocation;
        
        start = touchLocation;
        end = touchLocation;
        
    }
    else
    {
        validMove = NO;
    }
    
    //[self movePlayer:_dave];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair stage:(CCNode *)nodeA wildcard:(CCNode *)nodeB
{
    CCLOG(@"Something collided with a stage!");
}

- (void)update:(CCTime)delta {
    
    if (validMove){
        _mouseJointNode.position = location;
    }

}

- (void)updateMouseJoint:(CGPoint) loc {
    
    _mouseJointNode.position = loc;
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"touch moved");
    // whenever touches move, update the position of the mouseJointNode to the touch position
    if (validMove){
        CGPoint touchLocation = [touch locationInNode:self];
        _mouseJointNode.position = touchLocation;
        location = touchLocation;
        end = touchLocation;
    }
}

- (void)releaseTouch {
    CCLOG(@"touch release");
    if (_mouseJoint != nil)
    {
        // releases the joint and lets the catapult snap back
        [_mouseJoint invalidate];
        _mouseJoint = nil;
        
        [_fixedJoint invalidate];
        _fixedJoint = nil;
        
        //[self movePlayer:_dave];
    }
    
    if(validMove) {
        
        //CGPoint touchLocation = [touch locationInNode:self];
        //end = touchLocation;
        [self movePlayer:_dave];
    }
    
    validMove = NO;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"touch end");
    // when touches end, meaning the user releases their finger, release the catapult
    [self releaseTouch];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"touch cancel");
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
    [self releaseTouch];
}

- (void)movePlayer: (CCNode *) player {
    
    // manually create & apply a force to launch the knight
    //CGPoint launchDirection = ccp(1, 0);
    //CGPoint impulse = ccpMult(launchDirection, 300);
    //[player.physicsBody applyImpulse:impulse];
    
    CGPoint launchDirection = ccpSub(start, end);
    CGPoint impulse = ccpMult(launchDirection, 5);
    [player.physicsBody applyImpulse:impulse];
    
}

@end
