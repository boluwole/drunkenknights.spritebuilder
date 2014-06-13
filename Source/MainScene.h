//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

#define PI (3.14159265359)

#define DAVE 0
#define HUEY 1
#define PRINCESS 2

#define MOVE_SPEED (20)
#define VECTOR_CAP (150)
#define DAMPING (0.978)
#define DAMPING_STATUE (0.8)

#define PLAYER_REVIVE_TIME (3.0f)
#define STATUE_REVIVE_TIME (2.0f)

//items
#define ITEM_DROP_PERIOD (-10)
#define ITEM_ALIVE_PERIOD (-8)
#define INVENTORY_DISTANCE (40)
#define INVENTORY_POSITION (30)

#define ARROW_DOTS 10

//zOrder
#define DAVE_Z 2
#define HUEY_Z 2
#define ITEM_Z 1
#define PRINCESS_Z 3

@interface MainScene : CCNode <CCPhysicsCollisionDelegate>

//@property (nonatomic, retain) int time;

@end
