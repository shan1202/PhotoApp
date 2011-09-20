//
//  InputViewController.m
//  ELCImagePickerDemo
//
//  Created by Andy on 9/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "InputViewController.h"


@implementation InputViewController
@synthesize delegate;
@synthesize dic;

-(NSDictionary *)markInfo{
    dic = [NSDictionary dictionaryWithObjectsAndKeys:textField1.text,@"Theme:",textField2.text,@"Name:",textField3.text,@"Place:",textField4.text,@"Other:", nil];
    return dic;
}
-(IBAction)hideKeyboard:(id)sender{
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
    [textField3 resignFirstResponder];
    [textField4 resignFirstResponder];
}
-(IBAction)okButtonClick{
//    SinglePhotoController*  controller = [[SinglePhotoController alloc]init];
//        controller.label.backgroundColor = [UIColor clearColor];
//        controller.name = @"Name:";
//    //[self.parentViewController.view addSubview:nameTitle];
//    //[self presentModalViewController:controller animated:YES]; 
//    [self dismissModalViewControllerAnimated:YES];
    if ([delegate respondsToSelector:@selector(buttonClick:)]) {
        [delegate performSelector:@selector(buttonClick:) withObject:self];
    }

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UIImage *image = [UIImage imageNamed:@"blueButton.png"];
    UIImage *normalImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [button setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    
    UIImage *imagePressed = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateNormal];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
