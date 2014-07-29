
static UIImage* uiimage;
static CCSprite *_dave;
static CCSprite *_huey;
static CCSprite *_princess;
static CCSprite *_player;
//static int roomPosition;


#define ROOM_REFRESH (0.1)
#define PI (3.14159265359)

#define DAVE 0
#define HUEY 1
#define PRINCESS 2

#define PLAYER_H (250)
#define PLAYER_W (150)

#define DAVE_START ccp(105,160)
#define HUEY_START ccp(465,160)
#define PRINCESS_START ccp(285,160)
#define PRINCESS_END ccp(60,150);


//MOVEMENT
#define MOVE_SPEED (5)  //originally 20
#define VECTOR_CAP (150)
//#define VELOCITY_CAP (
#define VELOCITY_DIFF_CAP (200)
#define VELOCITY_CAP_FACTOR (1)
#define DAMPING (0.978)
#define DAMPING_STATUE (0.9)

#define PLAYER_REVIVE_TIME (3.0f)
#define STATUE_REVIVE_TIME (2.0f)

//Magician Spells
#define MAGICIAN_INTERFERENCE (30)
#define DURATION_STONES_MOVE (0.1)
#define DISTANCE_RESS_STONES_MOVE (20)
#define DISTANCE_FROM_PRINCESS_START (80)


//clouds
#define CLOUD1_POSN ccp(0,0)


//items
#define TIME_FOR_ITEM_ACTIVATION (0)
#define ITEM_DROP_PERIOD (12)
#define ITEM_ALIVE_PERIOD (-4)
#define INVENTORY_DISTANCE (55)
#define INVENTORY_POSITION (30)
#define DAVE_RESS ccp(55,160)
#define HUEY_RESS ccp(515,160)
#define PRINCESS_GHOST_PERIOD (5)
#define Slime_LIFE (-7)
#define Slime_MULTIPLIER (2.0)

#define NUM_BEER_NODES (4)
#define BEER_BOTTLE_RESPAWN_TIME (10)
#define DRUNK_METER_CAP (50)
#define BUZZ_LEVEL (30)

#define ARROW_DOTS (10)

//zOrder
#define DAVE_Z (2)
#define HUEY_Z (2)
#define ITEM_Z (1)
#define PRINCESS_Z (3)
#define INVENTORY_Z (5)

//Shadow
#define SHADOW_OFFSET ccp(80,20)

//Gong
#define GONG_POSITION ccp(285,295)
#define GONG_DURATION (10)
#define GONG_COOLDOWN (25)


//Wheel
#define CD_WHEEL_POSITION ccp(510,50)
#define ARROW_POSN ccp(510,95)

//Portal
#define PORTAL_POSITION_MAIN ccp(300,30)

//networking
#define NETWORKED YES

#define APPWARP_APP_KEY     @"85faf7f29c1ca6c43991cdcbabf81738b0fc3e4db4730fe138e5fc0c776734c1"
#define APPWARP_SECRET_KEY  @"3a37f88e7db04ead6a809e74fef33213cac24f362786c4b875e888c3ebc69580"

#define GAME_NAME           @"TESTT112"
#define ROOM_NAME           @"ROOM!"
#define ROOM_OWNER          @"ETHAN"
#define MAX_PLAYER          2
#define GAME_OVER_TIME      300.0f //In Seconds

#define USER_NAME           @"userName"
#define PLAYER_POSITION     @"playerPositon"
#define PROJECTILE_DESTINATION    @"projectileDest"
#define MOVEMENT_DURATION    @"realMoveDuration"


#define MAX_NUMBER_OF_RECORDS_DISPLAYED_IN_LB   20


