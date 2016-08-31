//
//  openGLView.m
//  ComputerAnimationAssignment2
//
//  Created by Austin Schwartz on 9/27/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import "openGLView.h"
#import "Balljoint.h"
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <GLUT/glut.h>

@import GLKit;

@implementation openGLView

static void drawTriangle(GLKVector4 vector1, GLKVector4 vector2, GLKVector4 vector3, GLKVector4 normal1, GLKVector4 normal2, GLKVector4 normal3) {
    glPolygonMode( GL_FRONT_AND_BACK, GL_FILL );
    glBegin(GL_TRIANGLES);
    glNormal3f(normal1.x, normal1.y, normal1.z);
    glVertex3f(vector1.x, vector1.y, vector1.z);
    glNormal3f(normal2.x, normal2.y, normal2.z);
    glVertex3f(vector2.x, vector2.y, vector2.z);
    glNormal3f(normal3.x, normal3.y, normal3.z);
    glVertex3f(vector3.x, vector3.y, vector3.z);
    glEnd();
}

- (void)changeRotation:(NSString*)axis withDirection:(NSString*)direction withJoint:(long)joint withRoot:(Balljoint*)rootJoint withSkinData:(SkinData*)skinData withMatrix:(GLKMatrix4)matrix {
    if ([axis isEqualToString:@"X"]) {
        if ([direction isEqualToString:@"Minus"]) {
            double jointX = [[[_jointRotation objectAtIndex:joint] valueForKey:@"X"] doubleValue];
            jointX -= 0.3*M_1_PI;
            [[_jointRotation objectAtIndex:joint] setValue:@(jointX) forKey:@"X"];
        }
        else if ([direction isEqualToString:@"Plus"]) {
            double jointX = [[[_jointRotation objectAtIndex:joint] valueForKey:@"X"] doubleValue];
            jointX += 0.3*M_1_PI;
            [[_jointRotation objectAtIndex:joint] setValue:@(jointX) forKey:@"X"];
        }
    }
    else if ([axis isEqualToString:@"Y"]) {
        if ([direction isEqualToString:@"Minus"]) {
            double jointY = [[[_jointRotation objectAtIndex:joint] valueForKey:@"Y"] doubleValue];
            jointY -= 0.3*M_1_PI;
            [[_jointRotation objectAtIndex:joint] setValue:@(jointY) forKey:@"Y"];
        }
        else if ([direction isEqualToString:@"Plus"]) {
            double jointY = [[[_jointRotation objectAtIndex:joint] valueForKey:@"Y"] doubleValue];
            jointY += 0.3*M_1_PI;
            [[_jointRotation objectAtIndex:joint] setValue:@(jointY) forKey:@"Y"];
        }
    }
    else if ([axis isEqualToString:@"Z"]) {
        if ([direction isEqualToString:@"Minus"]) {
            double jointZ = [[[_jointRotation objectAtIndex:joint] valueForKey:@"Z"] doubleValue];
            jointZ -= 0.3*M_1_PI;
            [[_jointRotation objectAtIndex:joint] setValue:@(jointZ) forKey:@"Z"];
        }
        else if ([direction isEqualToString:@"Plus"]) {
            double jointZ = [[[_jointRotation objectAtIndex:joint] valueForKey:@"Z"] doubleValue];
            jointZ += 0.3*M_1_PI;
            [[_jointRotation objectAtIndex:joint] setValue:@(jointZ) forKey:@"Z"];
        }
    }
    [self drawSkel:rootJoint andSkinData:skinData withMatrix:matrix];
}

- (void)changeCamera:(NSString*)axis withDirection:(NSString*)direction withRoot:(Balljoint*)rootJoint withSkinData:(SkinData*)skinData withMatrix:(GLKMatrix4)matrix {
    if ([axis isEqualToString:@"X"]) {
        if ([direction isEqualToString:@"Minus"]) {
            _angleX -= 0.3*M_1_PI;
        }
        else if ([direction isEqualToString:@"Plus"]) {
            _angleX += 0.3*M_1_PI;
        }
    }
    else if ([axis isEqualToString:@"Y"]) {
        if ([direction isEqualToString:@"Minus"]) {
            _angleY -= 0.3*M_1_PI;
        }
        else if ([direction isEqualToString:@"Plus"]) {
            _angleY += 0.3*M_1_PI;
        }
    }
    else if ([axis isEqualToString:@"Z"]) {
        if ([direction isEqualToString:@"Minus"]) {
            _angleZ -= 0.3*M_1_PI;
        }
        else if ([direction isEqualToString:@"Plus"]) {
            _angleZ += 0.3*M_1_PI;
        }
    }
    [self drawSkel:rootJoint andSkinData:skinData withMatrix:matrix];
}

- (void)zoom:(NSString*)direction withRoot:(Balljoint*)rootJoint withSkinData:(SkinData*)skinData withMatrix:(GLKMatrix4)matrix {
    if ([direction isEqualToString:@"In"]) {
        _cameraX /= 1.2;
        _cameraY /= 1.2;
        _cameraZ /= 1.2;
    }
    else if ([direction isEqualToString:@"Out"]) {
        _cameraX *= 1.2;
        _cameraY *= 1.2;
        _cameraZ *= 1.2;
    }
    [self drawSkel:rootJoint andSkinData:skinData withMatrix:matrix];
}

- (void)resetAngleX {
    _angleX = 0.0;
}

- (void)resetAngleY {
    _angleY = 0.0;
}

- (void)resetAngleZ {
    _angleZ = 0.0;
}

- (void)resetCameraX {
    _cameraX = 0.1;
}

- (void)resetCameraY {
    _cameraY = 0.1;
}

- (void)resetCameraZ {
    _cameraZ = 5.0;
}

- (void)initiateRotationArrayWithCount:(unsigned long)count {
    _jointRotation = [[NSMutableArray alloc] init];
    for (unsigned long i = 0; i < count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjects:@[@0.0,@0.0,@0.0] forKeys:@[@"X", @"Y", @"Z"]];
        [_jointRotation addObject:dict];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    _jointMatrixArray = [[NSMutableArray alloc] init];
    _count = 0;
    _root = YES;
    _cameraX = 0.1;
    _cameraY = 0.1;
    _cameraZ = 5.0;
    _angleX = 0.0;
    _angleY = 0.0;
    _angleZ = 0.0;
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glEnable(GL_DEPTH_TEST);
    gluPerspective(60.0, 1.2, 0.1, 1000.0);
    gluLookAt(_cameraX, _cameraY, _cameraZ, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glEnable(GL_DEPTH_TEST);
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glFlush();
}

- (void)drawSkin:(SkinData*)skinData {
    glLoadMatrixf(GLKMatrix4Identity.m);
    for (NSMutableArray *array in [skinData triangles]) {
        GLKVector4 vector = GLKVector4Make([[[[skinData positions] objectAtIndex:[[array objectAtIndex:0] integerValue]] objectAtIndex:0] floatValue], [[[[skinData positions] objectAtIndex:[[array objectAtIndex:0] integerValue]] objectAtIndex:1] floatValue], [[[[skinData positions] objectAtIndex:[[array objectAtIndex:0] integerValue]] objectAtIndex:2] floatValue], 1);
        GLKVector4 vector1 = GLKVector4Make(0, 0, 0, 1);
        NSMutableArray *skinweights = [[skinData skinweights] objectAtIndex:[[array objectAtIndex:0] integerValue]];
        for (int i = 0; i < [skinweights count]; i += 2) {
            long joint = [[skinweights objectAtIndex:i] longValue];
            float weight = [[skinweights objectAtIndex:i+1] floatValue];
            Matrix *tempBindingMatrix = [[skinData bindings] objectAtIndex:joint];
            GLKMatrix4 bindingMatrix = tempBindingMatrix.matrix;
            bindingMatrix = GLKMatrix4Invert(bindingMatrix, nil);
            GLKVector4 bindingVector = GLKMatrix4MultiplyVector4(bindingMatrix, vector);
            Matrix *tempJointMatrix = [_jointMatrixArray objectAtIndex:joint];
            GLKMatrix4 jointMatrix = tempJointMatrix.matrix;
            GLKVector4 jointVector = GLKMatrix4MultiplyVector4(jointMatrix, bindingVector);
            GLKVector4 weightedVector = GLKVector4MultiplyScalar(jointVector, weight);
            vector1 = GLKVector4Add(vector1, weightedVector);
        }
        GLKVector4 normal1 = GLKVector4Make([[[[skinData normals] objectAtIndex:[[array objectAtIndex:0] integerValue]] objectAtIndex:0] floatValue], [[[[skinData normals] objectAtIndex:[[array objectAtIndex:0] integerValue]] objectAtIndex:1] floatValue], [[[[skinData normals] objectAtIndex:[[array objectAtIndex:0] integerValue]] objectAtIndex:2] floatValue], 0.0);
        vector = GLKVector4Make([[[[skinData positions] objectAtIndex:[[array objectAtIndex:1] integerValue]] objectAtIndex:0] floatValue], [[[[skinData positions] objectAtIndex:[[array objectAtIndex:1] integerValue]] objectAtIndex:1] floatValue], [[[[skinData positions] objectAtIndex:[[array objectAtIndex:1] integerValue]] objectAtIndex:2] floatValue], 1);
        GLKVector4 vector2 = GLKVector4Make(0, 0, 0, 1);
        skinweights = [[skinData skinweights] objectAtIndex:[[array objectAtIndex:1] integerValue]];
        for (int i = 0; i < [skinweights count]; i += 2) {
            long joint = [[skinweights objectAtIndex:i] longValue];
            float weight = [[skinweights objectAtIndex:i+1] floatValue];
            Matrix *tempBindingMatrix = [[skinData bindings] objectAtIndex:joint];
            GLKMatrix4 bindingMatrix = tempBindingMatrix.matrix;
            bindingMatrix = GLKMatrix4Invert(bindingMatrix, nil);
            GLKVector4 bindingVector = GLKMatrix4MultiplyVector4(bindingMatrix, vector);
            Matrix *tempJointMatrix = [_jointMatrixArray objectAtIndex:joint];
            GLKMatrix4 jointMatrix = tempJointMatrix.matrix;
            GLKVector4 jointVector = GLKMatrix4MultiplyVector4(jointMatrix, bindingVector);
            GLKVector4 weightedVector = GLKVector4MultiplyScalar(jointVector, weight);
            vector2 = GLKVector4Add(vector2, weightedVector);
        }
        GLKVector4 normal2 = GLKVector4Make([[[[skinData normals] objectAtIndex:[[array objectAtIndex:1] integerValue]] objectAtIndex:0] floatValue], [[[[skinData normals] objectAtIndex:[[array objectAtIndex:1] integerValue]] objectAtIndex:1] floatValue], [[[[skinData normals] objectAtIndex:[[array objectAtIndex:1] integerValue]] objectAtIndex:2] floatValue], 0.0);
        vector = GLKVector4Make([[[[skinData positions] objectAtIndex:[[array objectAtIndex:2] integerValue]] objectAtIndex:0] floatValue], [[[[skinData positions] objectAtIndex:[[array objectAtIndex:2] integerValue]] objectAtIndex:1] floatValue], [[[[skinData positions] objectAtIndex:[[array objectAtIndex:2] integerValue]] objectAtIndex:2] floatValue], 1);
        GLKVector4 vector3 = GLKVector4Make(0, 0, 0, 1);
        skinweights = [[skinData skinweights] objectAtIndex:[[array objectAtIndex:2] integerValue]];
        for (int i = 0; i < [skinweights count]; i += 2) {
            long joint = [[skinweights objectAtIndex:i] longValue];
            float weight = [[skinweights objectAtIndex:i+1] floatValue];
            Matrix *tempBindingMatrix = [[skinData bindings] objectAtIndex:joint];
            GLKMatrix4 bindingMatrix = tempBindingMatrix.matrix;
            bindingMatrix = GLKMatrix4Invert(bindingMatrix, nil);
            GLKVector4 bindingVector = GLKMatrix4MultiplyVector4(bindingMatrix, vector);
            Matrix *tempJointMatrix = [_jointMatrixArray objectAtIndex:joint];
            GLKMatrix4 jointMatrix = tempJointMatrix.matrix;
            GLKVector4 jointVector = GLKMatrix4MultiplyVector4(jointMatrix, bindingVector);
            GLKVector4 weightedVector = GLKVector4MultiplyScalar(jointVector, weight);
            vector3 = GLKVector4Add(vector3, weightedVector);
        }
        GLKVector4 normal3 = GLKVector4Make([[[[skinData normals] objectAtIndex:[[array objectAtIndex:2] integerValue]] objectAtIndex:0] floatValue], [[[[skinData normals] objectAtIndex:[[array objectAtIndex:2] integerValue]] objectAtIndex:1] floatValue], [[[[skinData normals] objectAtIndex:[[array objectAtIndex:2] integerValue]] objectAtIndex:2] floatValue], 0.0);
        drawTriangle(vector1, vector2, vector3, normal1, normal2, normal3);
    }
    glFlush();
}

- (void)drawSkel:(Balljoint*)rootJoint andSkinData:(SkinData*)skinData withMatrix:(GLKMatrix4)matrix {
    _count++;
    if (_root) {
        _jointMatrixArray = [[NSMutableArray alloc] initWithArray:@[]];
        matrix = GLKMatrix4MakeXRotation(_angleX);
        matrix = GLKMatrix4Multiply(GLKMatrix4MakeYRotation(_angleY), matrix);
        matrix = GLKMatrix4Multiply(GLKMatrix4MakeZRotation(_angleZ), matrix);
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glEnable(GL_DEPTH_TEST);
        gluPerspective(60.0, 1.2, 0.1, 1000.0);
        gluLookAt(_cameraX, _cameraY, _cameraZ, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        GLfloat light0pos[] = {5.0, 5.0, 5.0, 0.0};
        GLfloat light1pos[] = {-5.0, 5.0, 5.0, 0.0};
        GLfloat light2pos[] = {-5.0, -5.0, -5.0, 0.0};
        GLfloat white[] = {0.7f, 0.7f, 0.7f, 1.0f};
        GLfloat red[] = {0.7f, 0.0f, 0.0f, 1.0f};
        GLfloat green[] = {0.0f, 0.7f, 0.0f, 1.0f};
        GLfloat blue[] = {0.0f, 0.0f, 0.7f, 1.0f};
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_LIGHTING);
        glEnable(GL_LIGHT0);
        glEnable(GL_LIGHT1);
        glEnable(GL_LIGHT2);
        glMaterialfv(GL_FRONT, GL_DIFFUSE, white);
        glMaterialfv(GL_FRONT, GL_SPECULAR, white);
        glLightfv(GL_LIGHT0, GL_POSITION, light0pos);
        glLightfv(GL_LIGHT0, GL_DIFFUSE, red);
        glLightfv(GL_LIGHT0, GL_SPECULAR, red);
        glLightfv(GL_LIGHT1, GL_POSITION, light1pos);
        glLightfv(GL_LIGHT1, GL_DIFFUSE, blue);
        glLightfv(GL_LIGHT1, GL_SPECULAR, blue);
        glLightfv(GL_LIGHT2, GL_POSITION, light2pos);
        glLightfv(GL_LIGHT2, GL_DIFFUSE, green);
        glLightfv(GL_LIGHT2, GL_SPECULAR, green);
        glClearColor(0, 0, 0, 0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        _root = NO;
    }
    matrix = GLKMatrix4Translate(matrix, [[[rootJoint offset] valueForKey:@"X"] doubleValue],
                                         [[[rootJoint offset] valueForKey:@"Y"] doubleValue],
                                         [[[rootJoint offset] valueForKey:@"Z"] doubleValue]);
    if ([[[rootJoint rotzlimit] valueForKey:@"Min"] doubleValue] <= ([[[rootJoint pose] valueForKey:@"Z"] doubleValue] + [[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"Z"] doubleValue]) &&
        [[[rootJoint rotzlimit] valueForKey:@"Max"] doubleValue] >= ([[[rootJoint pose] valueForKey:@"Z"] doubleValue] + [[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"Z"] doubleValue])) {
        matrix = GLKMatrix4Rotate(matrix, ([[[rootJoint pose] valueForKey:@"Z"] doubleValue] + [[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"Z"] doubleValue]), 0.0, 0.0, 1.0);
    }
    else if ([[[rootJoint rotzlimit] valueForKey:@"Min"] doubleValue] > ([[[rootJoint pose] valueForKey:@"Z"] doubleValue] + [[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"Z"] doubleValue])) {
        matrix = GLKMatrix4Rotate(matrix, [[[rootJoint rotzlimit] valueForKey:@"Min"] doubleValue], 0.0, 0.0, 1.0);
    }
    else {
        matrix = GLKMatrix4Rotate(matrix, [[[rootJoint rotzlimit] valueForKey:@"Max"] doubleValue], 0.0, 0.0, 1.0);
    }
    if ([[[rootJoint rotylimit] valueForKey:@"Min"] doubleValue] <= ([[[rootJoint pose] valueForKey:@"Y"] doubleValue] + [[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"Y"] doubleValue]) &&
        [[[rootJoint rotylimit] valueForKey:@"Max"] doubleValue] >= ([[[rootJoint pose] valueForKey:@"Y"] doubleValue] +[[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"Y"] doubleValue])) {
        matrix = GLKMatrix4Rotate(matrix, ([[[rootJoint pose] valueForKey:@"Y"] doubleValue] + [[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"Y"] doubleValue]), 0.0, 1.0, 0.0);
    }
    else if ([[[rootJoint rotylimit] valueForKey:@"Min"] doubleValue] > ([[[rootJoint pose] valueForKey:@"Y"] doubleValue] + [[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"Y"] doubleValue])) {
        matrix = GLKMatrix4Rotate(matrix, [[[rootJoint rotylimit] valueForKey:@"Min"] doubleValue], 0.0, 1.0, 0.0);
    }
    else {
        matrix = GLKMatrix4Rotate(matrix, [[[rootJoint rotylimit] valueForKey:@"Max"] doubleValue], 0.0, 1.0, 0.0);
    }
    if ([[[rootJoint rotxlimit] valueForKey:@"Min"] doubleValue] <= ([[[rootJoint pose] valueForKey:@"X"] doubleValue] +[[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"X"] doubleValue]) &&
        [[[rootJoint rotxlimit] valueForKey:@"Max"] doubleValue] >= ([[[rootJoint pose] valueForKey:@"X"] doubleValue] +[[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"X"] doubleValue])) {
        matrix = GLKMatrix4Rotate(matrix, ([[[rootJoint pose] valueForKey:@"X"] doubleValue] + [[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"X"] doubleValue]), 1.0, 0.0, 0.0);
    }
    else if ([[[rootJoint rotxlimit] valueForKey:@"Min"] doubleValue] > ([[[rootJoint pose] valueForKey:@"X"] doubleValue] +[[[_jointRotation objectAtIndex:([_jointMatrixArray count])] valueForKey:@"X"] doubleValue])) {
        matrix = GLKMatrix4Rotate(matrix, [[[rootJoint rotxlimit] valueForKey:@"Min"] doubleValue], 1.0, 0.0, 0.0);
    }
    else {
        matrix = GLKMatrix4Rotate(matrix, [[[rootJoint rotxlimit] valueForKey:@"Max"] doubleValue], 1.0, 0.0, 0.0);
    }
    Matrix *tempMatrix = [[Matrix alloc] initWithMatrix:matrix];
    [_jointMatrixArray addObject:tempMatrix];
    for (Balljoint *child in [rootJoint children]) {
        [self drawSkel:child andSkinData:skinData withMatrix:matrix];
    }
    _count--;
    if (_count == 0) {
        _root = YES;
        [self drawSkin:skinData];
    }
}

@end
