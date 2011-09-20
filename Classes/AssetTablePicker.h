//
//  AssetTablePicker.h
//
//  Created by Andy.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MessageUI/MessageUI.h>
#import "Thumbnail.h"
#import "sqlite3.h"
#import "SinglePhotoController.h"

@interface AssetTablePicker : UITableViewController<MFMailComposeViewControllerDelegate,
								UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
	ALAssetsGroup *assetGroup;
	
	NSMutableArray *elcAssets;
	NSMutableArray *selectedAssetsImages;
	NSMutableArray *unSelectedImages;
	NSMutableArray *photoArray;
    NSMutableArray *allPhotoes; //store all the photoes;
	NSMutableArray *addArray;  //store the photo add from the photolibary;
    NSMutableArray *markArray; //store the photo marked or the photo have been set some info;
    NSMutableArray *delArray; //store the photo except delete photo;
	int selectedAssets;
	
	id parent;
	
	NSOperationQueue *queue;
	UIToolbar *toolbar;
	UISegmentedControl *segmentedControl;
	UIBarButtonItem *actionButton;
	UISegmentedControl *navsegmentControl;
	UIToolbar *toolbar2;
	Thumbnail *glbElcAsset;
	NSMutableArray *vArray;
	BOOL tagSign;
	SinglePhotoController *controller;
	//sqlite3 *db;
//	NSMutableArray *muarray;
}

@property (nonatomic, assign) id parent;
@property (nonatomic, assign) ALAssetsGroup *assetGroup;
@property (nonatomic, retain) NSMutableArray *elcAssets;
@property (nonatomic, retain) IBOutlet UILabel *selectedAssetsLabel;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic,retain)UISegmentedControl *segmentedControl;

-(int)totalSelectedAssets;
-(void)preparePhotos;
-(NSString *)filePath:(NSString*)str;
-(void)doneAction;
- (void)applicationWillTerminate:(NSNotification *)notification;


@end