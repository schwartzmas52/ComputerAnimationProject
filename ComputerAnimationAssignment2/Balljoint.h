//
//  Balljoint.h
//  ComputerAnimationAssignment2
//
//  Created by Austin Schwartz on 9/29/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Balljoint : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableDictionary *offset;
@property (strong, nonatomic) NSMutableDictionary *boxmin;
@property (strong, nonatomic) NSMutableDictionary *boxmax;
@property (strong, nonatomic) NSMutableDictionary *rotxlimit;
@property (strong, nonatomic) NSMutableDictionary *rotylimit;
@property (strong, nonatomic) NSMutableDictionary *rotzlimit;
@property (strong, nonatomic) NSMutableDictionary *pose;
@property (strong, nonatomic) NSMutableArray *children;

- (Balljoint*)initWithName:(NSString*)theName;
- (void)addChild:(Balljoint*)child;

@end
