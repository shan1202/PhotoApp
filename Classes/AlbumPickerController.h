//
//  AlbumPickerController.h
//
//  Created by Andy.
//  Copyright 2011 JXT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlbumPickerController : UITableViewController {
	
	NSMutableArray *assetGroups;
	NSOperationQueue *queue;
	id parent;
}

@property (nonatomic, assign) id parent;
@property (nonatomic, retain) NSMutableArray *assetGroups;

-(void)selectedAssets:(NSArray*)_assets;

@end

