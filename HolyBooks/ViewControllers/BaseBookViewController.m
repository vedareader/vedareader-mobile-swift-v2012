//
//  BaseBookViewController.m
//  HolyBooks
//
//  Created by Roman Developer on 1/19/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "BaseBookViewController.h"
#import "BookDetailsViewController.h"

#import "BookReaderViewController.h"

#import "HolyContentManager.h"
#import "BookState.h"
#import "HolyClasses.h"
#import "HolyDownloadManager.h"

#import "NSArray+LINQ.h"

@interface BaseBookViewController ()

@end

@implementation BaseBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDownloadCompletedMessage:) name:[DownloadCompletedMessage identifier] object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDownloadProgressMessage:) name:[DownloadProgressMessage identifier] object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[HolyDownloadManager sharedManager] rejoinToDownloadSession];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

#pragma mark - HorizontalBookListDelegate
- (void)bookDidSelected:(NSInteger)bookID
{
	NSLog(@"Book selected: %ld", (long)bookID);
	
	[self openBookDetailsForBookID:bookID];
}

#pragma mark - VerticalBookListCellDelegate
- (void)bookDownloadDidSelected:(NSInteger)bookID buttonRect:(CGRect)buttonRect buttonParentView:(UIView *)buttonParentView
{
	NSLog(@"Book download selected: %ld", (long)bookID);
	
	BookState *bookState = [BookState getByID:bookID];
	if (!bookState.isDownloaded && bookState.downloadInfo == nil)
	{
		[self downloadBook:bookID buttonRect:buttonRect buttonParentView:buttonParentView];
	}
	else if (bookState.isDownloaded && !bookState.isUnpacking)
	{
		[self makeBookViewerWithBookID:bookID];
	}
	else
		NSLog(@"Action not supported");
}

- (void)bookDownloadWithAudioDidSelected:(NSInteger)bookID buttonRect:(CGRect)buttonRect buttonParentView:(UIView *)buttonParentView
{
	//Remove text version
	[HolyFile removeAllWithBookID:bookID];
	
	//Clear book state for download
	BookState *bookState = [BookState getByID:bookID];
	[bookState clear];
	
	//Download
	HolyBook *book = [[HolyContentManager sharedManager].books where:@"identity == %ld", (long)bookID][0];
	HolyFile *file = [book.files where:@"type == %ld", HolyFileTypeTextAndAudio][0];
	[[HolyDownloadManager sharedManager] downloadBook:book bookFile:file];
}

#pragma mark - Book open and download
- (void)openBookDetailsForBookID: (NSInteger)bookID
{
	[self.delegate mainMenuStopInteracting];
	
	BookDetailsViewController *bookDetailsViewController = [[BookDetailsViewController alloc] initWithBookID:bookID];
	[self.navigationController pushViewController:bookDetailsViewController animated:YES];
	[bookDetailsViewController release];
}

- (void)downloadBook: (NSInteger)bookID buttonRect:(CGRect)buttonRect buttonParentView:(UIView *)buttonParentView
{
	HolyBook *book = [[HolyContentManager sharedManager].books where:@"identity == %ld", (long)bookID][0];
	
	//Prepare action sheet
	UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:book.name message:Local(@"SelectDownload.DownloadVersion") preferredStyle:UIAlertControllerStyleActionSheet];
	for (HolyFile *file in book.files)
	{
		NSString *title = (file.type == HolyFileTypeText) ? Local(@"SelectDownload.Text") : Local(@"SelectDownload.TextAndAudio");
		title = [NSString stringWithFormat:@"%@ (%ld %@)", title, (long)file.size, Local(@"SelectDownload.Mb")];
		[actionSheet addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[[HolyDownloadManager sharedManager] downloadBook:book bookFile:file];
		}]];
	}
	
	[actionSheet addAction:[UIAlertAction actionWithTitle:Local(@"SelectDownload.Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		//
	}]];
	
	//For iPad
	if (buttonParentView != nil)
		buttonRect = [self.view convertRect:buttonRect fromView:buttonParentView];
	actionSheet.popoverPresentationController.sourceView = self.view;
	actionSheet.popoverPresentationController.sourceRect = buttonRect;
	
	//Show
	[self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - Book reading
- (void)makeBookViewerWithBookID: (NSInteger)bookID
{
	BookReaderViewController *readerVC = [BookReaderViewController readerWithBookID:bookID];
	UINavigationController *vc = [[[UINavigationController alloc] initWithRootViewController:readerVC] autorelease];
	vc.navigationBarHidden = YES;
	[self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Message Handlers
- (void)handleDownloadCompletedMessage:(NSNotification *)notification
{
	DownloadCompletedMessage *message = [DownloadCompletedMessage messageFromNotification:notification];
	[self updateForDownloadCompletedWithBookID:message.bookID];
}

- (void)handleDownloadProgressMessage:(NSNotification *)notification
{
	DownloadProgressMessage *message = [DownloadProgressMessage messageFromNotification:notification];
	[self updateForDownloadProgressWithBookID:message.bookID];
}

- (void)updateForDownloadCompletedWithBookID: (NSInteger)bookID
{
	//Override in child class
}

- (void)updateForDownloadProgressWithBookID: (NSInteger)bookID
{
	//Override in child class
}

@end
