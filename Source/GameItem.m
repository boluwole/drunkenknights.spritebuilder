//
//  GameItem.m
//  DrunkenKNights
//
//  Created by Student on 6/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameItem.h"
#import "GameItemData.h"


NSMutableArray* _allGameItems;

@implementation GameItem
{
}


+(void) initialize{
    
    
     _allGameItems = [[NSMutableArray alloc] init];
    
    GameItemData *item;
    item = [[GameItemData alloc] init];
    //load barrel
    item.itemName = @"Barrel";
    item.itemImage = @"Assets/barrel.png";
    item.itemDescription = @"Block enemies with this barrel o' ale.";
    
    [_allGameItems addObject: item];
    
    //load Slime
    item = [[GameItemData alloc] init];
    
    item.itemName = @"Slime";
    item.itemImage = @"Assets/vomit.png";
    item.itemDescription = @"Fast fools lose control on this yucky muck.";
    
    [_allGameItems addObject: item];
    
    //load ghost
    item = [[GameItemData alloc] init];
    
    item.itemName = @"Ghost";
    item.itemImage = @"Assets/ghost.png";
    item.itemDescription = @"Now your enemy can pass through the statue.";
    
    [_allGameItems addObject: item];
    
    
}

+(NSArray*) getGameItems{
    return _allGameItems;
}


@end
