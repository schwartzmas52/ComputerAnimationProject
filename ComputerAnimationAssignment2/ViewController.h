//
//  ViewController.h
//  ComputerAnimationAssignment2
//
//  Created by Austin Schwartz on 9/27/15.
//  Copyright © 2015 Austin Schwartz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "openGLView.h"
#import "Balljoint.h"
#import "SkinData.h"
#import "Matrix.h"

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property long selectedJoint;
@property (strong, nonatomic) Balljoint *rootJoint;
@property (strong, nonatomic) SkinData *skinData;
@property (strong, nonatomic) NSMutableArray<Balljoint*> *ballJointStack;
@property (strong, nonatomic) NSMutableArray<Balljoint*> *jointArray;
@property (strong, nonatomic) NSURL *skelFilePath;
@property (strong, nonatomic) NSURL *skinFilePath;
@property (strong, nonatomic) NSString *skelFile;
@property (strong, nonatomic) NSString *skinFile;
@property (weak) IBOutlet openGLView *glView;
@property (weak) IBOutlet NSTextField *fileSelected;
@property (weak) IBOutlet NSTableView *jointTable;

- (IBAction)cameraXPlus:(id)sender;
- (IBAction)cameraXMinus:(id)sender;
- (IBAction)cameraYPlus:(id)sender;
- (IBAction)cameraYMinus:(id)sender;
- (IBAction)cameraZPlus:(id)sender;
- (IBAction)cameraZMinus:(id)sender;
- (IBAction)jointXPlus:(id)sender;
- (IBAction)jointXMinus:(id)sender;
- (IBAction)jointYPlus:(id)sender;
- (IBAction)jointYMinus:(id)sender;
- (IBAction)jointZPlus:(id)sender;
- (IBAction)jointZMinus:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)selectSkel:(id)sender;
- (IBAction)selectSkin:(id)sender;

@end

