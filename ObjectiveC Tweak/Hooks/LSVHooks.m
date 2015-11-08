//
//  TWEView.m
//  ObjectiveC Tweak
//
//  Created by John Coates on 4/28/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import <Monolith/Monolith.h>
#import <objc/runtime.h>
#import "LSVOrientation.h"

static UIInterfaceOrientation currentOrientation = UIInterfaceOrientationLandscapeRight;
@interface LSV_AVPlayerViewController : NSObject <MONHook> @end
@implementation LSV_AVPlayerViewController

+ (NSArray *)targetClasses {
    return @[@"AVPlayerViewController", @"MPMoviePlayerViewController"];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations_hook:(MONCallHandler *)callHandler {
	return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
- (UIInterfaceOrientation)interfaceOrientation_hook:(MONCallHandler *)callHandler {
	return currentOrientation;
}

- (void)viewDidAppear:(BOOL)animated hook:(MONCallHandler *)callHandler {
	// remember original orientation
	objc_setAssociatedObject(self, "originalOrientation", @([UIDevice currentDevice].orientation), OBJC_ASSOCIATION_RETAIN);
	
	// register for updates
	currentOrientation = [LSVOrientation registerForOrientationUpdates:^(UIInterfaceOrientation newOrientation) {
		if (newOrientation == [self interfaceOrientation]) {
			// don't need to update
			return;
		}
		
		// force a landscape orientation, needs to be done in main thread
		dispatch_sync(dispatch_get_main_queue(), ^{
			currentOrientation = newOrientation;
			NSNumber *landscapeOrientation = [NSNumber numberWithInt:newOrientation];
			
			[[UIDevice currentDevice] setValue:landscapeOrientation forKey:@"orientation"];
			[UIViewController attemptRotationToDeviceOrientation];
		});
	}];
	
	// set orientation right away
	[[UIDevice currentDevice] setValue:@(currentOrientation) forKey:@"orientation"];
	[UIViewController attemptRotationToDeviceOrientation];
	
	[callHandler callOriginalMethod];
}

- (void)viewWillDisappear:(BOOL)animated hook:(MONCallHandler *)callHandler {
	NSNumber *originalOrientation = objc_getAssociatedObject(self, "originalOrientation");
	if (originalOrientation) {
		// return orientation to what it was
		[[UIDevice currentDevice] setValue:originalOrientation forKey:@"orientation"];
		// release saved orientation
		objc_setAssociatedObject(self, "originalOrentation", nil, OBJC_ASSOCIATION_RETAIN);
	}
	
	[callHandler callOriginalMethod];
	
	[LSVOrientation unregisterForOrientationUpdates];
}

// stub
- (UIInterfaceOrientation)interfaceOrientation {
	return 0;
}

@end
