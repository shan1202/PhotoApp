//
//  SinglePhotoController.m
//  
//
//  Created by Andy on 8/8/11.
//  Copyright 2011 JXT. All rights reserved.
//

#import "SinglePhotoController.h"
#import "InputViewController.h"

@implementation SinglePhotoController

@synthesize imageView;
@synthesize navBar;
@synthesize scroView;
@synthesize image;
@synthesize newView;
@synthesize toolBar;
@synthesize singleAsset;
@synthesize info;
@synthesize tempArray;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    db = [[DBOperation alloc]init];
    NSString *createSql =@"create table if not exists photo(id primary key,theme,name,place,other)";
    NSDictionary *tempDic = [singleAsset valueForProperty:ALAssetPropertyURLs];
    self.tempArray = [tempDic allValues];

    NSString *selectSql = [NSString stringWithFormat:@"select * from photo where id = '%@'",[self.tempArray objectAtIndex:0]];
    NSLog(@"selectSql is :%@",selectSql);
    [db openDB];
    [db createTable:createSql];
    dbData = [db selectFromTable:selectSql];
    themeTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 70, 20)];
    nameTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 70, 20)];
    placeTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 70, 20)];
    otherTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 140, 70, 20)];

    theme = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 200, 20)];
    name  = [[UILabel alloc]initWithFrame:CGRectMake(80, 80, 200, 20)];
    place = [[UILabel alloc]initWithFrame:CGRectMake(80, 110, 200, 20)];
    other = [[UILabel alloc]initWithFrame:CGRectMake(80, 140, 200, 20)];

    theme.backgroundColor = [UIColor clearColor];
    themeTitle.backgroundColor = [UIColor clearColor];

    name.backgroundColor = [UIColor clearColor];
    nameTitle.backgroundColor = [UIColor clearColor];

    place.backgroundColor = [UIColor clearColor];
    placeTitle.backgroundColor = [UIColor clearColor];

    other.backgroundColor = [UIColor clearColor];
    otherTitle.backgroundColor = [UIColor clearColor];

    themeTitle.text = @"Theme:";
    theme.text = [dbData valueForKey:@"Theme"];
    nameTitle.text = @"Name:";
    name.text = [dbData valueForKey:@"Name"];
    placeTitle.text = @"Place:";
    place.text = [dbData valueForKey:@"Place"];
    otherTitle.text = @"Other:";
    other.text = [dbData valueForKey:@"Other"];
    
    if ([theme.text isEqualToString:@""]) {
        themeTitle.hidden = YES;
        theme.hidden = YES;
    }
    if ([name.text isEqualToString:@""]) {
        nameTitle.hidden = YES;
        name.hidden = YES;
    }
    if ([place.text isEqualToString:@""]) {
        placeTitle.hidden = YES;
        place.hidden = YES;
    }
    if ([other.text isEqualToString:@""]) {
        otherTitle.hidden = YES;
        other.hidden = YES;
    }
	scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	//newView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	scroView.contentSize = CGSizeMake(400, 500);
	scroView.maximumZoomScale=10.0;
	scroView.minimumZoomScale = 0.5;
	scroView.pagingEnabled = YES;
	scroView.userInteractionEnabled = YES;
	scroView.bounces = YES;
	scroView.bouncesZoom = YES;
	scroView.delegate = self;
	scroView.showsHorizontalScrollIndicator = YES;
    ALAssetRepresentation *rep = [self.singleAsset defaultRepresentation];
    self.image = [UIImage imageWithCGImage:[rep fullResolutionImage]];
	[self.imageView setImage:self.image];
	[scroView addSubview:imageView];
    
	navBar = [[UINavigationBar alloc]init];
	navBar.frame = CGRectMake(0, 0, 320, 44);
	UIBarButtonItem *button= [[UIBarButtonItem alloc]initWithTitle:@"Return" style:UIBarButtonItemStyleBordered target:self action:@selector(disMiss)];
    edit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self 
                                          action:@selector(editMode)];
	UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"PhotoView"];
	item.leftBarButtonItem = button;
    item.rightBarButtonItem = edit;
	[navBar pushNavigationItem:item animated:YES];
	navBar.barStyle = UIBarStyleBlackTranslucent;
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 420, 320, 40)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"Mark" 
                                                             style:UIBarButtonItemStyleBordered 
                                                            target:self 
                                                            action:@selector(markPhoto)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"MarkFrom" 
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                        action:@selector(selectMarkController)];
//    
//    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithTitle:@"" 
//                                                             style:UIBarButtonSystemItemFixedSpace
//                                                            target:self 
//                                                            action:nil];
//    space.width = 50;
    
    inputController = [[InputViewController alloc]init];
    [inputController setDelegate:self];
    item1.width = 145;
    item2.width = 145;
    NSArray *items = [NSArray arrayWithObjects:item1,item2,nil];
    [toolBar setItems:items];
    toolBar.hidden =YES;
    [toolBar sizeToFit];
	[self.view addSubview:scroView];
	[self.view addSubview:navBar];
    [self.view addSubview:toolBar];
    [self.view addSubview:themeTitle];
    [self.view addSubview:nameTitle];
    [self.view addSubview:placeTitle];
    [self.view addSubview:otherTitle];
    [self.view addSubview:theme];
    [self.view addSubview:name];
    [self.view addSubview:place];
    [self.view addSubview:other];

	//[self.view addSubview:newView];
    editing = YES;
	[button release];
	[item release];	
}

#pragma mark -
#pragma mark button method
-(void)markPhoto{
    inputController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:inputController animated:YES];



}

-(void)selectMarkController{
}

-(void)editMode{
    if (!editing) {
        edit.style = UIBarButtonItemStyleBordered;
        [db openDB];
        [db insertToTable:[NSString stringWithFormat:@"insert into photo values('%@','%@','%@','%@','%@')",[self.tempArray objectAtIndex:0],
                           theme.text,name.text,place.text,other.text]];
        edit.title = @"Edit";
        toolBar.hidden = YES;
    }else{
    edit.style = UIBarButtonItemStyleDone;
        edit.title = @"Done";
        toolBar.hidden = NO;
    }
    editing = !editing;
}
//-(void)loadView{
//	scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//	imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//	newView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//	scroView.contentSize = CGSizeMake(400, 500);
//	scroView.maximumZoomScale=10.0;
//	scroView.minimumZoomScale = 0.5;
//	scroView.pagingEnabled = YES;
//	scroView.userInteractionEnabled = YES;
//	scroView.bounces = NO;
//	scroView.bouncesZoom = YES;
//	scroView.delegate = self;
//	scroView.showsHorizontalScrollIndicator = YES;
//	[self.imageView setImage:self.image];
//	[scroView addSubview:imageView];
//	navBar = [[UINavigationBar alloc]init];
//	navBar.frame = CGRectMake(0, 0, 320, 44);
//	UIBarButtonItem *button= [[UIBarButtonItem alloc]initWithTitle:@"Return" style:UIBarButtonItemStyleBordered target:self action:@selector(disMiss)];
//	UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"PhotoView"];
//	item.leftBarButtonItem = button;
//	[navBar pushNavigationItem:item animated:YES];
//	navBar.barStyle = UIBarStyleBlackTranslucent;
//	[self.newView addSubview:scroView];
//	[self.newView addSubview:navBar];
//	[self.view addSubview:newView];
//	[button release];
//	[item release];
//	
//}
-(void)disMiss{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return imageView;
}

//-(void)initImageViewWith:(UIImage *)initImage{
//	imageView.image = initImage;
//}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)buttonClick:(InputViewController *)controller{    
    [self dismissModalViewControllerAnimated:YES];
    info = [controller markInfo];
    //theme.text = @"Theme:";
    theme.text = [info valueForKey:@"Theme:"];
    name.text = [info valueForKey:@"Name:"];
    place.text = [info valueForKey:@"Place:"];
    other.text = [info valueForKey:@"Other:"];
    if ([theme.text isEqualToString:@""]) {
        theme.hidden = YES;
        themeTitle.hidden = YES;
        
    }
//    if ([name.text isEqualToString:@"Name:"]) {
//        name.hidden = YES;
//    }
//    if ([place.text isEqualToString:@"Place:"]) {
//        place.hidden = YES;
//    }
//    if ([other.text isEqualToString:@"Other:"]) {
//        other.hidden = YES;
//    }
    
    [self reloadInputViews];
}
#pragma  mark -
#pragma mark ViewController method
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [db release];
    [info release];
    [singleAsset release];
	[newView release];
	[image release];
	[scroView release];
	[navBar release];
	[imageView release];
    [toolBar release];
    [edit release];
    [tempArray release];
    [super dealloc];
}


#pragma mark -
#pragma mark TouchEvent method
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	if (tapCount ==1) {
		navBar.hidden = YES;
		NSLog(@"dfdj");
	}
}

	

@end
