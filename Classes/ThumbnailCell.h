//
//  AssetCell.h
//
//  Created by Andy.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThumbnailCell : UITableViewCell
{
	NSArray *rowAssets;
	BOOL cellOverlay;
}

-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier;
-(void)setAssets:(NSArray*)_assets;
-(void)setCellOverlay:(BOOL)setBool;

@property (nonatomic,retain) NSArray *rowAssets;

@end
