//
//  HolyDownloadManager.m
//  HolyBooks
//
//  Created by Roman Developer on 2/19/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "HolyDownloadManager.h"
#import "BookState.h"
#import "HolyContentManager.h"
#import "IWSBackgroundDownloader.h"
#import "NSArray+LINQ.h"

@implementation HolyDownloadManager

+ (HolyDownloadManager *)sharedManager
{
	static HolyDownloadManager *manager = nil;
	if (manager == nil)
		manager = [[HolyDownloadManager alloc] init];
	
	return manager;
}

- (void)rejoinToDownloadSession
{
	NSLog(@"Trying to rejoin to session");
	
	//Rejoin
	[[IWSBackgroundDownloader sharedDownloader] tryToRejoinToSessionWithCompletion:^(NSString *bookIdentifier) {
		
		NSLog(@"Rejoined to session: %@", bookIdentifier);
		
		if (bookIdentifier != nil)
		{
			BookState *bookState = [BookState getByID:[bookIdentifier integerValue]];
			HolyBook *book = (HolyBook *)[[HolyContentManager sharedManager].books firstOrDefault:@"identity == %ld", (long)bookState.identity];
			HolyFile *bookFile = (HolyFile *)[book.files firstOrDefault:@"type == %ld", (long)bookState.fileType];
			
			[self handleCompletionWithBook:book bookFile:bookFile bookState:bookState];
		}
		else
		{
			NSArray *bookList = [HolyContentManager sharedManager].books;
			
			for (HolyBook *book in bookList)
			{
				BookState *bookState = [BookState getByID:book.identity];
				if (bookState.downloadInfo != nil)
				{
					bookState.isDownloaded = NO;
					bookState.downloadInfo = nil;
					[bookState save];
					
					//Post message
					DownloadCompletedMessage *message = [[[DownloadCompletedMessage alloc] init] autorelease];
					message.bookID = bookState.identity;
					[[NSNotificationCenter defaultCenter] postNotification:[message notificationForObject:self]];
				}
			}
		}
		
	} progress:^(int64_t bytesReceived, int64_t bytesTotal, NSString *bookIdentifier) {
		
		NSLog(@"Rejoined session progress");
		
		BookState *bookState = [BookState getByID:[bookIdentifier integerValue]];
		
		[self handleProgressWithBytesReceived:bytesReceived bytesTotal:bytesTotal bookState:bookState];
	}];
}

- (void)downloadBook: (HolyBook *)book bookFile: (HolyFile *)bookFile
{
	BookState *bookState = [BookState getByID:book.identity];
	NSString *downloadFilePath = [HolyContentManager epubURLWithFileName:bookFile.name];
	NSString *bookIdentifier = [NSString stringWithFormat:@"%ld", (long)book.identity];
	NSString *localFilePath = [HolyContentManager downloadFilePathForBook:bookIdentifier];
	
	//Change state
	bookState.isDownloaded = NO;
	bookState.downloadInfo = [[[DownloadInfo alloc] init] autorelease];
	bookState.fileType = bookFile.type;
	[bookState save];
	
	//Load
	[[IWSBackgroundDownloader sharedDownloader] downloadFile:downloadFilePath toPath:localFilePath
										  downloadIdentifier:bookIdentifier
												  completion:^(NSString *bookIdentifier) {
													  
													  [self handleCompletionWithBook:book bookFile:bookFile bookState:bookState];
													  
												  } progress:^(int64_t bytesReceived, int64_t bytesTotal, NSString *bookIdentifier) {
													  
													  [self handleProgressWithBytesReceived:bytesReceived bytesTotal:bytesTotal bookState:bookState];
												  }];
}

- (void)handleProgressWithBytesReceived: (int64_t)bytesReceived bytesTotal: (int64_t)bytesTotal bookState: (BookState *)bookState
{
	//Update download info
	if (bookState.downloadInfo == nil)
	{
		bookState.downloadInfo = [[[DownloadInfo alloc] init] autorelease];
	}
	bookState.downloadInfo.bytesReceived = bytesReceived;
	bookState.downloadInfo.bytesTotal = bytesTotal;
	[bookState save];
	
	//Post message
	DownloadProgressMessage *message = [[[DownloadProgressMessage alloc] init] autorelease];
	message.bookID = bookState.identity;
	[[NSNotificationCenter defaultCenter] postNotification:[message notificationForObject:self]];
}

- (void)handleCompletionWithBook: (HolyBook *)book bookFile: (HolyFile *)bookFile bookState: (BookState *)bookState
{
	//Set downloaded status
	bookState.isDownloaded = YES;
	bookState.downloadInfo = nil;
	//bookState.isUnpacking = YES;
	[bookState save];
	
	//Save to database
	[self saveBookToDatabase:book file:bookFile];
	
	//Post message
	DownloadCompletedMessage *message = [[[DownloadCompletedMessage alloc] init] autorelease];
	message.bookID = bookState.identity;
	[[NSNotificationCenter defaultCenter] postNotification:[message notificationForObject:self]];
}

- (void)saveBookToDatabase: (HolyBook *)book file: (HolyFile *)file
{
	//Book
	if (![HolyBook existsWithID:book.identity])
		[book insert];
	
	//File (only 1 file per book available)
	if ([HolyFile existsWithBookID:book.identity])
		[HolyFile removeAllWithBookID:book.identity];
	[file insertWithBookID:book.identity];
	
	//Author
	if (![HolyAuthor existsWithID:book.authorID])
	{
		HolyAuthor *author = (HolyAuthor *)[[HolyContentManager sharedManager].authors firstOrDefault:@"identity == %ld", book.authorID];
		[author insert];
	}
	
	//Language
	if (![HolyLanguage existsWithID:book.languageID])
	{
		HolyLanguage *language = (HolyLanguage *)[[HolyContentManager sharedManager].languages firstOrDefault:@"identity == %ld", book.languageID];
		[language insert];
	}
}

@end
