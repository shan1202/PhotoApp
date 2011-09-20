//
//  ELCImagePickerController.h
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerController : UINavigationController {

	id delegate;
}

@property (nonatomic, assign) id delegate;

-(void)selectedAssets:(NSArray*)_assets;
-(void)cancelImagePicker;

@end

@protocol ImagePickerControllerDelegate

- (void)elcImagePickerController:(ImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ImagePickerController *)picker;

@end

