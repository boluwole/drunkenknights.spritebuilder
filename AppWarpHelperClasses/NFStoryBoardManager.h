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

@property NSString* Random_num;
//Position
@property CGPoint huey_position;
@property CGPoint dave_position;
@property CGPoint princess_position;
//Item
@property NSString* Item_info;
@property NSString* item_name;
@property CGPoint item_position;
//Activated Item
@property NSString* ActivatedItem_name_dave;
@property NSString* ActivatedItem_name_huey;
@property CGPoint ActivatedItem_position_dave;
@property CGPoint ActivatedItem_position_huey;

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
