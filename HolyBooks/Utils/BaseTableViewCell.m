//
//  BaseTableViewCell.m
//  SAS
//
//  Created by Konstantin Oznobikhin on 16/10/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell : UITableViewCell

+ (NSString *)reuseID
{
	NSString *result = NSStringFromClass(self);
	
	return result;
}

+ (void)registerFor:(UITableView *)tableView
{
	NSString *reuseID = [self reuseID];
	
	[tableView registerClass:[self class] forCellReuseIdentifier:reuseID];
}

- (NSString *)reuseIdentifier
{
	return [[self class] reuseID];
}

@end
