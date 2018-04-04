//
//  MycollectionViewController.h
//  BaseProject
//
//  Created by cc on 2018/3/12.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

typedef enum CollectionType{
    Collection_Content = 0,
    Collection_Image = 1,
}CollectionType;

@interface MycollectionViewController : CCBaseViewController

@property (nonatomic, copy) void(^getCollectionBlock)(CollectionType type, NSString *content);

@end
