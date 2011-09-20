//
//  SinglePhotoController.h
//  
//
//  Created by Andy on 8/8/11.
//  Copyright 2011 JXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import"InputViewController.h"
#import "DBOperation.h"


@interface SinglePhotoController : UIViewController<UIScrollViewDelegate,inputViewControllerDelegate> {
	 UIScrollView *scroView;
	 UIImageView *imageView;
	UINavigationBar *navBar;
	UIImage *image;
	UIView *newView;
    UIToolbar *toolBar;
    UIBarButtonItem *edit;
    BOOL editing;
	ALAsset *singleAsset;
    
    UILabel *themeTitle;
    UILabel *nameTitle;
    UILabel *placeTitle;
    UILabel *otherTitle;
    UILabel *theme;
    UILabel *name;
    UILabel *place;
    UILabel *other;
    InputViewController *inputController;
    NSDictionary *info;
    DBOperation *db;
    NSDictionary *dbData;
    NSArray *tempArray;
}
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UINavigationBar *navBar;
@property(nonatomic,retain)UIScrollView *scroView;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,retain)UIView *newView;
@property(nonatomic,retain)UIToolbar *toolBar;
@property(nonatomic,retain)ALAsset *singleAsset;
@property(nonatomic,retain)NSDictionary *info;
@property(nonatomic,retain)NSArray *tempArray;

//-(void)initImageView;

@end
