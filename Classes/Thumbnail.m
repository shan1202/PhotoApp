//
//  Asset.m
//
//  Created by Andy.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "Thumbnail.h"
#import "AssetTablePicker.h"
#import "SinglePhotoController.h"


@implementation Thumbnail

@synthesize asset;
@synthesize parent;
@synthesize overlay;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithAsset:(ALAsset*)_asset{
	
	if (self == [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
		
		self.asset = _asset;
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];
		[assetImageView release];
		
		overlayView = [[UIImageView alloc]initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
		
		overlayView2 = [[UIImageView alloc] initWithFrame:viewFrames];//CGRectMake(45, 0, 30, 30)];
		[overlayView2 setImage:[UIImage imageNamed:@"overlay2.png"]];
		[overlayView2 setHidden:YES];
		[self addSubview:overlayView2];
    }
    
	return self;	
}
-(void)setOverlayHidden:(BOOL)hide{
	overlayView2.hidden = hide;
}

-(void)toggleSelection {
    if (overlay) {
		overlayView.hidden = !overlayView.hidden;
	}else {
		overlayView2.hidden = !overlayView2.hidden;
	}

    
//    if([(ELCAssetTablePicker*)self.parent totalSelectedAssets] >= 10) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Maximum Reached" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//		[alert show];
//		[alert release];	
//
//        [(ELCAssetTablePicker*)self.parent doneAction:nil];
//    }
	//NSLog(@"BOOL value is%@",(overlay ? @"YES":@"NO"));
}

-(BOOL)selected {
	if (overlay) {
		return !overlayView.hidden;
	}else {
		return !overlayView2.hidden;

	}

}

-(void)setSelected:(BOOL)_selected {
	if (overlay) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
		[overlayView setHidden:!_selected];
	}else {
		[overlayView2 setHidden:!_selected];
	}
}

#pragma mark -
#pragma mark touch event
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	if (tapCount == 1) {
		controller = [[SinglePhotoController alloc]init];
        controller.singleAsset = self.asset;
        [self.parent presentModalViewController:controller animated:YES];

        
        
		//controller.image = [UIImage imageWithCGImage:[rep fullResolutionImage]];
		//controller.imageView.image = image;
		//view = [[SingleView alloc]init];
		//view.imageView.image = image;
		//[controller.view addSubview:view];
        //ALAssetRepresentation *rep=[self.asset defaultRepresentation];		
		//UIImage *image = [UIImage imageNamed:@"loge.jpg"];
//		view.imageView.image = image;
//		[self.parent addSubview:view];
	}
}


- (void)dealloc 
{    
	[controller release];
	[overlayView2 release];
    self.asset = nil;
	[overlayView release];
    [super dealloc];
}

@end

