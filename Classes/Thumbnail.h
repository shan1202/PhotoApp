//
//  Asset.h
//
//  Created by Andy.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SinglePhotoController.h"
#import "SingleView.h"


@interface Thumbnail : UIView {
	ALAsset *asset;
	UIImageView *overlayView;
	BOOL selected;
	id parent;
	SinglePhotoController *controller;
	UIImageView *overlayView2;
	BOOL overlay;
	SingleView *view;
}

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id parent;
@property (nonatomic,assign)BOOL overlay;

-(id)initWithAsset:(ALAsset*)_asset;
-(BOOL)selected;
-(void)setSelected:(BOOL)_selected;
-(void)setOverlayHidden:(BOOL)hide;



@end