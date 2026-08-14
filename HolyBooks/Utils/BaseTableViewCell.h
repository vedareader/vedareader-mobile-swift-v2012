//
//  BaseTableViewCell.h
//  SAS
//
//  Created by Konstantin Oznobikhin on 16/10/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Base class for TableView cells.
 *
 * Provides facilities for cells registering with reusable identifier.
 */
@interface BaseTableViewCell : UITableViewCell

/**
 * Gets reusable identifier for this cell type.
 */
+ (NSString *)reuseID;

/**
 * Registers cell class within the specified TableView object using this cell type reusable identifier.
 * @param tableView the TableView object to register cell with.
 */
+ (void)registerFor:(UITableView *)tableView;

/**
 * Gets reusable identifier for this cell type.
 *
 * Overrides UITableViewCell.reuseIdentifier property so there is no need to specify this identifier in xib.
 */
- (NSString *)reuseIdentifier;

@end
