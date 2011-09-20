//
//  Input.h
//  ELCImagePickerDemo
//
//  Created by Andy on 9/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputController: UIViewController {
    IBOutlet UITextField *textField1;
    IBOutlet UITextField *textField2;
    IBOutlet UITextField *textField3;
    IBOutlet UITextField *textField4;
    //SinglePhotoController *controller;

    
}
-(IBAction)hideKeyboard:(id)sender;
-(IBAction)okButtonClick;

@end
