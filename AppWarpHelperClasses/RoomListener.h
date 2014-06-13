//
//  RoomListener.h
//  AppWarp_Project
//
//  Created by Shephertz Technology on 06/08/12.
//  Copyright (c) 2012 ShephertzTechnology PVT LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppWarpHelper.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>

@interface RoomListener : NSObject <RoomRequestListener>

@property (nonatomic,retain)id helper;


-(id)initWithHelper:(id)l_helper;



@end
