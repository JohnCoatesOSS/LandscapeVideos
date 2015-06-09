//
//  OBJCPluginExample.m
//  ObjectiveC Tweak
//
//  Created by John Coates on 6/8/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import "LSVPlugin.h"

@implementation LSVPlugin

+ (NSString *)name {
	return @"Landscape Videos";
}

+ (BOOL)shouldLoadIntoProcess:(MONProcess *)process {
	return YES; // Load into every process
	
}
@end
