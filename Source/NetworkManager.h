//
//  NetworkManager.h
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "NFStoryBoardManager.h"
#import "MainScene.h"
#import "ManagerIncludes.h"

@interface NetworkManager : CCNode {
    
}



+ (void) sendCGPointToServer:(CGPoint) msg;
+ (void) receiveCGPointFromServer:(CGPoint) msg;


@end
