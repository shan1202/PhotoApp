//
//  SingleView.h
//  ELCImagePickerDemo
//
//  Created by Administrator on 8/20/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SingleView : UIView<UIScrollViewDelegate> {
	UIScrollView *scroView;
	UIImageView *imageView;
	//UINavigationBar *navBar;
    BOOL show;
    UIToolbar *toolBar;
}
@property(nonatomic,retain)UIImageView *imageView;
//@property(nonatomic,retain)UINavigationBar *navBar;
@property(nonatomic,retain)UIScrollView *scroView;
@property(nonatomic,retain)UIToolbar *toolBar;
@end
