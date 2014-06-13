//
//  AppWarpHelper.h
//  Cocos2DSimpleGame
//
//  Created by Rajeev on 25/01/13.
//
//

#import <Foundation/Foundation.h>
#import "Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h"
#import "cocos2d.h"

@interface AppWarpHelper : CCNode
{
    ServiceAPI *serviceAPIObject;
    int numberOfPlayers;
    NSTimer *timer;
}
@property(nonatomic,retain) id delegate;
@property (nonatomic,retain) NSString *roomId;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *emailId;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *enemyName;
@property (nonatomic,assign) BOOL     alreadyRegistered;
@property (nonatomic,assign) int      score;
@property (nonatomic,assign) int      numberOfPlayers;

+(AppWarpHelper *)sharedAppWarpHelper;
-(void)initializeAppWarp;
-(void)setCustomDataWithData:(NSData*)data;
-(void)receivedStatusData:(NSData*)data;
//-(void)updateInformation:(NSDictionary*)dataDict;
//-(CGPoint)updatePosition;
-(void)getAllUsers;
-(BOOL)registerUser;
-(BOOL)signInUser;
-(void)saveScore;
-(NSMutableArray*)getScores;

-(void)disconnectWarp;
-(void)connectToWarp;
-(void)recoverConnection;
-(void)scheduleRecover;
-(void)unScheduleRecover;
-(void)onConnectionFailure:(NSDictionary*)messageDict;
@end
