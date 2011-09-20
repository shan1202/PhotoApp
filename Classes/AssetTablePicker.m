//
//  AssetTablePicker.m
//
//  Created by Andy.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "AssetTablePicker.h"
#import "ThumbnailCell.h"
#import "Thumbnail.h"
#import "AlbumPickerController.h"
#import "SinglePhotoController.h"


@implementation AssetTablePicker

@synthesize parent;
@synthesize selectedAssetsLabel;
@synthesize assetGroup, elcAssets;
@synthesize toolbar;
@synthesize segmentedControl;

#pragma mark - 
#pragma mark save data to file method while the application terminate
- (void)applicationWillTerminate:(NSNotification *)notification{
    NSLog(@"method cause");
    [NSKeyedArchiver archiveRootObject:photoArray toFile:[self filePath:@"allphotos"]];

}

#pragma mark -
#pragma mark UIViewController Methods
- (void)dealloc
{   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
	[glbElcAsset release];
	[toolbar2 release];
	[navsegmentControl release];
	[actionButton release];
    [selectedAssetsImages release];
	[unSelectedImages release];
	[segmentedControl release];
	[toolbar release];
    [elcAssets release];
    [selectedAssetsLabel release];
    [markArray release];
    [photoArray release];
    [allPhotoes release];
    [super dealloc];    
}

-(void)viewDidUnload{
}
-(void)viewDidLoad {	
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];
	tagSign = YES;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
    [tempArray release];
	selectedAssetsImages = [[NSMutableArray alloc] init] ;
	unSelectedImages  = [[NSMutableArray alloc]init];
	addArray = [[NSMutableArray alloc]init];
    allPhotoes = [NSMutableArray arrayWithCapacity:40];
    [allPhotoes retain];
	photoArray = [[NSMutableArray alloc]init];
	vArray = [[NSMutableArray alloc]init];
	//Set the toolbar with two button delete and send;
	toolbar2 = [[UIToolbar alloc]init];
	toolbar2.barStyle = UIBarStyleBlackTranslucent;
	toolbar2.frame = CGRectMake(0, 436, 320, 50);
	UIBarButtonItem *button1 = [[UIBarButtonItem alloc]initWithTitle:@"delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deletePhoto:)];
	UIBarButtonItem *button2 = [[UIBarButtonItem alloc]initWithTitle:@"send" style:UIBarButtonItemStyleBordered target:self action:@selector(sendPhoto:)];
	UIBarButtonItem *button3 = [[UIBarButtonItem alloc]initWithTitle:@"addPhoto" style:UIBarButtonItemStyleBordered target:self action:@selector(addPhoto:)];
	NSArray *array = [NSArray arrayWithObjects:button3,button2,button1,nil];
	button1.width = 100;
	button2.width = 100;
	button3.width = 90;
	[toolbar2 sizeToFit];
	[toolbar2 setItems:array];
	[self.navigationController.view addSubview:toolbar2];
	[button1 release];
	[button2 release];
	[button3 release];

	//Set the navigationBar 
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
	[self.navigationItem setTitle:@"Loading..."];
	actionButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
																				  target:self 
																				  action:@selector(Mode:)];
	[self.navigationItem setRightBarButtonItem:actionButton];
	//Set three button in the navigationBarItem titleView
	NSArray *array1 = [NSArray arrayWithObjects:@"select",@"Tag all",@"Untag all",nil];
	navsegmentControl = [[UISegmentedControl alloc]initWithItems:array1];
	navsegmentControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	navsegmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[navsegmentControl addTarget:self action:@selector(navSegmentAction:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = navsegmentControl;
	navsegmentControl.hidden = YES;
	
	//Set a tool bar with three button;
	toolbar = [[UIToolbar alloc] init];
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	toolbar.frame = CGRectMake(0, 436, 320, 50);
	NSArray *array2 = [NSArray arrayWithObjects:@"Show all",@"Show tagged",@"Show untagged",nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:array2];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedControl addTarget:self action:@selector(toolbarSegmentAction:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
	[toolbar setItems:[NSArray arrayWithObject:barButton]];
    //Set the toolbar to fit the width of the app.
	[toolbar sizeToFit];
	toolbar.hidden = YES;
	[self.navigationController.view addSubview:toolbar];
	[barButton release];
	UIApplication *app = [UIApplication sharedApplication];
	
	[[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(applicationWillTerminate:) 
                                                name:UIApplicationWillTerminateNotification 
                                              object:app];
   
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
//    NSLog(@"viewdidload count:%u",[elcAssets count]);
//    for (ELCAsset *elcAsset in self.elcAssets) {
//        if (![photoArray containsObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]]) {
//            [elcAssets removeObject:elcAsset];
//            NSLog(@"the coming method");
//        }
//    }
    //[self performSelectorInBackground:@selector(setPhotoArray) withObject:nil];
    //NSLog(@"%@",(glbElcAsset.overlay?@"YES":@"NO"));
    // Show partial while full list loads
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:.5];
}
/*
-(void)setPhotoArray{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
    //NSLog(@"enumerating photos");
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
     {         
         if(result == nil) 
         {
             return;
         }
         
         glbElcAsset = [[ELCAsset alloc] initWithAsset:result];
         [glbElcAsset setParent:self];
         [self.elcAssets addObject:glbElcAsset];
     }];  

    for (ELCAsset *elcAsset in self.elcAssets) {
        if (![photoArray containsObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]]) {
            [elcAssets removeObject:elcAsset];
            NSLog(@"the coming method,photoArray count is:%@",[photoArray count]);
        }
    }
    NSLog(@"the coming method%u",[elcAssets count]);
    [pool release];

}
 */

- (void)viewWillAppear:(BOOL)animated
{
	toolbar2.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
	toolbar2.hidden = YES;
	toolbar.hidden = YES;
	//[self openDB];
//	[self createDB];
//	[self insertDB:elcAssets];
//	[self getPhotos];
//	sqlite3_close(db);
}

-(NSString *)filePath:(NSString *)str{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
	return [directory stringByAppendingPathComponent:str];
}


-(void)preparePhotos {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	
    //NSLog(@"enumerating photos");
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
     {         
         if(result == nil) 
         {
             return;
         }
         
         glbElcAsset = [[Thumbnail alloc] initWithAsset:result];
         [glbElcAsset retain];
         [glbElcAsset setParent:self];
         [self.elcAssets addObject:glbElcAsset];
         [allPhotoes addObject:glbElcAsset];
        }];  
    
    NSMutableArray *photoInFile = [NSMutableArray arrayWithCapacity:40];
   // photoArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath:@"allphotos"]];
    photoInFile = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath:@"allphotos"]];
    for (id array in photoInFile) {
        [photoArray addObject:array];
    }
    if ([photoArray count]==0) {
        NSLog(@"photoArray is null while come to here");
        for (Thumbnail *elcAsset in self.elcAssets) {
            [photoArray addObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]];
        }
    }else{
        NSMutableArray *newPhotoArray = [NSMutableArray arrayWithCapacity:40];
        for (Thumbnail *thnail in self.elcAssets) {
            if ([photoArray containsObject:[thnail.asset valueForProperty:ALAssetPropertyURLs]]) {
                [newPhotoArray addObject:thnail];
            }
        }
        NSLog(@"photoArray is not null and newPhotoarray:%d",[newPhotoArray count]);
        [elcAssets removeAllObjects];
        for (Thumbnail *elcAsset in newPhotoArray) {
            [elcAssets addObject:elcAsset];
        }

    }
    NSLog(@"photoarray count:%d",[photoArray count]);


   // NSLog(@"done enumerating photos");
//                NSMutableArray *array = [NSMutableArray arrayWithCapacity:40];
//                NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:40];//store the delete photo url;
//                NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:40];
//                NSMutableArray *array4 = [NSMutableArray arrayWithCapacity:40];//store the added photo url;
                  vArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath:@"photos"]];
//                array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath:@"delete"]];
//                array3 = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath:@"add"]];
	//for (int i = 0; i<[elcAssets count]; i++) {
//		ELCAsset *elcAsset = [elcAssets objectAtIndex:i];
//		[array addObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]];
//
//	}
                	for (Thumbnail *elcAsset in elcAssets) {
//                		 //for (int i = 0; i<[vArray count]; i++) {

                			 if ([vArray containsObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]]) {
                				 [elcAsset setOverlayHidden:NO];
                			 }
//                		if ([array containsObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]]) {
//                			[array2 addObject:elcAsset];
//                		}
//                		if ([array3 containsObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]]) {
//                			[array4 addObject:elcAsset];
//                		}
//                		// }
//                		 
                       }	
//                [elcAssets removeAllObjects];
//                	for (ELCAsset *elcAsset in array2) {
//                		[elcAssets addObject:elcAsset];
//                	}
//                	for (ELCAsset *elcAsset in array4) {
//                   //     if ([array2 containsObject:elcAsset]) {
//                //            return;
//                //        }else
//                		[elcAssets addObject:elcAsset];
//                	}								
//                	NSLog(@"count the elcasset%d",[elcAssets count]);

	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Pick Photos"];
    [pool release];

	
}

#pragma mark -
#pragma mark ButtonAction Methods

-(IBAction)Mode:(id)sender{
	
	
	UIBarButtonItem *save = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)]autorelease];
	self.navigationItem.rightBarButtonItem = save;
	//NSArray *array1 = [NSArray arrayWithObject:@"delete"];
//	NSArray *array2 = [NSArray arrayWithObject:@"send"];
//	UISegmentedControl *seg1 = [[UISegmentedControl alloc]initWithItems:array1];
//	UISegmentedControl *seg2 = [[UISegmentedControl alloc]initWithItems:array2];
//	
//	[seg1 addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventValueChanged];
//	[seg2 addTarget:self action:@selector(sendPhoto:) forControlEvents:UIControlEventValueChanged];
//	seg1.frame = CGRectMake(0, 0, 150, 30);
//	seg2.frame = CGRectMake(0, 0, 150, 30);
//	seg1.segmentedControlStyle = UISegmentedControlStyleBar;
//	seg2.segmentedControlStyle = UISegmentedControlStyleBar;
//	seg1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	seg2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	UIBarButtonItem *button1 = [[UIBarButtonItem alloc]initWithCustomView:seg1];
//	UIBarButtonItem *button2 = [[UIBarButtonItem alloc]initWithCustomView:seg2];
	//UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	
	//[seg1 release];
	//[seg2 release];
	navsegmentControl.hidden = NO;
	toolbar.hidden = NO;
	toolbar2.hidden = YES;
	tagSign = NO;
	[self.tableView reloadData];
}

-(IBAction)deletePhoto:(id)sender{
	NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:40];//put the photo delete in this array;
    delArray = [NSMutableArray arrayWithCapacity:50];//put the photo don't delete in this array;
	for (Thumbnail *elcAsset in self.elcAssets) {
		if ([elcAsset selected] ) {
			[array addObject:elcAsset];
		}
	}
	for (Thumbnail *elcAsset in array) {
		[elcAssets removeObject:elcAsset];
        [photoArray removeObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]];
	}
	for (Thumbnail *elcAsset in elcAssets) {
		[delArray addObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]];

	}
	NSLog(@"delArray:%d",[delArray count]);
    [NSKeyedArchiver archiveRootObject:delArray toFile:[self filePath:@"delete"]];
	[self.tableView reloadData];
	[array release];

}

-(IBAction)sendPhoto:(id)sender{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc]init];
	picker.mailComposeDelegate=self;
	for (Thumbnail *elcAsset in self.elcAssets) {
		if ([elcAsset selected]) {
			UIImage *image = [UIImage imageWithCGImage:[elcAsset.asset thumbnail]];
			NSData *data = UIImageJPEGRepresentation(image,1);
			[picker addAttachmentData:data mimeType:@"image/jpg" fileName:@"pic.jpg"];
		}
	}
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

//-(IBAction)singleView:(id)sender{
//	controller = [[SinglePhotoController alloc]init];
//	//for (ELCAsset *elcAsset in elcAssets) {
////		if ([elcAsset selected]) {
////			ALAssetRepresentation *rep=[elcAsset.asset defaultRepresentation];
////			UIImage *image = [[UIImage imageWithCGImage:[rep fullResolutionImage]]retain];
////							  [controller.imageView setImage:image];
////		}
////	}
//	UIImage *image = [UIImage imageNamed:@"logo.jpg"];
//	[controller initImageView];
//	[controller viewDidLoad];
//	[self presentModalViewController:controller animated:YES];
//}


-(void)saveAction{
	self.navigationItem.rightBarButtonItem = actionButton;
	toolbar.hidden = YES;
	navsegmentControl.hidden = YES;
	toolbar2.hidden = NO;
	segmentedControl.selectedSegmentIndex = 0;
	tagSign = YES;
	//NSDictionary *dic = nil;
	 markArray = [NSMutableArray arrayWithCapacity:40];
    [markArray retain];
	for (Thumbnail *elcAsset in self.elcAssets) {
		if ([elcAsset selected]) {
			[markArray addObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]];
//			dic = [elcAsset.asset valueForProperty:ALAssetPropertyURLs];
//			NSLog(@"%@",[dic valueForKey:@"public.jpeg"]);
		}
	}
//	NSString *str = (NSString *)[dic valueForKey:@"public.jpeg"];
//	NSLog(@"%@",str);
	//NSMutableArray *array = [NSKeyedUnarchiver	unarchiveObjectWithFile:[self filePath]];
	//[data writeToFile:[self filePath] atomically:YES];
    [NSKeyedArchiver archiveRootObject:markArray toFile:[self filePath:@"photos"]];
	[self.tableView reloadData];
}
-(IBAction)navSegmentAction:(id)sender{
	UISegmentedControl *segc = (UISegmentedControl *)sender;
	if (segc.selectedSegmentIndex == 0) {
		[self doneAction];
	}else if (segc.selectedSegmentIndex == 1) {
		for (Thumbnail *elcAsset in self.elcAssets) {
			if (![elcAsset selected]) {
				[elcAsset setSelected:YES];
				[self.tableView reloadData];
			}
		}
	}else {
		for (Thumbnail *elcAsset in self.elcAssets) {
			if ([elcAsset selected]) {
				[elcAsset setSelected:NO];
				[self.tableView reloadData];
				segc.selectedSegmentIndex = UISegmentedControlNoSegment;

			}
		}
	}

}
-(IBAction)toolbarSegmentAction:(id)sender{
	UISegmentedControl *segment = (UISegmentedControl *)sender;
	if (segment.selectedSegmentIndex ==0) {
		[self.tableView reloadData];
		return;
			
	}else if (segment.selectedSegmentIndex==1) {
		[selectedAssetsImages removeAllObjects];
		for(Thumbnail *elcAsset in self.elcAssets) 
		{		
			if([elcAsset selected]) {
				[selectedAssetsImages addObject:elcAsset];
				[self.tableView reloadData];

			}
		}
		if ([selectedAssetsImages count]== 0) {
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notes" 
														   message:@"There are no tagged images" 
														  delegate:self cancelButtonTitle:@"ok" 
												 otherButtonTitles:nil];
			[alert show];
			[alert release];
			segment.selectedSegmentIndex = 0;
			return;
		}
	}else {
		[unSelectedImages removeAllObjects];
		for(Thumbnail *elcAsset in self.elcAssets) 
		{		
			if(![elcAsset selected]) {
				[unSelectedImages addObject:elcAsset];
				[self.tableView reloadData];
			}
		}
		if ([unSelectedImages count]== 0) {
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notes" 
														   message:@"There are no untagged images" 
														  delegate:self 
												 cancelButtonTitle:@"ok" 
												 otherButtonTitles:nil];
			[alert show];
			[alert release];
			segment.selectedSegmentIndex = 0;
			return;
		}
	}

}

- (void) doneAction {
		[selectedAssetsImages removeAllObjects];
		for(Thumbnail *elcAsset in self.elcAssets) 
		{		
			if([elcAsset selected]) {
				
				[selectedAssetsImages addObject:[elcAsset asset]];
			}
		}
		
		[(AlbumPickerController*)self.parent selectedAssets:selectedAssetsImages];
}

-(IBAction)addPhoto:(id)sender{
	UIImagePickerController *picker = [[UIImagePickerController alloc]init];
	picker.delegate = self;
	//picker.allowsEditing =YES;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		[self presentModalViewController:picker animated:YES];
	}else{
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"photolibary is unavailable" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
		 
}
#pragma mark -
#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (segmentedControl.selectedSegmentIndex==2) {
		return ceil([unSelectedImages count]/4.0);
	}else if (segmentedControl.selectedSegmentIndex ==1) {
		return ceil([selectedAssetsImages count] /4.0);
	}else {
		return ceil([elcAssets count] / 4.0);
	}

    
}

// ugly
-(NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
    
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
    
	 //NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [elcAssets count]);
	//NSLog(@"%d",[selectedAssetsImages count]);
//	NSLog(@"%d",[unSelectedImages count]);
	if (segmentedControl.selectedSegmentIndex ==2) {
		if(maxIndex < [unSelectedImages count]) {
			
			return [NSArray arrayWithObjects:[unSelectedImages objectAtIndex:index],
					[unSelectedImages objectAtIndex:index+1],
					[unSelectedImages objectAtIndex:index+2],
					[unSelectedImages objectAtIndex:index+3],
					nil];
		}
		
		else if(maxIndex-1 < [unSelectedImages count]) {
			
			return [NSArray arrayWithObjects:[unSelectedImages objectAtIndex:index],
					[unSelectedImages objectAtIndex:index+1],
					[unSelectedImages objectAtIndex:index+2],
					nil];
		}
		
		else if(maxIndex-2 < [unSelectedImages count]) {
			
			return [NSArray arrayWithObjects:[unSelectedImages objectAtIndex:index],
					[unSelectedImages objectAtIndex:index+1],
					nil];
		}
		
		else if(maxIndex-3 < [unSelectedImages count]) {
			
			return [NSArray arrayWithObject:[unSelectedImages objectAtIndex:index]];
		
		}
   }else if (segmentedControl.selectedSegmentIndex==1) {
		if(maxIndex < [selectedAssetsImages count]) {
			
			return [NSArray arrayWithObjects:[selectedAssetsImages objectAtIndex:index],
					[selectedAssetsImages objectAtIndex:index+1],
					[selectedAssetsImages objectAtIndex:index+2],
					[selectedAssetsImages objectAtIndex:index+3],
					nil];
		}
		
		else if(maxIndex-1 < [selectedAssetsImages count]) {
			
			return [NSArray arrayWithObjects:[selectedAssetsImages objectAtIndex:index],
					[selectedAssetsImages objectAtIndex:index+1],
					[selectedAssetsImages objectAtIndex:index+2],
					nil];
		}
		
		else if(maxIndex-2 < [selectedAssetsImages count]) {
			
			return [NSArray arrayWithObjects:[selectedAssetsImages objectAtIndex:index],
					[selectedAssetsImages objectAtIndex:index+1],
					nil];
		}
		
		else if(maxIndex-3 < [selectedAssetsImages count]) {
			
			return [NSArray arrayWithObject:[selectedAssetsImages objectAtIndex:index]];
		}
	}else {
		if(maxIndex < [self.elcAssets count]) {
			
			return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
					[self.elcAssets objectAtIndex:index+1],
					[self.elcAssets objectAtIndex:index+2],
					[self.elcAssets objectAtIndex:index+3],
					nil];
		}
		
		else if(maxIndex-1 < [self.elcAssets count]) {
			
			return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
					[self.elcAssets objectAtIndex:index+1],
					[self.elcAssets objectAtIndex:index+2],
					nil];
		}
		
		else if(maxIndex-2 < [self.elcAssets count]) {
			
			return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
					[self.elcAssets objectAtIndex:index+1],
					nil];
		}
		
		else if(maxIndex-3 < [self.elcAssets count]) {
			
			return [NSArray arrayWithObject:[self.elcAssets objectAtIndex:index]];
			}

    }
	
    
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
        
    ThumbnailCell *cell = (ThumbnailCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	[cell setCellOverlay:tagSign];

    if (cell == nil) 
    {		        
        cell = [[[ThumbnailCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] 
									 reuseIdentifier:CellIdentifier] autorelease];
    }	
	else 
    {		
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}


- (int)totalSelectedAssets {
    
    int count = 0;
    
    for(Thumbnail *asset in self.elcAssets) 
    {
		if([asset selected]) 
        {            
            count++;	
		}
	}
    
    return count;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}

//#pragma mark -
//#pragma mark	sqlite3 methods
//
//-(NSString *)filePath{
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentDir = [paths objectAtIndex:0];
//	return [documentDir stringByAppendingPathComponent:@"database.sql"];
//}
//
//-(void)openDB{
//	if (sqlite3_open([[self filePath]UTF8String], &db)!=SQLITE_OK) {
//		sqlite3_close(db);
//		NSAssert(0,@"Database failed to open.");
//	}
//}
//
//-(void)createDB{
//	char *err;
//	NSString *sqlCreate = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS photos('photo' BLOB PRIMARY KEY);"];
//	if (sqlite3_exec(db, [sqlCreate UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
//		sqlite3_close(db);
//		NSAssert(0,@"Table failed to create.");
//	}
//}
//-(void)insertDB:(NSArray *)array{
//	char *err;
//	NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO photos ('photo')VALUES('%@')",array];
//	if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
//		sqlite3_close(db);
//		NSAssert(0,@"Error updating table.");
//	}
//}
//
//-(void)getPhotos{
//	NSString *qsql = @"select * from photos";
//	sqlite3_stmt *statement;
//	if (sqlite3_prepare(db, [qsql UTF8String], -1, &statement, nil)==SQLITE_OK) {
//		while (sqlite3_step(statement)==SQLITE_ROW) {
//			muarray = [NSMutableArray arrayWithCapacity:50];
//			muarray = (NSMutableArray *)sqlite3_column_blob(statement, 0);
//		}
//		sqlite3_finalize(statement);
//		NSLog(@"The photo is%@",[muarray objectAtIndex:1]);
//	}
//	
//	
//}
					  
#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate  and UIImagePickerdelegate Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error{
	[self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissModalViewControllerAnimated:YES];	
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	NSURL *imageUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
	
	//NSString *str = [NSString stringWithContentsOfURL:imageUrl];
	for (Thumbnail *elcAsset in allPhotoes) {
		NSDictionary *dic = [elcAsset.asset valueForProperty:ALAssetPropertyURLs];
		if ([imageUrl isEqual:[dic valueForKey:@"public.jpeg"]]||[imageUrl isEqual:[dic valueForKey:@"public.png"]]) {
			if (![elcAssets containsObject:elcAsset]) {
				[elcAssets addObject:elcAsset];
                [photoArray addObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]];
				[addArray addObject:[elcAsset.asset valueForProperty:ALAssetPropertyURLs]];
				NSLog(@"come here");
			}
			
		}
	}
    NSLog(@"select:%d",[photoArray count]);
    [NSKeyedArchiver archiveRootObject:addArray toFile:[self filePath:@"add"]];
	[self.tableView reloadData];														  
	[picker dismissModalViewControllerAnimated:YES];
	
}
@end
