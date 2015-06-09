//
//  TWEView.m
//  ObjectiveC Tweak
//
//  Created by John Coates on 4/28/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import <Monolith/Monolith.h>
#import <objc/runtime.h>

@interface LSV_AVPlayerViewController : MONHook @end
@implementation LSV_AVPlayerViewController

+ (NSString *)targetClass {
    return @"AVPlayerViewController";
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations_hook:(MONCallHandler *)callHandler {
	[callHandler callOriginalMethod];
	return UIInterfaceOrientationMaskLandscapeLeft;
}
- (UIInterfaceOrientation)interfaceOrientation_hook:(MONCallHandler *)callHandler {
	[callHandler callOriginalMethod];
	return UIInterfaceOrientationLandscapeLeft;
}

- (void)viewDidAppear:(BOOL)animated hook:(MONCallHandler *)callHandler {
	// remember original orientation
	objc_setAssociatedObject(self, "originalOrientation", @([UIDevice currentDevice].orientation), OBJC_ASSOCIATION_RETAIN);
	
	// force a landscape orientation
	NSNumber *landscapeOrientation = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
	[[UIDevice currentDevice] setValue:landscapeOrientation forKey:@"orientation"];
	
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
}


@end

@interface LSV_MPMoviePlayerViewController : MONHook @end
@implementation LSV_MPMoviePlayerViewController

+ (NSString *)targetClass {
	return @"MPMoviePlayerViewController";
}

- (UIInterfaceOrientation)interfaceOrientation_hook:(MONCallHandler *)callHandler {
	[callHandler callOriginalMethod];
	return UIInterfaceOrientationLandscapeLeft;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations_hook:(MONCallHandler *)callHandler {
	[callHandler callOriginalMethod];
	return UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)viewDidAppear:(BOOL)animated hook:(MONCallHandler *)callHandler {
	// remember original orientation
	objc_setAssociatedObject(self, "originalOrientation", @([UIDevice currentDevice].orientation), OBJC_ASSOCIATION_RETAIN);
	
	// force a landscape orientation
	NSNumber *landscapeOrientation = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
	[[UIDevice currentDevice] setValue:landscapeOrientation forKey:@"orientation"];
	
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
}

@end