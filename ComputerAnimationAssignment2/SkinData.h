//
//  SkinData.h
//  ComputerAnimationAssignment3
//
//  Created by Austin Schwartz on 10/13/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix.h"

@import GLKit;

@interface SkinData : NSObject

@property (strong, nonatomic) NSMutableArray *positions;
@property (strong, nonatomic) NSMutableArray *normals;
@property (strong, nonatomic) NSMutableArray *skinweights;
@property (strong, nonatomic) NSMutableArray *triangles;
@property (strong, nonatomic) NSMutableArray *bindings;

- (SkinData*)init;
- (void)addPosition:(NSMutableArray*)array;
- (void)addNormal:(NSMutableArray*)array;
- (void)addSkinweight:(NSMutableArray*)array;
- (void)addTriangle:(NSMutableArray*)array;
- (void)addBinding:(Matrix*)matrix;

@end
