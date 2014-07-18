//
//  PhysicsManager.m
//  DrunkenKNights
//
//  Created by Student on 6/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "PhysicsManager.h"


@implementation PhysicsManager


+ (void) doDamping: (CCSprite*) player :(float) dampVal {
    if(player.physicsBody.velocity.x != 0 || player.physicsBody.velocity.y != 0) player.physicsBody.velocity = ccpMult(player.physicsBody.velocity, dampVal);
    if(ccpLengthSQ(player.physicsBody.velocity) < 0.000001) player.physicsBody.velocity = ccp(0,0);
    
}

+ (BOOL)detectFallOff:(CGPoint) pos :(UIImage*) uiimage {
    
    int x = pos.x;
    int y = pos.y;
    
    unsigned char pixel[1] = {0};
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1, 1, 8, 1, NULL,
                                                 (CGBitmapInfo)kCGImageAlphaOnly);
    UIGraphicsPushContext(context);
    [uiimage drawAtPoint:CGPointMake(-x, -y)];
    UIGraphicsPopContext();
    CGContextRelease(context);
    CGFloat alpha = pixel[0]/255.0;
    
    if(alpha < 0.001) {
        return YES;
    }
    else return NO;
    
}
@end
