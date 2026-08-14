//
//  NSDate+TimeZone.m
//  NSDate
//
//  Created by Roman Developer on 9/5/12.
//  Copyright (c) 2012 Iron Water Studio. All rights reserved.
//

#import "NSDate+TimeZone.h"

@implementation NSDate (TimeZone)

#pragma mark - Convertation date <-> minutes (for settings)
+ (NSDate *)convertMinutesToDate:(NSInteger)minutes
{
	NSInteger hour = minutes / 60;
	NSInteger minute = minutes % 60;
	return [self dateWithHour:hour minute:minute];
}

+ (NSInteger)convertDateToMinutes:(NSDate *)date
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
	return dateComponents.minute + dateComponents.hour * 60;
}

+ (NSDate *)localDateFromUTC: (long)utcTime
{
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
	{
		//+4 GMT MSK daylight bug fix - need to add 1 hour
		NSInteger timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
		NSInteger timeZoneOffsetFixed = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate dateWithTimeIntervalSince1970:0]];
		NSInteger fix = timeZoneOffset - timeZoneOffsetFixed;
		
		return [NSDate dateWithTimeIntervalSince1970:utcTime - fix];
	}
	else
		return [NSDate dateWithTimeIntervalSince1970:utcTime];
}

+ (NSDate *)localDateFromShortDateString: (NSString *)dateStr
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kShortDateFormat];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter release];
    return date;
}

- (long)utcDate
{
	NSInteger unixTime = [self timeIntervalSince1970];
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
	{
		//+4 GMT MSK daylight bug fix - need to add 1 hour
		NSInteger timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:self];
		NSInteger timeZoneOffsetFixed = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate dateWithTimeIntervalSince1970:0]];
		NSInteger fix = timeZoneOffset - timeZoneOffsetFixed;
		
		return unixTime + fix;
	}
	else
		return unixTime;
}

+ (NSDate *)utcDateWithTimeIntervalSince1970:(long)utcTime
{
	NSInteger timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
	{
		//+4 GMT MSK daylight bug fix - need to add 1 hour
		timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate dateWithTimeIntervalSince1970:0]];
	}
	return [NSDate dateWithTimeIntervalSince1970:utcTime - timeZoneOffset];
}

#pragma mark -
- (NSDate *)dateWithoutTime
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dateComponents = [calendar components: NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    NSDate *dateWithoutTime = [calendar dateFromComponents:dateComponents];
    
    return dateWithoutTime;
}

- (NSDate *)timeWithoutDay
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dateComponents = [calendar components: NSMinuteCalendarUnit | NSHourCalendarUnit fromDate:self];
	dateComponents.year = 1970;
	dateComponents.month = 1;
	dateComponents.day = 1;
	dateComponents.second = 0;
    NSDate *timeWithoutDay = [calendar dateFromComponents:dateComponents];
	return timeWithoutDay;
}

+ (NSDate *)today
{
    return [[NSDate date] dateWithoutTime];
}

+ (NSDate *)dateWithHour:(NSInteger)hour minute:(NSInteger)minute
{
	return [self dateWithHour:hour minute:minute second:0];
}

//Helper method; used due to problem with 1hour difference for some standard time methods (MSK time zone +4 or +3)
+ (NSDate *)dateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	dateComponents.calendar = calendar;
	dateComponents.hour = hour;
	dateComponents.minute = minute;
	dateComponents.second = second;
	dateComponents.year = 1970;
	dateComponents.month = 1;
	dateComponents.day = 1;
	NSDate *timeWithoutDay = [calendar dateFromComponents:dateComponents];
	[dateComponents release];
	return timeWithoutDay;
}

#pragma mark - Diff
- (long)daysAgoSinceDate: (NSDate *)pastDate
{
	return [self hoursAgoSinceDate:pastDate] / 24;
}

- (long)hoursAgoSinceDate: (NSDate *)pastDate
{
	return [self minutesAgoSinceDate:pastDate] / 60;
}

- (long)minutesAgoSinceDate: (NSDate *)pastDate
{
	long seconds = [self timeIntervalSince1970] - [pastDate timeIntervalSince1970];
	
	return seconds / 60;
}

- (long)daysAgoSinceCurrentDate
{
	return [[NSDate date] daysAgoSinceDate:self];
}

- (long)hoursAgoSinceCurrentDate
{
	return [[NSDate date] hoursAgoSinceDate:self];
}

- (long)minutesAgoSinceCurrentDate
{
	return [[NSDate date] minutesAgoSinceDate:self];
}

#pragma mark - Change
- (NSDate *)addSecond: (NSInteger)seconds
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setSecond:seconds];
	NSDate *date = [gregorian dateByAddingComponents:comps toDate:self  options:0];
	[comps release];
	[gregorian release];
	
	return date;
}

- (NSDate *)addMinute: (NSInteger)minutes
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMinute:minutes];
	NSDate *date = [gregorian dateByAddingComponents:comps toDate:self  options:0];
	[comps release];
	[gregorian release];
	
	return date;
}

- (NSDate *)addHour: (NSInteger)hours
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setHour:hours];
	NSDate *date = [gregorian dateByAddingComponents:comps toDate:self  options:0];
	[comps release];
	[gregorian release];
	
	return date;
}

- (NSDate *)addDay: (NSInteger)days
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init]; 
	[comps setDay:days];
	NSDate *date = [gregorian dateByAddingComponents:comps toDate:self  options:0];
	[comps release];
	[gregorian release];
	
	return date;
}

- (NSDate *)addMonth: (NSInteger)months
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:months];
	NSDate *date = [gregorian dateByAddingComponents:comps toDate:self  options:0];
	[comps release];
	[gregorian release];
	
	return date;
}

- (NSDate *)addYear: (NSInteger)years
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:years];
	NSDate *date = [gregorian dateByAddingComponents:comps toDate:self  options:0];
	[comps release];
	[gregorian release];
	
	return date;
}

#pragma mark - Equality
- (BOOL)isEqualToDay:(NSDate *)otherDate
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//	[gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	int comps = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
	NSDateComponents *dateComponents = [gregorian components:comps fromDate:self];
	NSDateComponents *otherDateComponents = [gregorian components:comps fromDate:otherDate];
	[gregorian release];
	
	return dateComponents.day == otherDateComponents.day
		&& dateComponents.month == otherDateComponents.month
		&& dateComponents.year == otherDateComponents.year;
}

- (BOOL)isToday
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *todayComponents = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:[NSDate date]];
	NSDateComponents *selfComponents = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:self];
	
	if (selfComponents.year == todayComponents.year && selfComponents.month == todayComponents.month && selfComponents.day == todayComponents.day)
		return YES;
	else
		return NO;
}

- (BOOL)isYesterday
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *yesterdayComponents = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit ) fromDate:[NSDate date]];
	[yesterdayComponents setHour:-24];
	
	NSDateComponents *selfComponents = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:self];
	
	if (selfComponents.year == yesterdayComponents.year && selfComponents.month == yesterdayComponents.month && selfComponents.day == yesterdayComponents.day)
		return YES;
	else
		return NO;
}

#pragma mark - ToString
- (NSString *)fullDateString
{
	return [self stringWithFormat:kFullDateFormat];
}

- (NSString *)shortDateString
{
	return [self stringWithFormat:kShortDateFormat];
}

- (NSString *)shortDateShortYearString;
{
	return [self stringWithFormat:kShortDateFormatShortYear];
}

- (NSString *)fullTimeString
{
	return [self stringWithFormat:kFullTimeFormat];
}

- (NSString *)shortTimeString //used
{
	return [self stringWithFormat:kShortTimeFormat];
}

- (NSString *)stringWithFormat: (NSString *)formatString //used
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatString];
	NSString *dateStr = [dateFormatter stringFromDate:self];
	[dateFormatter release];
	return dateStr;
}

- (NSString *)stringWithDateStyle: (NSDateFormatterStyle)formatStyle
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:formatStyle];
	NSString *dateStr = [dateFormatter stringFromDate:self];
	[dateFormatter release];
	return dateStr;
}

#pragma mark - Helper
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

+ (NSString *)timeIntervalToString:(long)timeInterval
{
	NSInteger seconds = timeInterval % 60;
	NSInteger minutes_total = timeInterval / 60;
	NSInteger minutes = minutes_total % 60;
	NSInteger hours_total = minutes_total / 60;
	NSInteger hours = hours_total % 24;
	NSInteger days = hours_total / 24;

	if (days > 0)
		return [NSString stringWithFormat:@"%ld.%02ld:%02ld:%02ld", (long)days, (long)hours, (long)minutes, (long)seconds];
	else
		return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

@end
