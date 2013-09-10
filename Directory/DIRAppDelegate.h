//
//  DIRAppDelegate.h
//  Directory
//
//  Created by Yoann Gini on 03/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DIRAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTableView *masterTableView;
@property (assign) IBOutlet NSView *detailSuperview;

@property (assign) IBOutlet NSPopUpButton *sourcePopUpButton;
- (IBAction)selectedSourceHasChanged:(id)sender;

@property (assign) IBOutlet NSSegmentedControl *dataTypeSegmentedControl;
- (IBAction)selectedDataTypeHasChanged:(id)sender;

@property (assign) IBOutlet NSSearchField *masterSearchField;
- (IBAction)masterSearchFieldDidChange:(id)sender;

@property (assign) IBOutlet NSButton *loginButton;
@property (assign) IBOutlet NSWindow *loginWindow;
@property (assign) IBOutlet NSTextField *loginWindowUserField;
@property (assign) IBOutlet NSSecureTextField *loginWindowPasswordField;
@property (assign) IBOutlet NSTextField *loginStateField;
- (IBAction)showLoginPanelAction:(id)sender;
- (IBAction)loginWindowOKAction:(id)sender;
- (IBAction)loginWindowCancelAction:(id)sender;

@property (assign) IBOutlet NSButton *detailSaveButton;
@property (assign) IBOutlet NSButton *detailCancelButton;
- (IBAction)detailSaveAction:(id)sender;
- (IBAction)detailCancelAction:(id)sender;

@property (retain) IBOutlet NSArray *finalList;

@end
