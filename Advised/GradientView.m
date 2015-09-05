//
//  GradientView.m
//  Snappr
//
//  Created by Sebastian Cain on 5/23/15.
//  Copyright (c) 2015 Joshua Liu. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

-(void)drawRect:(CGRect)rect {
	
	CGContextRef ref = UIGraphicsGetCurrentContext();
	
	UIColor *darkGradientColor = [UIColor colorWithRed:0.376 green:0.424 blue:0.533 alpha:1.0]; /*#606c88*/
	UIColor *lightGradientColor = [UIColor colorWithRed:0.247 green:0.298 blue:0.42 alpha:1.0]; /*#3f4c6b*/
	
	CGFloat locations[2] = {0.0, 1.0};
	CFArrayRef colors = (__bridge CFArrayRef) [NSArray arrayWithObjects:(id)lightGradientColor.CGColor,(id)darkGradientColor.CGColor,nil];
	
	CGColorSpaceRef colorSpc = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpc, colors, locations);
	
	CGContextDrawLinearGradient(ref, gradient, CGPointMake(0.0, 0.0), CGPointMake(self.frame.size.width, self.frame.size.height), kCGGradientDrawsAfterEndLocation);
	
	CGColorSpaceRelease(colorSpc);
	CGGradientRelease(gradient);
	
	UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[overlayView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
	[self addSubview:overlayView];
}

@end
