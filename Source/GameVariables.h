//
//  GameVariables.h
//  DrunkenKNights
//
//  Created by Student on 6/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameVariables : NSObject

+(int) getItemIndex1;
+(int) getItemIndex2;
+(NSString*) getInitConnectionStatus;
+ (void) setItemIndex1 :(int) value ;
+ (void) setItemIndex2 :(int) value ;
+ (void) setInitConnectionStatus :(NSString*) value ;
@end
