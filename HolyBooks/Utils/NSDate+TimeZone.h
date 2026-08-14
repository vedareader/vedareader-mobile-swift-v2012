//
//  NSDate+TimeZone.h
//  NSDate
//
//  Created by Roman Developer on 9/5/12.
//  Copyright (c) 2012 Iron Water Studio. All rights reserved.
//	NOTE: IOS 7+ version: IOS 7+ adds timezone offset automatically

#import <Foundation/Foundation.h>

#define kFullDateFormat @"dd.MM.yyyy hh:mm:ss"
#define kShortDateFormat @"dd.MM.yyyy"
#define kShortDateFormat @"dd.MM.yyyy"
#define kShortDateFormatShortYear @"dd.MM.yy"
#define kFullTimeFormat @"hh:mm:ss"
#define kFullTimeFormat24 @"HH:mm:ss"
#define kShortTimeFormat @"hh:mm"
#define kShortTimeFormat24 @"HH:mm"

//TODO: Make it use localized versions of strings
@interface NSDate (TimeZone)

//Convertation date <-> minutes (for settings)
+ (NSDate *)convertMinutesToDate:(NSInteger)minutes;
+ (NSInteger)convertDateToMinutes:(NSDate *)date;

//Returns NSDate object in local timezone from UTC Unix time provided
+ (NSDate *)localDateFromUTC: (long)utcTime;
+ (NSDate *)localDateFromShortDateString: (NSString *)dateStr;

//Returns UTC Unix time from current NSDate in local timezone
- (long)utcDate;

//Date without addition of timezone offset to seconds
+ (NSDate *)utcDateWithTimeIntervalSince1970:(long)utcTime;

// Today date without time components
- (NSDate *)dateWithoutTime;
- (NSDate *)timeWithoutDay;
+ (NSDate *)today;

//Helper method; used due to problem with 1 hour difference for some standard time methods (MSK time zone +4 or +3)
+ (NSDate *)dateWithHour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)dateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

//Diff methods
- (long)daysAgoSinceDate: (NSDate *)pastDate;
- (long)hoursAgoSinceDate: (NSDate *)pastDate;
- (long)minutesAgoSinceDate: (NSDate *)pastDate;
- (long)daysAgoSinceCurrentDate;
- (long)hoursAgoSinceCurrentDate;
- (long)minutesAgoSinceCurrentDate;

//Equality methods
- (BOOL)isEqualToDay:(NSDate *)otherDate;
- (BOOL)isToday;
- (BOOL)isYesterday;

//Change methods
- (NSDate *)addSecond: (NSInteger)seconds;
- (NSDate *)addMinute: (NSInteger)minutes;
- (NSDate *)addHour: (NSInteger)hours;
- (NSDate *)addDay: (NSInteger)days;
- (NSDate *)addMonth: (NSInteger)months;
- (NSDate *)addYear: (NSInteger)years;

//ToString methods
- (NSString *)fullDateString;
- (NSString *)shortDateString;
- (NSString *)shortDateShortYearString;
- (NSString *)fullTimeString;
- (NSString *)shortTimeString;

//Private method, though could be used if needed
- (NSString *)stringWithFormat: (NSString *)formatString;
- (NSString *)stringWithDateStyle: (NSDateFormatterStyle)formatStyle;

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSString *)timeIntervalToString:(long)timeInterval;

@end
