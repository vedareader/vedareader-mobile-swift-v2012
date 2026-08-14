//
//  SetTableViewCell.h
//  HolyBooks
//
//  Created by Alexander Popov on 22/06/2017.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HolySet.h"

@interface SetTableViewCell : UITableViewCell
{
	NSString *setTitle;
	NSString *imagePath;
}
@property (retain, nonatomic) IBOutlet UIImageView *imgBackground;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cnstImageHeight;

+ (instancetype)create;
- (void)fillWithData:(HolySet *)data;

@end
