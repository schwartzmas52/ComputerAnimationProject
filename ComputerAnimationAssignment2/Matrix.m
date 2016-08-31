//
//  Matrix.m
//  ComputerAnimationAssignment3
//
//  Created by Austin Schwartz on 10/14/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import "Matrix.h"

@import GLKit;

@implementation Matrix

- (Matrix*)initWithMatrix:(GLKMatrix4)matrix {
    _matrix = matrix;
    return self;
}

@end
