//
//  BookInfoTableViewCell.h
//  HolyBooks
//
//  Created by Alexander Popov on 27/06/2017.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HolyBook.h"
#import "IWSProgressButton.h"
#import "VerticalBookListCollectionViewCell.h"

@interface BookInfoTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgBookCover;
@property (retain, nonatomic) IBOutlet IWSProgressButton *btnDownload;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblAuthor;
@property (retain, nonatomic) IBOutlet IWSProgressButton *btnDownloadAudio;
@property (retain, nonatomic) IBOutlet UILabel *lblPosition;
@property (nonatomic, assign) id <VerticalBookListCellDelegate> delegate;
@property (retain, nonatomic) HolyBook *curBook;

+ (instancetype)create;
- (void)fillWithData:(HolyBook *)data position:(NSInteger)position;
- (IBAction)btnDownloadAudio_Click:(id)sender;
- (IBAction)btnDownload_Click:(id)sender;
- (void)updateDownloadState;

@end
