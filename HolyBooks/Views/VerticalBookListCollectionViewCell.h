//
//  VerticalBookListCollectionViewCell.h
//  HolyBooks
//
//  Created by Roman Developer on 10/30/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HolyBook.h"
#import "IWSProgressButton.h"

#define kVerticalBookListCellCompactSize CGSizeMake(300, 155)
#define kVerticalBookListCellRegularSize CGSizeMake(341, 170)

@protocol VerticalBookListCellDelegate <NSObject>

- (void)bookDownloadDidSelected: (NSInteger)bookID buttonRect: (CGRect)buttonRect buttonParentView: (UIView *)buttonParentView;
- (void)bookDownloadWithAudioDidSelected: (NSInteger)bookID buttonRect: (CGRect)buttonRect buttonParentView: (UIView *)buttonParentView;

@optional
- (void)bookDeleteSelected: (NSInteger)bookID;

@end

@interface VerticalBookListCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) HolyBook *book;
@property (nonatomic, assign) id <VerticalBookListCellDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIImageView *imgBookCover;
@property (retain, nonatomic) IBOutlet UILabel *lblBookName;
@property (retain, nonatomic) IBOutlet UILabel *lblBookAuthor;
@property (retain, nonatomic) IBOutlet IWSProgressButton *btnDownload;
@property (retain, nonatomic) IBOutlet IWSProgressButton *btnDownloadWithAudio;
@property (retain, nonatomic) IBOutlet UIImageView *imgDividerHorizontal;
@property (retain, nonatomic) IBOutlet UIImageView *imgDividerVertical;
@property (retain, nonatomic) IBOutlet UIButton *btnDelete;

- (void)fillDataWithBook: (HolyBook *)book horizontalSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass;
- (void)updateDownloadState;
- (void)setDeleteVisible: (BOOL)isVisible;

- (IBAction)btnDownload_Click:(id)sender;
- (IBAction)btnDownloadWithAudio_Click:(id)sender;
- (IBAction)btnDelete_Click:(id)sender;

@end
