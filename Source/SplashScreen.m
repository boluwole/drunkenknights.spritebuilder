//
//  SplashScreen.m
//  DrunkenKNights
//
//  Created by Apple User on 6/14/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "SplashScreen.h"


@implementation SplashScreen
{
    CCLabelTTF *_lblUpdate ;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    
    [self enterGame];
    
}

//generate UUID and login to appwarp uniquely
- (void)enterGame {
    
    
    [_lblUpdate setVisible:YES];
    
    
    //generate random string of 8 chars
    NSString *_playerName = [[[NSUUID UUID] UUIDString] substringToIndex:8];
    //NSString *_playerName = [[NSUUID UUID] UUIDString];

    
    //login player
    if(NETWORKED) {
        [[AppWarpHelper sharedAppWarpHelper] initializeAppWarp];
        [[AppWarpHelper sharedAppWarpHelper] connectToWarp : _playerName];
    }
    
    //callback for login status
    [self schedule:@selector(loginMonitor:) interval:1] ;

}


//check callback to see login result
- (void) loginMonitor:(CCTime)delta
{
    
    NSString *_status = [GameVariables getInitConnectionStatus];
    
    if ([ _status isEqualToString: @"connected" ])
    {
        
        [_lblUpdate setVisible:NO];
        CCScene *gameRoomScene = [CCBReader loadAsScene:@"GameRoom"];
        [[CCDirector sharedDirector] replaceScene:gameRoomScene];
        
        
        [self unschedule:@selector(loginMonitor:)];
    }
    else if ( [ _status isEqualToString: @"error" ])
    {
        [_lblUpdate setVisible:NO];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"We're really sorry."
                                                       message: @"There was a problem connecting.\n"
                                                      delegate: self
                                             cancelButtonTitle:@"Try again"
                                             otherButtonTitles:@"Close game",nil];
        
        
        [alert show];
        [self unschedule:@selector(loginMonitor:)];
    }

}


//delegate for alert on conneciton error
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    if (buttonIndex == 0) {
        [self enterGame];
    }
    else{
        exit(0);
    }
}

@end
