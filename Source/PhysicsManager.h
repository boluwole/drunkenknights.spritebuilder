//
//  PhysicsManager.h
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConstants.h"

@interface PhysicsManager : CCNode {

}

+ (void) doDamping: (CCSprite*) player :(float) dampVal;
+ (BOOL) detectFallOff:(CGPoint) pos :(UIImage*) uiimage;


@end
