//
//  ItemShop.h
//  DrunkenKNights
//
//  Created by Apple User on 6/14/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ManagerIncludes.h"
#import "GameConstants.h"

@interface ItemShop : CCNode  <UIAlertViewDelegate> {
    
}

- (void) loadItem: (int) itemIndex : (CCSprite*) loadableItem;

@end
