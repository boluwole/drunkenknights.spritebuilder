//
//  NFStoryBoardManager.m
//  Cocos2DSimpleGame
//
//  Created by shephertz technologies on 14/03/13.
//
//

#import "NFStoryBoardManager.h"
//#import "LeaderBoardViewController.h"
#import "AppDelegate.h"
#import "cocos2d.h"
//#import "UserNameController.h"
#import "AppWarpHelper.h"
//#import "FNGameLogicLayer.h"
#import "MainScene.h"


static NFStoryBoardManager *nFStoryBoardManager;

@implementation NFStoryBoardManager
@synthesize gameLogicLayer;

+(NFStoryBoardManager *)sharedNFStoryBoardManager
{
	if(nFStoryBoardManager == nil)
	{
		nFStoryBoardManager = [[self alloc] init];
	}
	return nFStoryBoardManager;
}

- (id) init
{
	self = [super init];
	if (self != nil)
    {
        leaderboardController = nil;
        userNameController    = nil;
	}
	return self;
}


-(void)updatePlayerDataToServerWithDataDict:(NSDictionary*)dataDict
{
    if(!dataDict)
		return;
	
	NSError *error = nil;
	//converting the content to plist supported binary format.
	NSData *convertedData = [NSPropertyListSerialization dataWithPropertyList:dataDict format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
	
	if(error || ! convertedData)
	{
		NSLog(@"DataConversion Failed.ErrorDescription: %@",[error description]);
		return;
	}
    [[AppWarpHelper sharedAppWarpHelper] setCustomDataWithData:convertedData];
}

-(void)updateInformation:(NSDictionary*)dataDict
{
    CCLOG(@"==updateInformation==");
    
    if([[GameVariables getCurrentScene] isEqual:@"ItemShop"]) {
        _game_start = [dataDict objectForKey:@"game_start"];
        [NetworkManager receiveGameStart:_game_start];
        
        //---opponent name
        _opponentname = [dataDict objectForKey:@"opponent_name"];
        [NetworkManager updateNameFromServer:_opponentname];
    }
    
    if([[GameVariables getCurrentScene] isEqual:@"MainScene"]) {
    //---Movement---
    _huey_position = CGPointFromString([dataDict objectForKey:@"position_huey"]);
    _dave_position = CGPointFromString([dataDict objectForKey:@"position_dave"]);
    _princess_position = CGPointFromString([dataDict objectForKey:@"position_princess"]);
    _zorder_dave = [dataDict objectForKey:@"zorder_dave"];
    _zorder_huey = [dataDict objectForKey:@"zorder_huey"];
    _zorder_princess = [dataDict objectForKey:@"zorder_princess"];
    _falling_huey = [dataDict objectForKey:@"falling_huey"];
    _falling_dave = [dataDict objectForKey:@"falling_dave"];
    _velocity_huey = CGPointFromString([dataDict objectForKey:@"velocity_huey"]);
    _velocity_dave = CGPointFromString([dataDict objectForKey:@"velocity_dave"]);
        [NetworkManager receiveEveryPositionFromServer:_huey_position poitionDave:_dave_position poitionPrincess:_princess_position :_zorder_huey :_zorder_dave :_zorder_princess :_falling_huey :_falling_dave :_velocity_huey :_velocity_dave];
    
    
    
        
    //---Item
    _Item_info = [dataDict objectForKey:@"item_info"];
    [NetworkManager updateItemInfoFromServer:_Item_info];
    
    
    //---Item Name & Position---
    _item_position = CGPointFromString([dataDict objectForKey:@"item_position"]);
    _item_name = [dataDict objectForKey:@"item_name"];
    [NetworkManager updateItemsFromServer:_item_position name:_item_name];
    

    _ActivatedItem_name = [dataDict objectForKey:@"activateditem_name"];
    _ActivatedItem_position = CGPointFromString([dataDict objectForKey:@"activateditem_position"]);
    _player_info = [dataDict objectForKey:@"player_info"];

    [NetworkManager activateItemsFromServer:_ActivatedItem_name iPosition:_ActivatedItem_position playerInfo:_player_info];
    
    
    _deActivatedItem_name = [dataDict objectForKey:@"deActivatedItem_name"];
    _deActivatedItem_position = CGPointFromString([dataDict objectForKey:@"deActivatedItem_position"]);
    _deplayer_info = [dataDict objectForKey:@"deplayer_info"];
    _item_index = [dataDict objectForKey:@"index_info"];
    [NetworkManager deActivateItemsFromServer:_deActivatedItem_name iPosition:_deActivatedItem_position playerInfo:_deplayer_info iIndex:_item_index];

    
    _New_impulse = CGPointFromString([dataDict objectForKey:@"impulse"]);
    // NSLog(@"Testtt %@", NSStringFromCGPoint( _New_impulse));
    [NetworkManager receiveCGPointFromServer:_New_impulse];
        
    //sound stuff
    _sounds = [dataDict objectForKey:@"sounds"];
    [NetworkManager updateMainSceneSound:_sounds];
        
    //drunkness for bubble
    _daveDrunkIndex = [dataDict objectForKey:@"dave_drunkness"];
    _hueyDrunkIndex = [dataDict objectForKey:@"huey_drunkness"];
    [NetworkManager updateDaveDrunkIndex:_daveDrunkIndex];
    [NetworkManager updateHueyDrunkIndex:_hueyDrunkIndex];
    }
    
}

-(void)moveDave:(CGPoint) im{
    //    [self movePlayer:_dave];
    //NSLog(@"MOVEDAVE");
    //NSLog(@"=%@", NSStringFromCGPoint(im));
    //NSLog(@"TESTETSETSE= %@", NSStringFromCGPoint(start));
    //[_dave.physicsBody applyImpulse: im];
}

/*
-(CGPoint)getImpulse{
    NSLog(@"=getImpulse CGpoint %f, %f", _New_impulse.x, _New_impulse.y);
    [[MainScene sharedMainScene] movePlayer: [[MainScene sharedMainScene] dave]];
    return _New_impulse;
}
*/
//---------------
#pragma mark--------
#pragma mark --- Leaderboard Methods ---
#pragma mark--------

-(void)showLeaderBoardView
{
    if (leaderboardController)
    {
        //[leaderboardController.view removeFromSuperview];
        //[leaderboardController release];
        leaderboardController = nil;
    }
    [[CCDirector sharedDirector] pause];
    //leaderboardController = [[LeaderBoardViewController alloc] initWithNibName:@"LeaderBoardViewController" bundle:nil];
    NSLog(@"%@",leaderboardController);
    //[[[(AppDelegate*)[[UIApplication sharedApplication] delegate] ] view] addSubview:leaderboardController.view];
    //AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
    //[app.navController.view addSubview:leaderboardController.view];
}



-(void)removeLeaderBoardView
{
    if (leaderboardController)
    {
        //[leaderboardController.view removeFromSuperview];
        //[leaderboardController release];
        leaderboardController = nil;
    }
    [[CCDirector sharedDirector] resume];
}

-(void)showUserNameView
{
    if (userNameController)
    {
        //[userNameController.view removeFromSuperview];
        //[userNameController release];
        userNameController = nil;
    }
    [[CCDirector sharedDirector] pause];
    //userNameController = [[UserNameController alloc] initWithNibName:@"UserNameController" bundle:nil];
    //AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
    //[app.navController.view addSubview:userNameController.view];
}

-(void)removeUserNameView
{
    if (userNameController)
    {
//        [userNameController.view removeFromSuperview];
//        [userNameController release];
        userNameController = nil;
    }
    
    [[CCDirector sharedDirector] resume];
    if ([[CCDirector sharedDirector] runningScene])
    {
//        [[CCDirector sharedDirector] replaceScene: [FNGameLogicLayer scene]];
    }
    else
    {
//        [[CCDirector sharedDirector] runWithScene: [FNGameLogicLayer scene]];
    }
    
}

-(void)showGameLoadingIndicator
{
//    [userNameController showAcitvityIndicator];
//    [[AppWarpHelper sharedAppWarpHelper] connectToWarp];
}

-(void)removeGameLoadingIndicator
{
//    [userNameController removeAcitvityIndicator];
    [self removeUserNameView];
}


-(void)showPausedView:(NSString*)messageString
{
//    CGSize size = [[CCDirector sharedDirector] winSize];
//    pauseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    pauseView.backgroundColor = [UIColor clearColor];
//    AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
//    [app.navController.view addSubview:pauseView];
////    [pauseView release];
//    
////    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    [bgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
//    [pauseView addSubview:bgView];
//    [bgView release];
//    
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    [indicator setCenter:pauseView.center];
//    indicator.tag = 10;
//    [pauseView addSubview:indicator];
    
    
//    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, pauseView.center.y+60, size.width, 100)];
//    message.backgroundColor = [UIColor clearColor];
//    message.textAlignment=UITextAlignmentCenter;
//    message.textColor = [UIColor whiteColor];
//    message.text = messageString;
//    [pauseView addSubview:message];
//    [message release];
    
    //[indicator startAnimating];
}

-(void)removePausedView
{
    if (pauseView)
    {
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[pauseView viewWithTag:10];
        [indicator stopAnimating];
        [pauseView removeFromSuperview];
        pauseView=nil;
        [[CCDirector sharedDirector] resume];
    }
}

@end
