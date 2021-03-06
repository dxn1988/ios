//
//  Bullet.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"
#import "LinearMotion.h"
#import "ExpireAfterTime.h"

@implementation Bullet
@synthesize damage;

+(id)bulletAt:(CGPoint)aCenter WithDirection:(float)aDirection{
    
    VectorRepresentation* rep = [VectorRepresentation vectorRepresentation];
    
    Bullet* bullet = [[Bullet alloc] initAt:aCenter WithRadius:4 AndRepresentation:rep];
    [rep setDelegate:bullet];
    
    [bullet setDamage: 10];
    
    LinearMotion* motion = [LinearMotion linearMotionInDirection:aDirection AtSpeed:3];
    [motion setWrap:YES];
    
    [bullet addBehavior: motion];
    
    ExpireAfterTime* expires = [ExpireAfterTime expireAfter:240];
    [bullet addBehavior:expires];
    
    return bullet;
}
-(void)setDamage:(float)aDamage{
    if (damage != aDamage){
        damage = aDamage;
        
        if (damage >= 30){
            [self setRadius: 8];
        } else if (damage >= 20){
            [self setRadius: 6];
        } else {
            [self setRadius: 4];
        }
        
        self.needsViewUpdated = YES;
    }
}
-(void)drawActor:(Actor*)anActor WithContext:(CGContextRef)context InRect:(CGRect)rect{

    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    CGFloat locations[2];
    
    locations[0] = 0.0;
    locations[1] = 1.0;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    UIColor* color1 = nil;
    UIColor* color2 = nil;
    
    if (damage >= 30){
        color1 = [UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:1.0];
        color2 = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    } else if (damage >= 20){
        color1 = [UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:1.0];
        color2 = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    } else {
        color1 = [UIColor colorWithRed:0.8 green:0.8 blue:1.0 alpha:1.0];
        color2 = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    }

    CGColorRef clr[] = { [color1 CGColor], [color2 CGColor] };
    CFArrayRef colors = CFArrayCreate(NULL, (const void**)clr, sizeof(clr) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
    
    
    
    
    CGGradientRef grad = CGGradientCreateWithColors(space, colors, locations);
    CGColorSpaceRelease(space);
    
    CGContextDrawLinearGradient(context, grad, rect.origin, CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height), 0);
    
    CGGradientRelease(grad);
}
@end
