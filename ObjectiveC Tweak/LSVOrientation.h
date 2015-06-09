//
//  LSVOrientation.h
//  Landscape Videos
//
//  Created by John Coates on 6/9/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^orientationChangedBlock)(UIInterfaceOrientation newOrientation);

@interface LSVOrientation : NSObject

+ (UIInterfaceOrientation)registerForOrientationUpdates:(orientationChangedBlock)block;
+ (void)unregisterForOrientationUpdates;
@end
