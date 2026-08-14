//
//  VerticalBookListCollectionViewCell.m
//  HolyBooks
//
//  Created by Roman Developer on 10/30/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "VerticalBookListCollectionViewCell.h"
#import "UIView+Autolayout.h"
#import "HolyAuthor.h"
#import "HolyContentManager.h"
#import "NSArray+LINQ.h"
#import "BookState.h"
#import "ImageManager.h"

@interface VerticalBookListCollectionViewCell ()

@property (nonatomic, retain) NSLayoutConstraint *cGreaterConstraint;

@end

@implementation VerticalBookListCollectionViewCell

- (instancetype)init
{
	if (self = [super init])
	{
		[self innerInit];
	}
	
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self innerInit];
}

- (void)innerInit
{
	//Constraints
	self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView dockAll];
	
	//Cover
	[_imgBookCover alignTopWithPadding:15];
	[_imgBookCover alignLeadingWithPadding:32];
	[_imgBookCover alignBottomWithPadding:15];
	
	//Name
	[_lblBookName alignTopWithPadding:22];
	[_lblBookName pinLeadingTo:_imgBookCover withPadding:15];
	[_lblBookName alignTrailingWithPadding:15];
	
	//Author
	[_lblBookAuthor pinTopTo:_lblBookName withPadding:0];
	[_lblBookAuthor pinLeadingTo:_imgBookCover withPadding:15];
	[_lblBookAuthor alignTrailingWithPadding:15];
	self.cGreaterConstraint = [NSLayoutConstraint constraintWithItem:_btnDownloadWithAudio attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_lblBookAuthor attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
	[self.contentView addConstraint:self.cGreaterConstraint];
	
	//Download button
	[_btnDownload pinLeadingTo:_imgBookCover withPadding:15];
	[_btnDownload alignAttribute:NSLayoutAttributeBottom to:_imgBookCover withPadding:0];
	[_btnDownload constraintHeight:23];
	
	_btnDownload.layer.borderWidth = 1;
	_btnDownload.layer.cornerRadius = 2;
	
	//Download with audio button
	[_btnDownloadWithAudio pinLeadingTo:_imgBookCover withPadding:15];
	[_btnDownload pinTopTo:_btnDownloadWithAudio withPadding:10];
	[_btnDownloadWithAudio constraintHeight:23];
	_btnDownloadWithAudio.layer.borderWidth = 1;
	_btnDownloadWithAudio.layer.cornerRadius = 2;
	_btnDownloadWithAudio.layer.borderColor = [kColorBlue CGColor];
	
	//Delete button
	[_btnDelete alignTopWithPadding:0];
	[_btnDelete alignTrailingWithPadding:0];
	[_btnDelete constraintWidth:41];
	[_btnDelete constraintHeight:41];
	_btnDelete.hidden = YES;
	
	//Dividers
	[_imgDividerHorizontal alignAttribute:NSLayoutAttributeLeading to:_imgBookCover withPadding:0];
	[_imgDividerHorizontal alignTrailingWithPadding:0];
	[_imgDividerHorizontal alignBottomWithPadding:0];
	
	[_imgDividerVertical dockTrailing];
	//_imgDividerHorizontal.image = [UIImage imageNamed:@"divider.png"];
}

- (void)dealloc
{
	[_book release];
    [_imgBookCover release];
    [_lblBookName release];
    [_lblBookAuthor release];
    [_btnDownload release];
	[_imgDividerHorizontal release];
	[_imgDividerVertical release];
    [_btnDownloadWithAudio release];
	[_btnDelete release];
	
	[_cGreaterConstraint release];
	
    [super dealloc];
}

#pragma mark - Functionality
- (void)fillDataWithBook: (HolyBook *)book horizontalSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass
{
	self.book = book;
	
	//For regular size class
	if (horizontalSizeClass == UIUserInterfaceSizeClassRegular)
	{
		[_imgBookCover setWidth:96];
		[_imgBookCover setHeight:140];
		
		_imgDividerHorizontal.hidden = YES;
		_imgDividerVertical.hidden = NO;
	}
	else
	{
		[_imgBookCover setWidth:84];
		[_imgBookCover setHeight:125];
		
		_imgDividerHorizontal.hidden = NO;
		_imgDividerVertical.hidden = YES;
	}
	
	HolyAuthor *author = [[[HolyContentManager sharedManager].authors where:@"identity == %d", book.authorID] lastObject];
	NSString *imagePath = [HolyContentManager bookImagePathWithURL:book.image];
	NSString *imageURL = [HolyContentManager bookImageURLWithImageName:book.image];
	
	_imgBookCover.image = [UIImage imageNamed:@"book_default.png"];
	[ImageManager getAndCacheImageAsync:imageURL imagePath:imagePath completedBlock:^(UIImage *image) {
		_imgBookCover.image = image;
	}];
//	[ImageManager getImageForPathAsync:imagePath completedBlock:^(UIImage *image) {
//		_imgBookCover.image = image;
//	}];
	_lblBookName.text = book.name;
	_lblBookAuthor.text = author.name;
	
	//Button
	BookState *bookState = [BookState getByID:book.identity];
	[_btnDownload configureForState:bookState];
	
	//Download with audio
	if (bookState.isDownloaded && bookState.fileType == HolyFileTypeText)
	{
		BOOL audioFileExists = [book.files where:@"type == %ld", HolyFileTypeTextAndAudio].count > 0;
		if (audioFileExists)
		{
			[_btnDownloadWithAudio setTitle:Local(@"VerticalBookList.DownloadWithAudio") forState:UIControlStateNormal];
			_btnDownloadWithAudio.hidden = NO;
		}
		else
			_btnDownloadWithAudio.hidden = YES;
	}
	else
		_btnDownloadWithAudio.hidden = YES;
	
	//Constraint to cut down book name if needed
	_cGreaterConstraint.active = !_btnDownloadWithAudio.hidden;
	
	[self updateDownloadState];
}

- (void)updateDownloadState
{
	BookState *bookState = [BookState getByID:self.book.identity];
	if (!bookState.isDownloaded && bookState.downloadInfo != nil)
		_btnDownloadWithAudio.hidden = YES;
	
	[_btnDownload configureForState:bookState];
}

- (void)setDeleteVisible: (BOOL)isVisible
{
	_btnDelete.hidden = !isVisible;
}

#pragma mark - Actions
- (IBAction)btnDownload_Click:(id)sender
{
	[self.delegate bookDownloadDidSelected:self.book.identity buttonRect:_btnDownload.frame buttonParentView:self];
}

- (IBAction)btnDownloadWithAudio_Click:(id)sender
{
	[self.delegate bookDownloadWithAudioDidSelected:self.book.identity buttonRect:_btnDownloadWithAudio.frame buttonParentView:self];
}

- (IBAction)btnDelete_Click:(id)sender
{
	//TODO: Ask cool question
	
	[self.delegate bookDeleteSelected:self.book.identity];
}

@end
