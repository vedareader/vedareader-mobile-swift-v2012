//
//  FixedViewController.h
//  CoreTest
//
//  Created by SkyTree on 11. 10. 19..
//  Copyright (c) 2011 Skytree Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

#define SpreadAuto          0
#define SpreadLandscape     1
#define SpreadPortrait      2
#define SpreadBoth          4
#define SpreadNone          8

@class FixedViewController, Book, Parallel,WebFrame,SearchResult;
@class Highlight;
@protocol ContentProvider;

/**
 FixedPageInfomation class contains information about a specific page of fixed layout epub.
 */
@interface FixedPageInformation :NSObject{
    /** bookCode */
    NSInteger bookCode;
    /** the page index */
    NSInteger pageIndex;
    /** the number of pages for this book */
    NSInteger numberOfPages;
    /** pagePosition as double (0.0f is the start point and 1.0f is the end point of book) */
    double pagePosition;
    /** the cached file path for this page. */
    NSString *cachedImagePath;
}

@property NSInteger bookCode;
@property NSInteger pageIndex;
@property NSInteger numberOfPages;
@property double pagePosition;
@property (nonatomic,retain) NSString* cachedImagePath;

@end

@protocol FixedViewControllerDataSource <NSObject>
@optional
/** Javascript source for pageIndex can be passed to the engine if you like to implement some custom behaviors.  */
-(NSString*)fixedViewController:(FixedViewController*)fvc scriptForPage:(NSInteger)pageIndex;
/** CSS source for pageIndex can be passed to the engine if you like to implement some custom behaviors.  */
-(NSString*)fixedViewController:(FixedViewController*)fvc styleForPage:(NSInteger)pageIndex;
/** if cache file exists for pageIndex, you have to return YES or return NO */
-(BOOL)fixedViewController:(FixedViewController*)fvc cacheExists:(int)pageIndex;

/** should return NSMutableArray holding highlight objects for the given chapter index. */
-(NSMutableArray*)fixedViewController:(FixedViewController*)fvc highlightsForChapter:(NSInteger)chapterIndex;
/** called when new highlight object must be inserted. */
-(void)fixedViewController:(FixedViewController*)rvc insertHighlight:(Highlight*)highlight;
/** called when certain highlight should be deleted in the case like merging highlights. */
-(void)fixedViewController:(FixedViewController*)rvc deleteHighlight:(Highlight*)highlight;
/** called when certain highlight should be updated in the case like changing color */
-(void)fixedViewController:(FixedViewController*)rvc updateHighlight:(Highlight*)highlight;


@end

@class ImageIndexed;

/** the FixedViewControllerDelegate object */
@protocol FixedViewControllerDelegate <NSObject>
@optional
/** called when single tap is detected @param position CGPoint object at tap position */
-(void)fixedViewController:(FixedViewController*)fvc didDetectTapAtPositionInView:(CGPoint)positionInView positionInPage:(CGPoint)positionInPage;
/** called when double tap is detected @param position CGPoint object at double tap position */
-(void)fixedViewController:(FixedViewController*)fvc didDetectDoubleTapAtPositionInView:(CGPoint)positionInView positionInPage:(CGPoint)positionInPage;
/** called when page is moved to or chapter is loaded at first time. @param pageInformation PageInformation object of current page. */
-(void)fixedViewController:(FixedViewController*)fvc pageMoved:(FixedPageInformation*)fixedPageInformation;

/** called when caching process for pages is started. @param index int the start index where caching process is started */
-(void)fixedViewController:(FixedViewController*)fvc cachingStarted:(int)index;
/** called when caching process for pages is finished @param index int the start index where caching process is finished **/
-(void)fixedViewController:(FixedViewController*)fvc cachingFinished:(int)index;
/** called when caching for one page is over. @param index the page index which is cached now. @param path the path of cached file. */
-(void)fixedViewController:(FixedViewController*)fvc cached:(int)index image:(UIImage*)image;

-(void)fixedViewController:(FixedViewController*)fvc cached:(int)index path:(NSString*)path;

/** called when playing one parallel started */
-(void)fixedViewController:(FixedViewController*)fvc parallelDidStart:(Parallel*)parallel;
/** called when playing one parallel finished */
-(void)fixedViewController:(FixedViewController*)fvc parallelDidEnd:(Parallel*)parallel;
/** called when playing all parallels finished */
-(void)parallesDidEnd:(FixedViewController*)fvc;

/** called when the key is found. @param searchResult SearchResult object. */
-(void)fixedViewController:(FixedViewController*)fvc didSearchKey:(SearchResult*)searchResult;
/** called when search process for one chapter is finished @param searchResult SearchResult object. */
-(void)fixedViewController:(FixedViewController*)fvc didFinishSearchForChapter:(SearchResult*)searchResult;
/** called when all search process is finihsed @param searchResult SearchResult object. */
-(void)fixedViewController:(FixedViewController*)fvc didFinishSearchAll:(SearchResult*)searchResult;

/** called when user tries to go to the previous page at the first of book or to go to the next page at the last of book. */
-(void)fixedViewController:(FixedViewController*)fvc failedToMove:(BOOL)toForward;



/** called when text selection is finished. @param highlight Highlight object @param startRect CGRect for  the first line range of selection area.  @param endRect CGRect for the last line range of selection area */
-(void)fixedViewController:(FixedViewController*)rvc didSelectRange:(Highlight*)highlight menuRect:(CGRect)menuRect;

/** called when highlight is hit by tap gesture. @param highlight Highlight object hit by tap gesture. @param position CGPoint at tap position */
-(void)fixedViewController:(FixedViewController*)rvc didHitHighlight:(Highlight*)highlight atPosition:(CGPoint)position;



@end

/** the FixedViewController Object */
@interface FixedViewController : UIViewController {
    /** the page transition type. 0:none, 1:slide, 2:curl */
    int transitionType;
    /** the unique code for this book. */
    int bookCode;
    /** the Book object which contains information about epub. */
    Book* book;
    /** FixedViewControllerDelegate to handle events from FixedViewController. */
    __weak id <FixedViewControllerDelegate>   delegate;
    /** FixedViewControllerDataSource to respond to the request from FixedViewController. */
    __weak id <FixedViewControllerDataSource> dataSource;
    /** current engine version. */
    __weak NSString* version;
    /** the base directory for custom content files of epub */
    __weak NSString* baseDirectory;
    /** the class for custom reader for epub. */
    id contentProviderClass;
    /** contentProvider */
    id<ContentProvider> contentProvider;
}

@property (nonatomic,weak) NSString *encryptKey;
@property int transitionType;
@property int bookCode;
@property (nonatomic,retain) Book* book;
@property (nonatomic,weak) id <FixedViewControllerDelegate>      delegate;
@property (nonatomic,weak) id <FixedViewControllerDataSource>    dataSource;
@property (nonatomic,weak) NSString* version;
@property (nonatomic,weak) NSString* baseDirectory;

/** intenal test only, do not use */
-(void)debug0;
-(void)debug1;
-(void)debug2;
-(void)debug3;


/** init with Start pageIndex
 @param startPageIndex is integer value to indicate the index of start page.
 */
-(id)initWithStartPageIndex:(int)startPageIndex;
/** init with Start pageIndex
 @param startPageIndex  the integer value to indicate the index of start page.
 @param spread  rendition spread in opf (eg. SpreadNone, SpreadAuto, SpreadPortrait, SpreadLandscape, SpreadeBoth)
 */
-(id)initWithStartPageIndex:(int)pageIndex spread:(int)spreadType;
/** init with Start position
 @param start   the double value to indicate the position of start page. (eg. 0.0f~1.0f)
 @param spread  rendition spread in opf (eg. SpreadNone, SpreadAuto, SpreadPortrait, SpreadLandscape, SpreadeBoth)
 */
-(id)initWithStartPosition:(double)startPosition spread:(int)spreadType;


/** gets FixedPageInformation at the global position in book. @param pagePositionInBook is a double between 0 to 1 to indicate the position in entile book. */
-(FixedPageInformation*)getFixedPageInformationAtPagePosition:(double)pagePosition;
/** gets FixedPageInformation at the given page index. @param pageIndex the page index */
-(FixedPageInformation*)getFixedPageInformationAtPageIndex:(int)pageIndex;
/** returns PageInformation at current page. */
-(FixedPageInformation*)getFixedPageInformation;
/**  goes to the page by the position(by pagePositionInChapter) in this book */
-(void)gotoPageByPagePosition:(double)pagePosition;
/** change the background color for each page */
-(void)changeBackgroundColor:(UIColor*)backgroundColor;
/** change the window color */
-(void)changeWindowColor:(UIColor*)windowColor;
/**  goes to the page by NavPoint index */
-(void)gotoPageByNavMapIndex:(int)index;
/** delete all cached files in device */
-(void)clearCached;
/** set ContentProvider class */
-(void)setContentProviderClass:(Class)contentProvider;
/** set ContentProvider */
-(void)setContentProvider:(id<ContentProvider>)customProvider;
/** tells device can be rotate or not while caching process is going on. */
-(BOOL)canRotate;


/** goto the page of pageIndex in this chapter */
-(void)gotoPage:(int)pageIndex;
/** goto the next page in this chapter */
-(void)gotoNextPage;
/** goto the prev page in this chapter */
-(void)gotoPrevPage;
/** get page count of this book */
-(int)pageCountInBook;
/** get the current pageIndex in this chapter */
-(int)currentPageIndex;

/** change the color of element which has hash */
-(void)changeElementColor:(NSString*)colorString hash:(NSString*)hash pageIndex:(int)pageIndex;
/** restore the color of element lastly changed */
-(void)restoreElementColor;

/** returns MediaOverlay available */
-(BOOL)isMediaOverlayAvailable;
/** play the first Parallel in this page */
-(void)playFirstParallel;
/** pause playing parallel */
-(void)pausePlayingParallel;
/** stop playing parallel */
-(void)stopPlayingParallel;
/** play the parallel */
-(void)playParallel:(Parallel*)parallel;
/** play the parallel at parallelIndx */
-(void)playParallelByIndex:(int)parallelIndex;
/** get the parallel at parallelIndx */
-(Parallel*)getParallelByIndex:(int)parallelIndex;
/** get the count of parallels in this chapter */
-(int)parallelCount;
/** play the next parallel */
-(void)playNextParallel;
/** play the prev parallel */
-(void)playPrevParallel;
/** resume playing the paused parallel */
-(void)resumePlayingParallel;
/** tells whether playing is paused or not. */
-(BOOL)isPlayingPaused;
/** tells whether medaiOverlay started or not. */
-(BOOL)isPlayingStarted;

/** set license key */
-(void)setLicenseKey:(NSString *)licenseKey;

/** set the delay time for rendering */
-(void)setTimeForRendering:(double)seconds;
-(void)setTimeForCaching:(double)seconds;

-(void)deleteAllCaches;

/** release all resources explicitly */
-(void)destroy;

/** for landscape mode, set the image which should be located between two pages */
-(void)setPagesCenterImage:(UIImage*)pagesCenterImage;
/** set the image which is used for resembling the stack of pages on both side of book. */
-(void)setPagesStackImage:(UIImage*)pagesStackImage;

/** enable/disable navigation area on both sides */
-(void)setNavigationAreaEnabled:(BOOL)enabled;

/** get the cover image url */
-(NSString*)getCoverURL;

/** start caching process */
-(void)startCaching;
/** stop caching process */
-(void)stopCaching;

/** execute Javascript for left page (when forLeft = YES) or for right page (forLeft = NO). in single page mode (portrait), forLeft should be YES. */
-(NSString*)executeJavascript:(NSString*)script forLeftPage:(BOOL)forLeft;
/**  execute Javascript only for left Page. use this in portrait mode. */
-(NSString*)executeJavascript:(NSString*)script;

/** use only one layer to render. caching adjacent pages will be disabled. */
-(void)useSingleLayer;

/** To avoid conflict with Drag/Drop behavior, enable/disable Swipe Gesture to move Page. default YES, only for Slide/None transition mode */
-(void)setSwipeGestureEnabled:(BOOL)enabled;

/** returns the device ram size */
-(int)platformMemory;
/** returns the model name of device */
-(NSString *)platformString;

-(void)addMenuItemForSelection:(NSObject*)target title:(NSString*)title selector:(SEL)selector;

/**  set current Selection to Highlight; */
-(void)makeSelectionHighlight:(UIColor*)color;
/**  makes current Selection to Highlight its style note. */
-(void)makeSelectionNote:(UIColor*)color;
/**  clear current Highlight at mouse position; */
-(void)deleteHighlight:(Highlight*)highlight;
/** change the color of the highlight */
-(void)changeHighlight:(Highlight*)highlight color:(UIColor*)color;
/** change the text for note */
-(void)changeHighlight:(Highlight *)highlight note:(NSString *)note;
/** change the color and note of text. */
-(void)changeHighlight:(Highlight *)highlight color:(UIColor*)color note:(NSString *)note;

/**  searches epub for the key. */
-(void)searchKey:(NSString*)key;
/**  searches the key more */
-(void)searchMore;
/**  pauses searching */
-(void)pauseSearch;
/**  stops searching */
-(void)stopSearch;


/** return YES when spread is both or auto in landscape mode.  */
-(BOOL)isDoublePaged;

/** return NavPoint at naveIndex */
-(NavPoint*)getNavPoint:(int)navIndex;

/** goto Page by NavPoint */
-(void)gotoPageByNavPoint:(NavPoint*)np;

/** if value is true, page will be fit to Height. otherwise page will be fit to Width */
-(void)setFitToHeight:(BOOL)value;

/** set MaxLayer to pre load another pages */
-(void)setMaxLayer:(int)max;





@end
