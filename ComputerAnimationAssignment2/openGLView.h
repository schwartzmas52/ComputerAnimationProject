//
//  openGLView.h
//  ComputerAnimationAssignment2
//
//  Created by Austin Schwartz on 9/27/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Balljoint.h"
#import "SkinData.h"

@import GLKit;

@interface openGLView : NSOpenGLView

@property BOOL root;
@property int count;
@property double cameraX;
@property double cameraY;
@property double cameraZ;
@property double angleX;
@property double angleY;
@property double angleZ;
@property (strong, nonatomic) NSMutableArray<NSMutableDictionary *> *jointRotation;
@property (strong, nonatomic) NSMutableArray<Matrix *> *jointMatrixArray;

- (void)drawRect:(NSRect)dirtyRect;
- (void)drawSkel:(Balljoint*)rootJoint andSkinData:(SkinData*)skinData withMatrix:(GLKMatrix4)matrix;
- (void)drawSkin:(SkinData*)skinData;
- (void)changeRotation:(NSString*)axis withDirection:(NSString*)direction withJoint:(long)joint withRoot:(Balljoint*)rootJoint withSkinData:(SkinData*)skinData withMatrix:(GLKMatrix4)matrix;
- (void)changeCamera:(NSString*)axis withDirection:(NSString*)direction withRoot:(Balljoint*)rootJoint withSkinData:(SkinData*)skinData withMatrix:(GLKMatrix4)matrix;
- (void)zoom:(NSString*)direction withRoot:(Balljoint*)rootJoint withSkinData:(SkinData*)skinData withMatrix:(GLKMatrix4)matrix;
- (void)resetAngleX;
- (void)resetAngleY;
- (void)resetAngleZ;
- (void)resetCameraX;
- (void)resetCameraY;
- (void)resetCameraZ;
- (void)initiateRotationArrayWithCount:(unsigned long)count;

@end
