//
//  NFStoryBoardManager.h
//  Cocos2DSimpleGame
//
//  Created by shephertz technologies on 14/03/13.
//
//

#import <Foundation/Foundation.h>
#import "MainScene.h"

@class LeaderBoardViewController;
@class UserNameController;
@class FNGameLogicLayer;
@interface NFStoryBoardManager : NSObject
{
    LeaderBoardViewController *leaderboardController;
    UserNameController        *userNameController;
    //FNGameLogicLayer          *gameLogicLayer;
    UIView                    *pauseView;
    //CGPoint _New_impulse;

}

@property NSString* game_start;
//Position
@property CGPoint huey_position;
@property CGPoint dave_position;
@property CGPoint princess_position;
@property NSString* zorder_huey;
@property NSString* zorder_dave;
@property NSString* zorder_princess;
@property NSString* falling_huey;
@property NSString* falling_dave;
@property CGPoint velocity_huey;
@property CGPoint velocity_dave;

//opponent name
@property NSString* opponentname;

//Item
@property NSString* Item_info;
@property NSString* item_name;
@property CGPoint item_position;
//Activated Item
@property NSString* ActivatedItem_name;
@property CGPoint ActivatedItem_position;
@property NSString* player_info;

@property NSString* deActivatedItem_name;
@property CGPoint deActivatedItem_position;
@property NSString* deplayer_info;
@property NSString* item_index;
//sound stuff
@property NSString* sounds;
//drunkness for bubble
@property NSString* daveDrunkIndex;
@property NSString* hueyDrunkIndex;
//
@property CGPoint New_impulse;



@property (nonatomic,assign) FNGameLogicLayer          *gameLogicLayer;

+(NFStoryBoardManager *)sharedNFStoryBoardManager;

-(void)updateInformation:(NSDictionary*)dataDict;
-(CGPoint)getImpulse;
-(void)showLeaderBoardView;
-(void)removeLeaderBoardView;
-(void)showUserNameView;
-(void)removeUserNameView;
-(void)showGameLoadingIndicator;
-(void)removeGameLoadingIndicator;
-(void)updatePlayerDataToServerWithDataDict:(NSDictionary*)dataDict;
-(void)showPausedView:(NSString*)messageString;
-(void)removePausedView;

@end
