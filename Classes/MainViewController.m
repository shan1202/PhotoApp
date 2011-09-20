//
//  ELCImagePickerDemoViewController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "PhotoAppDelegate.h"
#import "MainViewController.h"
#import "ImagePickerController.h"
#import "AlbumPickerController.h"

@implementation MainViewController

@synthesize scrollview;

-(IBAction)launchController {
    AlbumPickerController *albumController = [[AlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];  
	ImagePickerController *elcPicker = [[ImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    PhotoAppDelegate *app = (PhotoAppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.viewController presentModalViewController:elcPicker animated:YES];
    [elcPicker release];
    [albumController release];
	}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	
	[self dismissModalViewControllerAnimated:YES];
	
	CGRect workingFrame = scrollview.frame;
	workingFrame.origin.x = 0;
	
	for(NSDictionary *dict in info) {
	
		imageview = [[UIImageView alloc] initWithImage:[dict objectForKey:UIImagePickerControllerOriginalImage]];
		[imageview setContentMode:UIViewContentModeScaleToFill];
		imageview.frame = workingFrame;
		
		[scrollview addSubview:imageview];
		
		
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
	}
	
	scrollview.maximumZoomScale=10.0;
	scrollview.minimumZoomScale = 0.5;
	scrollview.pagingEnabled = YES;
	scrollview.userInteractionEnabled = YES;
	scrollview.bounces = NO;
	scrollview.bouncesZoom = NO;
	scrollview.delegate = self;
	
	[scrollview setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return imageview;
}

- (void)elcImagePickerControllerDidCancel:(ImagePickerController *)picker {

	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[imageview release];
    [super dealloc];
}

@end
