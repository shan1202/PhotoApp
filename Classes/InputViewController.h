//
//  InputViewController.h
//  ELCImagePickerDemo
//
//  Created by Andy on 9/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface InputViewController : UIViewController {
    IBOutlet UITextField *textField1;
    IBOutlet UITextField *textField2;
    IBOutlet UITextField *textField3;
    IBOutlet UITextField *textField4;
    IBOutlet UIButton *button;
    id  delegate;
    NSDictionary *dic;
    

}

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)NSDictionary *dic;
-(IBAction)hideKeyboard:(id)sender;
-(IBAction)okButtonClick;
-(NSDictionary *)markInfo;
@end


@protocol inputViewControllerDelegate

-(void)buttonClick:(InputViewController *)controller;

@end