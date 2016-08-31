//
//  ViewController.m
//  ComputerAnimationAssignment2
//
//  Created by Austin Schwartz on 9/27/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import "ViewController.h"

@import GLKit;
@import AppKit;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _skelFile = @"";
    _skinFile = @"";
    _selectedJoint = [_jointTable selectedRow];
    _jointArray = [[NSMutableArray alloc] init];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)jointXPlus:(id)sender {
    _selectedJoint = [_jointTable selectedRow];
    if (_selectedJoint > -1) {
        [_glView changeRotation:@"X" withDirection:@"Plus" withJoint:_selectedJoint withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
    }
}

- (IBAction)jointXMinus:(id)sender {
    _selectedJoint = [_jointTable selectedRow];
    if (_selectedJoint > -1) {
        [_glView changeRotation:@"X" withDirection:@"Minus" withJoint:_selectedJoint withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
    }
}

- (IBAction)jointYPlus:(id)sender {
    _selectedJoint = [_jointTable selectedRow];
    if (_selectedJoint > -1) {
        [_glView changeRotation:@"Y" withDirection:@"Plus" withJoint:_selectedJoint withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
    }
}

- (IBAction)jointYMinus:(id)sender {
    _selectedJoint = [_jointTable selectedRow];
    if (_selectedJoint > -1) {
        [_glView changeRotation:@"Y" withDirection:@"Minus" withJoint:_selectedJoint withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
    }
}

- (IBAction)jointZPlus:(id)sender {
    _selectedJoint = [_jointTable selectedRow];
    if (_selectedJoint > -1) {
        [_glView changeRotation:@"Z" withDirection:@"Plus" withJoint:_selectedJoint withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
    }
}

- (IBAction)jointZMinus:(id)sender {
    _selectedJoint = [_jointTable selectedRow];
    if (_selectedJoint > -1) {
        [_glView changeRotation:@"Z" withDirection:@"Minus" withJoint:_selectedJoint withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
    }
}

- (IBAction)cameraXPlus:(id)sender {
    [_glView changeCamera:@"X" withDirection:@"Plus" withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
}

- (IBAction)cameraXMinus:(id)sender {
    [_glView changeCamera:@"X" withDirection:@"Minus" withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
}

- (IBAction)cameraYPlus:(id)sender {
    [_glView changeCamera:@"Y" withDirection:@"Plus" withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
}

- (IBAction)cameraYMinus:(id)sender {
    [_glView changeCamera:@"Y" withDirection:@"Minus" withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
}

- (IBAction)cameraZPlus:(id)sender {
    [_glView changeCamera:@"Z" withDirection:@"Plus" withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
}

- (IBAction)cameraZMinus:(id)sender {
    [_glView changeCamera:@"Z" withDirection:@"Minus" withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
}

- (IBAction)zoomIn:(id)sender {
    [_glView zoom:@"In" withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
}

- (IBAction)zoomOut:(id)sender {
    [_glView zoom:@"Out" withRoot:_rootJoint withSkinData:_skinData withMatrix:GLKMatrix4Identity];
}

- (IBAction)selectSkel:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setMessage:@"Import a '.skel' file."];
    [panel setAllowedFileTypes:@[@"skel"]];
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *url = [panel URL];
            _skelFilePath = url;
            _skelFile = [[url pathComponents] lastObject];
            [_glView resetAngleX];
            [_glView resetAngleY];
            [_glView resetAngleZ];
            [_glView resetCameraX];
            [_glView resetCameraY];
            [_glView resetCameraZ];
            [self createBalljoints];
            if (![_skinFile isEqualToString:@""]) {
                _fileSelected.stringValue = [[NSString alloc] initWithFormat:@"%@ \t %@", _skelFile, _skinFile];
                [_jointTable reloadData];
                [_glView drawSkel:_rootJoint andSkinData:_skinData withMatrix:GLKMatrix4Identity];
            }
            else {
                _fileSelected.stringValue = _skelFile;
            }
        }
    }];
}

- (IBAction)selectSkin:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setMessage:@"Import a '.skin' file."];
    [panel setAllowedFileTypes:@[@"skin"]];
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *url = [panel URL];
            _skinFilePath = url;
            _skinFile = [[url pathComponents] lastObject];
            [_glView resetAngleX];
            [_glView resetAngleY];
            [_glView resetAngleZ];
            [_glView resetCameraX];
            [_glView resetCameraY];
            [_glView resetCameraZ];
            [self createSkinData];
            if (![_skelFile isEqualToString:@""]) {
                _fileSelected.stringValue = [[NSString alloc] initWithFormat:@"%@ \t %@", _skelFile, _skinFile];
                [_jointTable reloadData];
                [_glView drawSkel:_rootJoint andSkinData:_skinData withMatrix:GLKMatrix4Identity];
            }
            else {
                _fileSelected.stringValue = _skinFile;
            }
        }
    }];
}

- (void)createSkinData {
    _skinData = [[SkinData alloc] init];
    NSString *part = @"";
    NSString *subpart = @"";
    NSMutableArray *matrix = [[NSMutableArray alloc] init];
    NSString *file = [NSString stringWithContentsOfURL:_skinFilePath encoding:NSASCIIStringEncoding error:nil];
    NSArray *lines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        if (![line isEqualToString:@""]) {
            NSArray *tempParts = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSMutableArray *parts = [[NSMutableArray alloc] init];
            for (NSString *thePart in tempParts) {
                if (![thePart isEqualToString:@""]) {
                    [parts addObject:thePart];
                }
            }
            if ([[parts objectAtIndex:0] isEqualToString:@"}"]) {
                if (![subpart isEqualToString:@""]) {
                    subpart = @"";
                }
                else {
                    part = @"";
                }
            }
            else if ([part isEqualToString:@""]) {
                NSString *type = [parts objectAtIndex:0];
                if ([type isEqualToString:@"positions"]) {
                    part = @"positions";
                }
                else if ([type isEqualToString:@"normals"]) {
                    part = @"normals";
                }
                else if ([type isEqualToString:@"skinweights"]) {
                    part = @"skinweights";
                }
                else if ([type isEqualToString:@"triangles"]) {
                    part = @"triangles";
                }
                else if ([type isEqualToString:@"bindings"]) {
                    part = @"bindings";
                }
            }
            else if ([subpart isEqualToString:@""] && [part isEqualToString:@"bindings"]) {
                if ([[parts objectAtIndex:0] isEqualToString:@"matrix"]) {
                    subpart = @"matrix";
                }
            }
            else if ([part isEqualToString:@"positions"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@([[parts objectAtIndex:0] doubleValue]), @([[parts objectAtIndex:1] doubleValue]), @([[parts objectAtIndex:2] doubleValue]), nil];
                [_skinData addPosition:array];
            }
            else if ([part isEqualToString:@"normals"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@([[parts objectAtIndex:0] doubleValue]), @([[parts objectAtIndex:1] doubleValue]), @([[parts objectAtIndex:2] doubleValue]), nil];
                [_skinData addNormal:array];
            }
            else if ([part isEqualToString:@"skinweights"]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (int i = 1; i <= [[parts firstObject] integerValue]; i++) {
                    [array addObject:@([[parts objectAtIndex:(int)((i*2)-1)] integerValue])];
                    [array addObject:@([[parts objectAtIndex:(int)(i*2)] doubleValue])];
                }
                [_skinData addSkinweight:array];
            }
            else if ([part isEqualToString:@"triangles"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[[parts objectAtIndex:0], [parts objectAtIndex:1],[parts objectAtIndex:2]]];
                [_skinData addTriangle:array];
            }
            else if ([part isEqualToString:@"bindings"]) {
                if ([subpart isEqualToString:@"matrix"]) {
                    [matrix addObject:@([[parts objectAtIndex:0] doubleValue])];
                    [matrix addObject:@([[parts objectAtIndex:1] doubleValue])];
                    [matrix addObject:@([[parts objectAtIndex:2] doubleValue])];
                }
                if ([matrix count] == 12) {
                    GLKMatrix4 tempMatrix = GLKMatrix4Make([[matrix objectAtIndex:0] floatValue],
                                                           [[matrix objectAtIndex:1] floatValue],
                                                           [[matrix objectAtIndex:2] floatValue], 0.0f,
                                                           [[matrix objectAtIndex:3] floatValue],
                                                           [[matrix objectAtIndex:4] floatValue],
                                                           [[matrix objectAtIndex:5] floatValue], 0.0f,
                                                           [[matrix objectAtIndex:6] floatValue],
                                                           [[matrix objectAtIndex:7] floatValue],
                                                           [[matrix objectAtIndex:8] floatValue], 0.0f,
                                                           [[matrix objectAtIndex:9] floatValue],
                                                           [[matrix objectAtIndex:10] floatValue],
                                                           [[matrix objectAtIndex:11] floatValue], 1.0f);
                    Matrix *skinMatrix = [[Matrix alloc] initWithMatrix:tempMatrix];
                    [_skinData addBinding:skinMatrix];
                    matrix = [[NSMutableArray alloc] initWithArray:@[]];
                }
            }
        }
    }
}

- (void)createBalljoints {
    _jointArray = [[NSMutableArray alloc] init];
    _ballJointStack = [[NSMutableArray alloc] init];
    NSString *file = [NSString stringWithContentsOfURL:_skelFilePath encoding:NSASCIIStringEncoding error:nil];
    NSArray *lines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        if (![line isEqualTo:@""]) {
            NSArray *tempParts = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSMutableArray *parts = [[NSMutableArray alloc] init];
            for (NSString *part in tempParts) {
                if (![part isEqualToString:@""]) {
                    [parts addObject:part];
                }
            }
            NSString *type = [parts objectAtIndex:0];
            if ([type isEqualToString:@"balljoint"]) {
                Balljoint *tempJoint = [[Balljoint alloc] initWithName:[parts objectAtIndex:1]];
                [_jointArray addObject:tempJoint];
                [_ballJointStack addObject:tempJoint];
            }
            else if ([type isEqualToString:@"offset"]) {
                Balljoint *tempJoint = [_ballJointStack lastObject];
                [tempJoint.offset setObject:@([[parts objectAtIndex:1] doubleValue]) forKey:@"X"];
                [tempJoint.offset setObject:@([[parts objectAtIndex:2] doubleValue]) forKey:@"Y"];
                [tempJoint.offset setObject:@([[parts objectAtIndex:3] doubleValue]) forKey:@"Z"];
                [_ballJointStack removeLastObject];
                [_ballJointStack addObject:tempJoint];
            }
            else if ([type isEqualToString:@"boxmin"]) {
                Balljoint *tempJoint = [_ballJointStack lastObject];
                [tempJoint.boxmin setObject:@([[parts objectAtIndex:1] doubleValue]) forKey:@"X"];
                [tempJoint.boxmin setObject:@([[parts objectAtIndex:2] doubleValue]) forKey:@"Y"];
                [tempJoint.boxmin setObject:@([[parts objectAtIndex:3] doubleValue]) forKey:@"Z"];
                [_ballJointStack removeLastObject];
                [_ballJointStack addObject:tempJoint];
            }
            else if ([type isEqualToString:@"boxmax"]) {
                Balljoint *tempJoint = [_ballJointStack lastObject];
                [tempJoint.boxmax setObject:@([[parts objectAtIndex:1] doubleValue]) forKey:@"X"];
                [tempJoint.boxmax setObject:@([[parts objectAtIndex:2] doubleValue]) forKey:@"Y"];
                [tempJoint.boxmax setObject:@([[parts objectAtIndex:3] doubleValue]) forKey:@"Z"];
                [_ballJointStack removeLastObject];
                [_ballJointStack addObject:tempJoint];
            }
            else if ([type isEqualToString:@"rotxlimit"]) {
                Balljoint *tempJoint = [_ballJointStack lastObject];
                [tempJoint.rotxlimit setObject:@([[parts objectAtIndex:1] doubleValue]) forKey:@"Min"];
                [tempJoint.rotxlimit setObject:@([[parts objectAtIndex:2] doubleValue]) forKey:@"Max"];
                [_ballJointStack removeLastObject];
                [_ballJointStack addObject:tempJoint];
            }
            else if ([type isEqualToString:@"rotylimit"]) {
                Balljoint *tempJoint = [_ballJointStack lastObject];
                [tempJoint.rotylimit setObject:@([[parts objectAtIndex:1] doubleValue]) forKey:@"Min"];
                [tempJoint.rotylimit setObject:@([[parts objectAtIndex:2] doubleValue]) forKey:@"Max"];
                [_ballJointStack removeLastObject];
                [_ballJointStack addObject:tempJoint];
            }
            else if ([type isEqualToString:@"rotzlimit"]) {
                Balljoint *tempJoint = [_ballJointStack lastObject];
                [tempJoint.rotzlimit setObject:@([[parts objectAtIndex:1] doubleValue]) forKey:@"Min"];
                [tempJoint.rotzlimit setObject:@([[parts objectAtIndex:2] doubleValue]) forKey:@"Max"];
                [_ballJointStack removeLastObject];
                [_ballJointStack addObject:tempJoint];
            }
            else if ([type isEqualToString:@"pose"]) {
                Balljoint *tempJoint = [_ballJointStack lastObject];
                [tempJoint.pose setObject:@([[parts objectAtIndex:1] doubleValue]) forKey:@"X"];
                [tempJoint.pose setObject:@([[parts objectAtIndex:2] doubleValue]) forKey:@"Y"];
                [tempJoint.pose setObject:@([[parts objectAtIndex:3] doubleValue]) forKey:@"Z"];
                [_ballJointStack removeLastObject];
                [_ballJointStack addObject:tempJoint];
            }
            else if ([type isEqualToString:@"}"]) {
                if ([_ballJointStack count] >= 2) {
                    [[_ballJointStack objectAtIndex:([_ballJointStack count]-2)] addChild:[_ballJointStack lastObject]];
                    _rootJoint = [_ballJointStack firstObject];
                    [_ballJointStack removeLastObject];
                }
            }
        }
    }
    unsigned long count = (unsigned long)[_jointArray count];
    [_glView initiateRotationArrayWithCount:count];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_jointArray count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
    return [[_jointArray objectAtIndex:rowIndex] name];
}

@end
