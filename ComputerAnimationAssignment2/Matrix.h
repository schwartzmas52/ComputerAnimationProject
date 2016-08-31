//
//  Matrix.h
//  ComputerAnimationAssignment3
//
//  Created by Austin Schwartz on 10/14/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GLKit;

@interface Matrix : NSObject

@property GLKMatrix4 matrix;

- (Matrix*)initWithMatrix:(GLKMatrix4)matrix;

@end
