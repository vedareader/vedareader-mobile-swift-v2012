//
//  BookInfoTableViewCell.m
//  HolyBooks
//
//  Created by Alexander Popov on 27/06/2017.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "BookInfoTableViewCell.h"
#import "HolyAuthor.h"
#import "HolyContentManager.h"
#import "BookState.h"

#import "ImageManager.h"
#import "HolyContentManager.h"
#import "UIView+Create.h"
#import "UIView+Autolayout.h"
#import "ImageManager.h"
#import "NSArray+LINQ.h"

@implementation BookInfoTableViewCell

+ (instancetype)create
{
	BookInfoTableViewCell *cell = (BookInfoTableViewCell *)[self createFromNib];
	cell.backgroundColor = [UIColor clearColor];	//iPad fix
	cell.imgBookCover.image = [UIImage imageNamed:@"book_default.png"];
	[cell innerInit];
	return cell;
}

- (void)innerInit
{
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	//Download button
	self.btnDownload.layer.borderWidth = 1;
	self.btnDownload.layer.cornerRadius = 2;
	
	//Download with audio button
	self.btnDownloadAudio.layer.borderWidth = 1;
	self.btnDownloadAudio.layer.cornerRadius = 2;
	self.btnDownloadAudio.layer.borderColor = [kColorBlue CGColor];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillWithData:(HolyBook *)data position:(NSInteger)position
{
	self.curBook = data;
	
	_lblTitle.text = data.name;
	HolyAuthor *author = [[[HolyContentManager sharedManager].authors where:@"identity == %d", data.authorID] lastObject];
	_lblAuthor.text = author.name;
	
	_lblPosition.text = [NSString stringWithFormat:@"%ld", position];
	
	NSString *imagePath = [HolyContentManager bookImagePathWithURL:data.image];
	NSString *imageURL = [HolyContentManager bookImageURLWithImageName:data.image];
	[ImageManager getAndCacheImageAsync:imageURL imagePath:imagePath completedBlock:^(UIImage *image) {
		_imgBookCover.image = image;
	}];
	
	//Button
	BookState *bookState = [BookState getByID:data.identity];
	[_btnDownload configureForState:bookState];
	
	//Download with audio
	if (bookState.isDownloaded && bookState.fileType == HolyFileTypeText)
	{
		BOOL audioFileExists = [data.files where:@"type == %ld", HolyFileTypeTextAndAudio].count > 0;
		if (audioFileExists)
		{
			[_btnDownloadAudio setTitle:Local(@"VerticalBookList.DownloadWithAudio") forState:UIControlStateNormal];
			_btnDownloadAudio.hidden = NO;
		}
		else
			_btnDownloadAudio.hidden = YES;
	}
	else
		_btnDownloadAudio.hidden = YES;
	
	[self updateDownloadState];
}

- (IBAction)btnDownloadAudio_Click:(id)sender
{
	[self.delegate bookDownloadWithAudioDidSelected:self.curBook.identity buttonRect:_btnDownloadAudio.frame buttonParentView:self];
}

- (IBAction)btnDownload_Click:(id)sender
{
	[self.delegate bookDownloadDidSelected:self.curBook.identity buttonRect:_btnDownload.frame buttonParentView:self];
}

- (void)dealloc
{
	[_imgBookCover release];
	[_btnDownload release];
	[_lblTitle release];
	[_lblAuthor release];
	[_btnDownloadAudio release];
	[_lblPosition release];
	[super dealloc];
}

- (void)updateDownloadState
{
	BookState *bookState = [BookState getByID:self.curBook.identity];
	if (!bookState.isDownloaded && bookState.downloadInfo != nil)
		_btnDownloadAudio.hidden = YES;
	
	[_btnDownload configureForState:bookState];
}

@end
