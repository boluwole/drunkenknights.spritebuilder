//
//  RemoteRoomData.h
//  DrunkenKNights
//
//  Created by Bankole O on 6/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteRoomData : NSObject

    @property NSString* roomId;
    @property NSString* roomName;
    @property NSMutableArray* roomOccupants;

@end
