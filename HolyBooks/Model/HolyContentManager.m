//
//  GuideInfoList.m
//  HolyBooks
//
//  Created by Class Generator by Roman Leshukov on 12/22/2014.
//  Copyright (c) 2014 Iron Water Studio. All rights reserved.
//

#import "HolyContentManager.h"
#import "AppHelper.h"
#import "NSArray+LINQ.h"
#import "HolyClasses.h"
#import "ZipArchive.h"
#import "HolySet.h"

@implementation HolyContentManager

+ (HolyContentManager *)sharedManager
{
	static HolyContentManager *manager = nil;
	if (manager == nil)
		manager = [[HolyContentManager alloc] init];
	
	return manager;
}

- (id)init
{
	if (self = [super init])
	{
		if (![[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager contentDirectory]])
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:[HolyContentManager contentDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
			[AppHelper setDoNotBackupAttr:[HolyContentManager contentDirectory]];
		}
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager bookImagesDirectory]])
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:[HolyContentManager bookImagesDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
			[AppHelper setDoNotBackupAttr:[HolyContentManager bookImagesDirectory]];
		}
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager bannersDirectory]])
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:[HolyContentManager bannersDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
			[AppHelper setDoNotBackupAttr:[HolyContentManager bannersDirectory]];
		}
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager booksDirectory]])
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:[HolyContentManager booksDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
			[AppHelper setDoNotBackupAttr:[HolyContentManager booksDirectory]];
		}
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager downloadsDirectory]])
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:[HolyContentManager downloadsDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
			[AppHelper setDoNotBackupAttr:[HolyContentManager downloadsDirectory]];
		}
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager authorImagesDirectory]])
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:[HolyContentManager authorImagesDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
			[AppHelper setDoNotBackupAttr:[HolyContentManager authorImagesDirectory]];
		}
		
		self.booksForAuthorId = [NSMutableDictionary dictionary];
	}
	
	return self;
}

- (void)dealloc
{
	[_books release];
	[_booksForAuthorId release];
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Languages: %@, Banners: %@, Recommendations: %@, Authors: %@, Books: %@, Sets: %@",
			_languages, _banners, _recommendations, _authors, _books, _sets];
}

#pragma mark - Content Load Public
- (void)loadFromCache
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager contentFilePath]])
		[self loadAllWithData:[NSData dataWithContentsOfFile:[HolyContentManager contentFilePath]]];
	else
	{
		NSString *pathInBundle = [[NSBundle mainBundle] pathForResource:kContentFileName ofType:nil];
		if (pathInBundle != nil)
			[self loadAllWithData:[NSData dataWithContentsOfFile:pathInBundle]];
	}
}

- (void)updateWithSuccess: (void (^)())successBlock
					error: (void (^)())errorBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString *pathToFile =[kContentHost stringByAppendingString:kContentFileName];
		NSLog(@"Path to file: %@", pathToFile);
		NSData *fileData = [self downloadFile:[kContentHost stringByAppendingString:kContentFileName]];
		if([fileData length] > 0)
		{
			//Load content
			[self loadAllWithData:fileData];
			
			//Book images
			//Get image names
//			NSMutableArray *imageNames = [NSMutableArray arrayWithArray:[self.books select:@"image"]];
//
//			//We should download only not existing images
//			NSMutableArray *toRemove = [NSMutableArray array];
//			for (NSString *imageName in imageNames)
//				if ([[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager bookImagePathWithURL:imageName]])
//					[toRemove addObject:imageName];
//			[imageNames removeObjectsInArray:toRemove];
//			
//			//Download images
//			for (NSString *imageName in imageNames)
//			{
//				NSString *imageURL = [[kContentHost stringByAppendingPathComponent:kBookImagesSubdirectory] stringByAppendingPathComponent:imageName];
//				[[self downloadFile:imageURL] writeToFile:[HolyContentManager bookImagePathWithURL:imageName] atomically:NO];
//			}
			
			//Banners
			//Get image names
			NSMutableArray *imageNames = [NSMutableArray arrayWithArray:[self.banners select:@"imageEn"]];
			[imageNames addObjectsFromArray:[self.banners select:@"imageRu"]];
			
			//We should download only not existing images
			NSMutableArray *toRemove = [NSMutableArray array];
			for (NSString *imageName in imageNames)
				if ([[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager bannerPathWithURL:imageName]])
					[toRemove addObject:imageName];
			[imageNames removeObjectsInArray:toRemove];
			
			//Download images
			for (NSString *imageName in imageNames)
			{
				NSString *imageURL = [[kContentHost stringByAppendingPathComponent:kBannersSubdirectory] stringByAppendingPathComponent:imageName];
				[[self downloadFile:imageURL] writeToFile:[HolyContentManager bannerPathWithURL:imageName] atomically:NO];
			}
			
			//Save guide list file
			[fileData writeToFile:[HolyContentManager contentFilePath] atomically:NO];
			NSLog(@"Path: %@", [HolyContentManager contentFilePath]);
			
			dispatch_async(dispatch_get_main_queue(), ^{
				successBlock();
			});
		}
		else
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				errorBlock();
			});
		}
	});
}

#pragma mark - Content Load Private
//Synchronous method. For small files only.
- (NSData *)downloadFile: (NSString *)fileName
{
	NSURL *url = [NSURL URLWithString: fileName];
	NSData *data = [NSData dataWithContentsOfURL: url];
	return data;
}

- (void)loadAllWithData:(NSData *)data
{	
	NSError *error = nil;
	NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (error != nil)
		NSLog(@"Error: %@", error.localizedDescription);
	
	self.languages = [HolyLanguage getFromDataArray:jsonDictionary[@"languages"]];
	self.banners = [HolyBanner getFromDataArray:jsonDictionary[@"banners"]];
	self.recommendations = [HolyRecommendation getFromDataArray:jsonDictionary[@"recommendations"]];
	self.authors = [HolyAuthor getFromDataArray:jsonDictionary[@"authors"]];
	self.books = [HolyBook getFromDataArray:jsonDictionary[@"books"]];
	self.sets = [HolySet getFromDataArray:jsonDictionary[@"sets"]];
	
	//Fill booksForAuthorId dictionary (Need for authors screen)
	/*for (NSInteger i = 0; i < self.authors.count; i++)
	{
		HolyAuthor *curAuthor = self.authors[i];
		NSArray *temp = [self.books where:@"authorID == %ld", (long)curAuthor.identity];
		NSInteger booksCount = temp.count;
		[self.booksForAuthorId setObject:@(booksCount) forKey:@(curAuthor.identity)];
	}*/
	for (HolyAuthor *author in self.authors)
	{
		NSArray *temp = [self.books where:@"authorID == %ld", (long)author.identity];
		NSInteger booksCount = temp.count;
		[self.booksForAuthorId setObject:@(booksCount) forKey:@(author.identity)];
	}
	
	//NSLog(@"booksForAuthorId: %@", self.booksForAuthorId);
	
	//NSLog(@"Parsed data: %@", self);
}

#pragma mark - Content Pathes Private
+ (NSString *)contentDirectory
{
	return [[AppHelper applicationDocumentsDirectory] stringByAppendingPathComponent:kContentSubdirectory];
}

+ (NSString *)bookImagesDirectory
{
	return [[HolyContentManager contentDirectory] stringByAppendingPathComponent:kBookImagesSubdirectory];
}

+ (NSString *)bannersDirectory
{
	return [[HolyContentManager contentDirectory] stringByAppendingPathComponent:kBannersSubdirectory];
}

+ (NSString *)contentFilePath
{
	return [[HolyContentManager contentDirectory] stringByAppendingPathComponent:kContentFileName];
}

+ (NSString *)authorImagesDirectory
{
	return [[HolyContentManager contentDirectory] stringByAppendingPathComponent:kAuthorsImagesSubdirectory];
}

#pragma mark - Content Pathes Public
+ (NSString *)bookImageURLWithImageName: (NSString *)imageName
{
	return [[kContentHost stringByAppendingPathComponent:kBookImagesSubdirectory] stringByAppendingPathComponent:imageName];
}

+ (NSString *)bookImagePathWithURL: (NSString *)url
{
	NSString *imageName = [url lastPathComponent];
	return [[HolyContentManager bookImagesDirectory] stringByAppendingPathComponent:imageName];
}

+ (NSString *)bannerPathWithURL: (NSString *)url
{
	NSString *imageName = [url lastPathComponent];
	return [[HolyContentManager bannersDirectory] stringByAppendingPathComponent:imageName];
}

+ (NSString *)authorImageURLWithImageName:(NSString *)imageName
{
	return [[kContentHost stringByAppendingPathComponent:kAuthorsImagesSubdirectory] stringByAppendingPathComponent:imageName];
}

+ (NSString *)authorImagePathWithURL:(NSString *)url
{
	NSString *imageName = [url lastPathComponent];
	return [[HolyContentManager authorImagesDirectory] stringByAppendingPathComponent:imageName];
}

+ (NSString *)setImageURLWithImageName:(NSString *)imageName
{
	return [[kContentHost stringByAppendingPathComponent:kSetsImagesSubdirectory] stringByAppendingPathComponent:imageName];
}

#pragma mark - Working with books
+ (NSString *)epubURLWithFileName: (NSString *)fileName
{
	return [[kContentHost stringByAppendingPathComponent:kBooksSubdirectory] stringByAppendingPathComponent:fileName];
}

+ (NSString *)booksDirectory
{
	return [[AppHelper applicationDocumentsDirectory] stringByAppendingPathComponent: kBooksSubdirectory];
}

+ (NSString *)downloadsDirectory
{
	return [[AppHelper applicationDocumentsDirectory] stringByAppendingPathComponent: kDownloadsSubdirectory];
}

+ (NSString *)downloadFilePathForBook: (NSString *)bookName
{
	return [[HolyContentManager downloadsDirectory] stringByAppendingPathComponent:[bookName stringByAppendingPathExtension:@"epub"]];
}

+ (NSString *)booksFilePathForBook: (NSString *)bookName
{
	return [[HolyContentManager booksDirectory] stringByAppendingPathComponent:[bookName stringByAppendingPathExtension:@"epub"]];
}

+ (NSString *)bookDirectoryForBook: (NSString *)bookName
{
	return [[HolyContentManager booksDirectory] stringByAppendingPathComponent:bookName];
}

+ (NSInteger)booksAmountForAuthorId:(NSInteger)authorId
{
	return [HolyBook booksQuantityWithAuthorID:authorId];
}

/*+ (void)unpackBookNamed: (NSString *)bookName completion: (void (^)())completion
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		ZipArchive *zipArchive = [[ZipArchive alloc] init];
		NSString *downloadFilePath = [HolyContentManager downloadFilePathForBook:bookName];
		if ([zipArchive UnzipOpenFile:downloadFilePath])
		{
			BOOL unarchived = [zipArchive UnzipFileTo:[HolyContentManager bookDirectoryForBook:bookName] overWrite:YES];
			if (unarchived)
			{
				NSLog(@"Unarchived successfully");
				dispatch_async(dispatch_get_main_queue(), ^{
					completion();
				});
				
				//Delete archive
				NSError *error = nil;
				//[[NSFileManager defaultManager] removeItemAtPath:downloadFilePath error:&error];
				if (error)
					NSLog(@"Error deleting file %@, error description: %@", downloadFilePath, error.localizedDescription);
			}
			else
			{
				NSLog(@"Error unarchiving %@ from path %@ to path %@", bookName, [HolyContentManager downloadFilePathForBook:bookName], [HolyContentManager bookDirectoryForBook:bookName]);
			}
			[zipArchive UnzipCloseFile];
		}
		[zipArchive release];
	});
}*/

/*+ (void)prepareBook: (NSString *)bookName
{
	//Test only: copy from bundle to downloads
	NSError *error = nil;
	NSString *resourcesPath = [[NSBundle mainBundle] pathForResource:[bookName stringByAppendingPathExtension:@"epub"] ofType:nil];
	[[NSFileManager defaultManager] copyItemAtPath:resourcesPath toPath:[HolyContentManager downloadFilePathForBook:bookName] error:&error];
	if (error != nil)
	{
		NSLog(@"Error copy file %@, error description: %@", resourcesPath, error.localizedDescription);
		return;
	}
	
	//And to books What for? Fuckened chinese
	[[NSFileManager defaultManager] copyItemAtPath:resourcesPath toPath:[HolyContentManager booksFilePathForBook:bookName] error:&error];
	if (error != nil)
	{
		NSLog(@"Error copy file %@ to %@, error description: %@", resourcesPath, [HolyContentManager booksFilePathForBook:bookName], error.localizedDescription);
		return;
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:[HolyContentManager bookDirectoryForBook:bookName]])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:[HolyContentManager bookDirectoryForBook:bookName] withIntermediateDirectories:YES attributes:nil error:nil];
		[AppHelper setDoNotBackupAttr:[HolyContentManager bookDirectoryForBook:bookName]];
	}
}*/

@end
