//
//  DIRAppDelegate.m
//  Directory
//
//  Created by Yoann Gini on 03/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRAppDelegate.h"

#import "DIRDataProvider.h"
#import "DIRDataHelper.h"

#import <libkern/OSAtomic.h>

#import "DIRDataViewController.h"

typedef NS_ENUM(int, DIRDataType)
{
	kDIRDataTypeUnknown,
	kDIRDataTypeUsers,
	kDIRDataTypeContacts
};

#define kDIRDataTypeUnsuportedException @"kDIRDataTypeUnsuportedException"

@interface DIRAppDelegate () <NSTableViewDataSource, NSTableViewDelegate>
{
	DIRDataType _selectedRecordType;
	
	BOOL _applicationIsReady;
	
	DIRDataViewController *_curentDataViewController;
}

- (void)reloadData;
- (void)reloadAuthenticationSate;
- (void)reloadDetailViewForRecord:(ODRecord*)record;

- (ODRecordType)selectedODRecordType;

- (void)authenticateWithLogin:(NSString*)login andPassword:(NSString*)password;

@end

@implementation DIRAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{
	self.finalList = [NSArray array];
	[[DIRDataProvider sharedInstance] addObserver:self forKeyPath:@"authenticatedAs" options:0 context:NULL];
	
	NSMenuItem *menuItem = nil;
	for (NSString *source in [[DIRDataProvider sharedInstance] availableSources]) {
		menuItem = [[NSMenuItem alloc] initWithTitle:source
											  action:@selector(selectedSourceHasChanged:)
									   keyEquivalent:@""];
		[menuItem setTarget:self];
		[self.sourcePopUpButton.menu addItem:menuItem];
		[menuItem release];
	}
	
	[self.sourcePopUpButton selectItemAtIndex:0];
	[self.dataTypeSegmentedControl setSelectedSegment:0];
	
	[self selectedDataTypeHasChanged:self];
	[self selectedSourceHasChanged:self];
	
	_applicationIsReady = YES;
	
	[self reloadData];
}

- (void)dealloc
{
	[[DIRDataProvider sharedInstance] removeObserver:self forKeyPath:@"authenticatedAs"];
	[_finalList release], _finalList = nil;
    [super dealloc];
}

#pragma mark Actions

- (IBAction)selectedSourceHasChanged:(id)sender {
	[[DIRDataProvider sharedInstance] setSelectedSource:self.sourcePopUpButton.selectedItem.title];
	[self reloadDetailViewForRecord:nil];
	[self reloadData];
}

- (IBAction)selectedDataTypeHasChanged:(id)sender {
	switch (self.dataTypeSegmentedControl.selectedSegment) {
		case 0:
			_selectedRecordType = kDIRDataTypeUsers;
			break;
		case 1:
			_selectedRecordType = kDIRDataTypeContacts;
			break;
		default:
			[NSException raise:kDIRDataTypeUnsuportedException format:@"The selected data type (%ld) isn't supported", (long)self.dataTypeSegmentedControl.selectedTag];
			break;
	}
	[self reloadDetailViewForRecord:nil];
	[self reloadData];
}

- (IBAction)masterSearchFieldDidChange:(id)sender {
	[self reloadData];
}

- (IBAction)showLoginPanelAction:(id)sender {
	if ([[[DIRDataProvider sharedInstance] authenticatedAs] length] == 0)
	{
		if (!self.loginWindow.isVisible)
		{
			if (sender != self)
			{
				self.loginWindowUserField.stringValue = @"";
				self.loginWindowPasswordField.stringValue = @"";
			}
			
			[NSApp beginSheet:self.loginWindow
			   modalForWindow:self.window
				modalDelegate:self
			   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
				  contextInfo:NULL];
			
			[self.loginWindow makeFirstResponder:self.loginWindowUserField];
		}
	}
	else
	{
		[[DIRDataProvider sharedInstance] forgetAuthentication];
	}
}

- (IBAction)loginWindowOKAction:(id)sender {
	[NSApp endSheet:self.loginWindow returnCode:NSOKButton];
}

- (IBAction)loginWindowCancelAction:(id)sender {
	[NSApp endSheet:self.loginWindow returnCode:NSCancelButton];
}

- (IBAction)detailSaveAction:(id)sender {
	[_curentDataViewController saveAction];
}

- (IBAction)detailCancelAction:(id)sender {
	[_curentDataViewController cancelAction];
}

#pragma mark Login

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	[sheet orderOut:self];
	
	if (NSOKButton == returnCode)
	{
		[self authenticateWithLogin:self.loginWindowUserField.stringValue andPassword:self.loginWindowPasswordField.stringValue];
	}
	
	[self reloadAuthenticationSate];
	
	if ([[[DIRDataProvider sharedInstance] authenticatedAs] isEqualToString:self.loginWindowUserField.stringValue]) {
		self.loginWindowUserField.stringValue = @"";
		self.loginWindowPasswordField.stringValue = @"";
	}
	else
	{
		[self showLoginPanelAction:self];
	}
}


#pragma mark UI handling

- (void)reloadData
{
	if (!_applicationIsReady) {
		return;
	}
	
	[[DIRDataProvider sharedInstance] allEntriesOfType:[self selectedODRecordType]
										withQueryValue:[self.masterSearchField.stringValue length] > 0 ? self.masterSearchField.stringValue : nil
										  andMatchType:kODMatchInsensitiveContains
								 withCompletionHandler:^(NSArray *entries, NSError *error) {
									 
									 if (!error) {
										 NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.finalList];
										 [array addObjectsFromArray:entries];
										 self.finalList = array;
										 [array release];
									 }
									 else
									 {
										 NSLog(@"Error when retriving entries %@", error);
									 }
								 }];
}

- (void)reloadAuthenticationSate
{
	NSString *authenticatedAs = [[DIRDataProvider sharedInstance] authenticatedAs];
	if ([authenticatedAs length] > 0) {
		self.loginButton.image = [NSImage imageNamed:@"NSLockUnlockedTemplate"];
		self.loginStateField.stringValue = [NSString stringWithFormat:@"Authenticated as %@", authenticatedAs];
	}
	else
	{
		self.loginButton.image = [NSImage imageNamed:@"NSLockLockedTemplate"];
		self.loginStateField.stringValue = @"";
	}
	[self reloadData];
}

- (void)reloadDetailViewForRecord:(ODRecord*)record
{
	if (_curentDataViewController) {
		[_curentDataViewController.view removeFromSuperview];
		[_curentDataViewController release];
	}
	
	_curentDataViewController = [DIRDataViewController newDataViewControllerForRecord:record];

	NSSize detailSuperviewSize = self.detailSuperview.frame.size;
	NSSize detailViewSize = _curentDataViewController.view.frame.size;
	
	CGFloat wDiff = detailViewSize.width - detailSuperviewSize.width;
	CGFloat hDiff = detailViewSize.height - detailSuperviewSize.height;
	
	NSRect windowFrame = self.window.frame;
	
	if (wDiff > 0)
	{
		windowFrame.size.width += wDiff;
	}
	
	if (hDiff > 0) {
		windowFrame.size.height += hDiff;
	}
	
	[self.window setFrame:windowFrame display:YES animate:YES];
	
	[self.detailSuperview addSubview:_curentDataViewController.view];
	
	if (record)
	{
		[self.detailSaveButton setHidden:NO];
		[self.detailCancelButton setHidden:NO];
	}
	else
	{
		[self.detailSaveButton setHidden:YES];
		[self.detailCancelButton setHidden:YES];
	}
	
	[_curentDataViewController reloadData];
}

#pragma mark Adaptors

- (ODRecordType)selectedODRecordType
{
	switch (_selectedRecordType) {
		case kDIRDataTypeUsers:
			return kODRecordTypeUsers;
			break;
			
		case kDIRDataTypeContacts:
			return kODRecordTypePeople;
			break;
			
		default:
			return nil;
			break;
	}
}

#pragma mark TableView

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedRows = self.masterTableView.selectedRowIndexes;
	if ([selectedRows count] == 0) {
		[self reloadDetailViewForRecord:nil];
	}
	else if ([selectedRows count] == 1) {
		ODRecord *selectedRecord = [_finalList objectAtIndex:[selectedRows lastIndex]];
		[self reloadDetailViewForRecord:selectedRecord];
	}
	else
	{
		[self reloadDetailViewForRecord:nil];
	}
}

#pragma mark Observer

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([DIRDataProvider sharedInstance] == object) {
		if ([@"authenticatedAs" isEqualToString:keyPath]) {
			[self reloadAuthenticationSate];
		}
	}
}

#pragma mark - Internal

- (void)authenticateWithLogin:(NSString*)login andPassword:(NSString*)password
{
	NSError *error = [[DIRDataProvider sharedInstance] authenticateWithUsername:login andPassword:password];
	
	if (error) {
		NSLog(@"Authentication error %@", error);
	}
}

@end
