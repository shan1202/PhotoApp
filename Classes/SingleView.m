//
//  SingleView.m
//  ELCImagePickerDemo
//
//  Created by Administrator on 8/20/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "SingleView.h"


@implementation SingleView
@synthesize imageView;
//@synthesize navBar;
@synthesize scroView;
@synthesize toolBar;


- (id)init{
    if ((self = [super init])) {
        // Initialization code
		scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, 480)];
		imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
		
		scroView.contentSize = CGSizeMake(400, 500);
		scroView.maximumZoomScale=2.0;
		scroView.minimumZoomScale = 0.5;
		scroView.pagingEnabled = YES;
		scroView.userInteractionEnabled = YES;
		scroView.bounces = YES;
		scroView.bouncesZoom = YES;
		scroView.delegate = self;
		scroView.showsHorizontalScrollIndicator = YES;
		scroView.showsVerticalScrollIndicator = YES;
		scroView.backgroundColor = [UIColor clearColor];
		[scroView addSubview:imageView];
        
        toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 420, 320, 40)];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"Mark" 
                                                                 style:UIBarButtonItemStyleBordered 
                                                                target:self 
                                                                action:@selector(markPhoto)];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"MardFrom" 
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(selectMarkController)];
        NSArray *items = [NSArray arrayWithObjects:item1,item2,nil];
        [toolBar setItems:items];
		//navBar = [[UINavigationBar alloc]init];
//		navBar.frame = CGRectMake(0, 0, 320, 44);
//		UIBarButtonItem *button= [[UIBarButtonItem alloc]initWithTitle:@"Return" style:UIBarButtonItemStyleBordered target:self action:@selector(disMiss)];
//		UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"PhotoView"];
//		item.leftBarButtonItem = button;
//		[navBar pushNavigationItem:item animated:YES];
//		navBar.barStyle = UIBarStyleBlackTranslucent;
		[self addSubview:scroView];
        [toolBar sizeToFit];
        [self addSubview:toolBar];

        show = YES;
		//[self addSubview:navBar];
//		[button release];
//		[item release];
		
    }
    return self;
}

//-(void)disMiss{
//	[self removeFromSuperview];
//}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
 
    if (show) {
        self.scroView.hidden = YES;
    }
        //show = !show;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return imageView;
}

- (void)dealloc {
    [toolBar release];
    [super dealloc];
	[scroView release];
	//[navBar release];
	[imageView release];
}


@end
