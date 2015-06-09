//
//  LSVOrientation.m
//  Landscape Videos
//
//  Created by John Coates on 6/9/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import "LSVOrientation.h"
#import <CoreMotion/CoreMotion.h>

static NSArray *_motionManagers;
static NSLock *_localLock;

@implementation LSVOrientation

+ (UIInterfaceOrientation)registerForOrientationUpdates:(orientationChangedBlock)block {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_localLock = [NSLock new];
		_motionManagers = @[];
	});
	CMMotionManager *motionManager = [CMMotionManager new];
	[_localLock lock];
	NSMutableArray *motionManagers = [_motionManagers mutableCopy];
	[motionManagers addObject:motionManager];
	_motionManagers = motionManagers;
	
	motionManager.accelerometerUpdateInterval = 0.2;
	[motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
		@autoreleasepool {
		if (accelerometerData != nil) {
			if (accelerometerData.acceleration.x >= 0.75){
				block(UIInterfaceOrientationLandscapeLeft);
			}
			else if (accelerometerData.acceleration.x <= -0.75) {
				block(UIInterfaceOrientationLandscapeRight);
			}
		}
		}
	}];
	
	[_localLock unlock];
	
	if (motionManager.accelerometerData.acceleration.x > 0) {
		return UIInterfaceOrientationLandscapeLeft;
	}else {
		return UIInterfaceOrientationLandscapeRight;
	}
}
+ (void)unregisterForOrientationUpdates {
	[_localLock lock];
	
	// stop all motion managers
	for (CMMotionManager *motionManager in _motionManagers) {
		[motionManager stopAccelerometerUpdates];
	}
	
	// remove all motion managers
	_motionManagers = @[];
	
	[_localLock unlock];
	
}
@end
