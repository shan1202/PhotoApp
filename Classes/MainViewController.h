//
//  ELCImagePickerDemoViewController.h
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickerController.h"

@interface MainViewController : UIViewController <ImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {

	IBOutlet UIScrollView *scrollview;
	UIImageView *imageview;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;

-(IBAction)launchController;

@end

