//
//  SkinData.m
//  ComputerAnimationAssignment3
//
//  Created by Austin Schwartz on 10/13/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import "SkinData.h"

@import GLKit;

@implementation SkinData

- (SkinData*)init {
    _positions = [[NSMutableArray alloc] init];
    _normals = [[NSMutableArray alloc] init];
    _skinweights = [[NSMutableArray alloc] init];
    _triangles = [[NSMutableArray alloc] init];
    _bindings = [[NSMutableArray alloc] init];
    return self;
}

- (void)addPosition:(NSMutableArray*)array {
    [_positions addObject:array];
}

- (void)addNormal:(NSMutableArray*)array {
    [_normals addObject:array];
}

- (void)addSkinweight:(NSMutableArray*)array {
    [_skinweights addObject:array];
}

- (void)addTriangle:(NSMutableArray*)array {
    [_triangles addObject:array];
}

- (void)addBinding:(Matrix*)matrix {
    [_bindings addObject:matrix];
}

@end
