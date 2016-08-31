//
//  Balljoint.m
//  ComputerAnimationAssignment2
//
//  Created by Austin Schwartz on 9/29/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import "Balljoint.h"

@implementation Balljoint

- (Balljoint*)initWithName:(NSString*)theName {
    
    _name = theName;
    
    _offset = [[NSMutableDictionary alloc] init];
    [_offset setObject:@([[[NSNumber alloc] initWithDouble:0.0] doubleValue]) forKey:@"X"];
    [_offset setObject:@([[[NSNumber alloc] initWithDouble:0.0] doubleValue]) forKey:@"Y"];
    [_offset setObject:@([[[NSNumber alloc] initWithDouble:0.0] doubleValue]) forKey:@"Z"];
    
    _boxmin = [[NSMutableDictionary alloc] init];
    [_boxmin setObject:@([[[NSNumber alloc] initWithDouble:-0.1] doubleValue]) forKey:@"X"];
    [_boxmin setObject:@([[[NSNumber alloc] initWithDouble:-0.1] doubleValue]) forKey:@"Y"];
    [_boxmin setObject:@([[[NSNumber alloc] initWithDouble:-0.1] doubleValue]) forKey:@"Z"];
    
    _boxmax = [[NSMutableDictionary alloc] init];
    [_boxmax setObject:@([[[NSNumber alloc] initWithDouble:0.1] doubleValue]) forKey:@"X"];
    [_boxmax setObject:@([[[NSNumber alloc] initWithDouble:0.1] doubleValue]) forKey:@"Y"];
    [_boxmax setObject:@([[[NSNumber alloc] initWithDouble:0.1] doubleValue]) forKey:@"Z"];

    _rotxlimit = [[NSMutableDictionary alloc] init];
    [_rotxlimit setObject:@([[[NSNumber alloc] initWithDouble:-100000] doubleValue]) forKey:@"Min"];
    [_rotxlimit setObject:@([[[NSNumber alloc] initWithDouble:100000] doubleValue]) forKey:@"Max"];
    
    _rotylimit = [[NSMutableDictionary alloc] init];
    [_rotylimit setObject:@([[[NSNumber alloc] initWithDouble:-100000] doubleValue]) forKey:@"Min"];
    [_rotylimit setObject:@([[[NSNumber alloc] initWithDouble:100000] doubleValue]) forKey:@"Max"];

    _rotzlimit = [[NSMutableDictionary alloc] init];
    [_rotzlimit setObject:@([[[NSNumber alloc] initWithDouble:-100000] doubleValue]) forKey:@"Min"];
    [_rotzlimit setObject:@([[[NSNumber alloc] initWithDouble:100000] doubleValue]) forKey:@"Max"];

    _pose = [[NSMutableDictionary alloc] init];
    [_pose setObject:@([[[NSNumber alloc] initWithDouble:0.0] doubleValue]) forKey:@"X"];
    [_pose setObject:@([[[NSNumber alloc] initWithDouble:0.0] doubleValue]) forKey:@"Y"];
    [_pose setObject:@([[[NSNumber alloc] initWithDouble:0.0] doubleValue]) forKey:@"Z"];
    
    _children = [[NSMutableArray alloc] init];

    return self;
}

- (void)addChild:(Balljoint *)child {
    [_children addObject:child];
}

@end
