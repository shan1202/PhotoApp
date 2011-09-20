//
//  Input.m
//  ELCImagePickerDemo
//
//  Created by Andy on 9/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "InputController.h"


@implementation InputController

-(IBAction)hideKeyboard:(id)sender{
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
    [textField3 resignFirstResponder];
    [textField3 resignFirstResponder];
}
-(IBAction)okButtonClick{
//   controller = [[SinglePhotoController alloc]init];
//    [self presentModalViewController:controller animated:YES]; 
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark ViewcController method
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
