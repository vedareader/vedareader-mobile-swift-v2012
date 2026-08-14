//
//  SetTableViewCell.m
//  HolyBooks
//
//  Created by Alexander Popov on 22/06/2017.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "SetTableViewCell.h"
#import "HolyContentManager.h"
#import "UIView+Create.h"
#import "UIView+Autolayout.h"
#import "ImageManager.h"

@implementation SetTableViewCell

+ (instancetype)create
{
	SetTableViewCell *cell = (SetTableViewCell *)[self createFromNib];
	cell.backgroundColor = [UIColor clearColor];	//iPad fix
	[cell innerInit];
	return cell;
}

- (void)innerInit
{
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)dealloc
{
    [_imgBackground release];
    [_lblTitle release];
	[_cnstImageHeight release];
    [super dealloc];
}

- (void)fillWithData:(HolySet *)data
{
	_lblTitle.text = data.name;
	NSString *pathToFile = [HolyContentManager setImageURLWithImageName:data.image];
	//NSURL *URL = [NSURL URLWithString:pathToFile];
	//NSData *imgData = [[NSData alloc] initWithContentsOfURL:URL];
	[ImageManager getImageAsync:pathToFile completedBlock:^(UIImage *image) {
		_imgBackground.image = image;
	}];
	//_imgBackground.image = [UIImage imageWithData:imgData];
	self.cnstImageHeight.constant = (UIScreen.mainScreen.bounds.size.width * 320) / 750;//2.34 / UIScreen.mainScreen.bounds.size.width; //(UIScreen.mainScreen.bounds.size.width * 320) / 750;
	NSLog(@"pathToFile = %@", pathToFile);
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	self.lblTitle.text = @"";
}

@end
