//
//  NSDateAdditions.m
//  Created by Devin Ross on 7/28/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */
#import "NSDate+Additions.h"


@implementation NSDate (Additions)

+ (NSDate*) yesterday{
	TKDateInformation inf = [[NSDate date] dateInformation];
	inf.day--;
	return [NSDate dateFromDateInformation:inf];
}
+ (NSDate*) month{
    return [[NSDate date] monthDate];
}

- (NSDate*) monthDate {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
	[comp setDay:1];
	NSDate *date = [gregorian dateFromComponents:comp];
    return date;
}


- (int) weekday{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:self];
	int weekday = [comps weekday];
	return weekday;
}
- (NSDate*) timelessDate {
	NSDate *day = self;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:day];
	return [gregorian dateFromComponents:comp];
}
- (NSDate*) monthlessDate {
	NSDate *day = self;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:day];
	return [gregorian dateFromComponents:comp];
}



- (BOOL) isSameDay:(NSDate*)anotherDate{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	NSDateComponents* components2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:anotherDate];
	return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
} 

- (int) monthsBetweenDate:(NSDate *)toDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit
                                                fromDate:[self monthlessDate]
                                                  toDate:[toDate monthlessDate]
                                                 options:0];
    NSInteger months = [components month];
    return abs(months);
}

- (NSInteger) daysBetweenDate:(NSDate*)date {
    NSTimeInterval time = [self timeIntervalSinceDate:date];
    return ((abs(time) / (60.0 * 60.0 * 24.0)) + 0.5);
}

- (BOOL) isToday{
	return [self isSameDay:[NSDate date]];
} 



- (NSDate *) dateByAddingDays:(NSUInteger)days {
	NSDateComponents *c = [[NSDateComponents alloc] init];
	c.day = days;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}
+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	NSString *datePortion = [dateFormatter stringFromDate:aDate];
	
	[dateFormatter setDateFormat:@"HH:mm"];
	NSString *timePortion = [dateFormatter stringFromDate:aTime];
	
	[dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
	NSString *dateTime = [NSString stringWithFormat:@"%@ %@",datePortion,timePortion];
	return [dateFormatter dateFromString:dateTime];
}



- (NSString*) monthString{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];	
	[dateFormatter setDateFormat:@"MMMM"];
	return [dateFormatter stringFromDate:self];
}
- (NSString*) yearString{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];	
	[dateFormatter setDateFormat:@"yyyy"];
	return [dateFormatter stringFromDate:self];
}



- (TKDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz{
	
	
	TKDateInformation info;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setTimeZone:tz];
	NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
													NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
										  fromDate:self];
	info.day = [comp day];
	info.month = [comp month];
	info.year = [comp year];
	
	info.hour = [comp hour];
	info.minute = [comp minute];
	info.second = [comp second];
	
	info.weekday = [comp weekday];
	
	
	return info;
	
}
- (TKDateInformation) dateInformation{
	
	TKDateInformation info;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
													NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
										  fromDate:self];
	info.day = [comp day];
	info.month = [comp month];
	info.year = [comp year];
	
	info.hour = [comp hour];
	info.minute = [comp minute];
	info.second = [comp second];
	
	info.weekday = [comp weekday];
	
    
	return info;
}

+ (NSDate *)dateFromDateInformation:(TKDateInformation)info timeZone:(NSTimeZone*)tz{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setTimeZone:tz];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
	[comp setTimeZone:tz];
	
	return [gregorian dateFromComponents:comp];
}
+ (NSDate*)dateFromDateInformation:(TKDateInformation)info{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
	//[comp setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	return [gregorian dateFromComponents:comp];
}

+ (NSString *)dateInformationDescriptionWithInformation:(TKDateInformation)info{
	return [NSString stringWithFormat:@"%d %d %d %d:%d:%d",info.month,info.day,info.year,info.hour,info.minute,info.second];
}

+ (NSString *)getDurationFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate] + 1;
    NSInteger hours = interval / 3600;
    NSInteger mins = (interval - hours * 3600) / 60;
    NSString *hoursStr = @"hours";
    NSString *minsStr = @"minutes";
    if (hours == 1) {
        hoursStr = @"hour";
    }
    if (mins == 1) {
        minsStr = @"minute";
    }
    NSString *finalStr = [NSString stringWithFormat:@"%d %@ %d %@", hours, hoursStr, mins, minsStr];
    if (hours == 0 && mins != 0) {
        finalStr = [NSString stringWithFormat:@"%d %@", mins, minsStr];
    } else if (hours != 0 && mins == 0) {
        finalStr = [NSString stringWithFormat:@"%d %@", hours, hoursStr];
    } else if (hours == 0 && mins == 0) {
        finalStr = [NSString stringWithFormat:@"%d %@", hours, hoursStr];
    }
    return finalStr;
}

// My functions
- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *ret = [formatter stringFromDate:self];
    [formatter release];
    return ret;
}

- (NSString *)stringValue
{
    return [self stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSInteger)compare:(NSDate *)other
{
    return [[self stringWithFormat:@"yyyy-MM-dd"] compare:[other stringWithFormat:@"yyyy-MM-dd"]];
}

- (NSInteger)compareTime:(NSDate *)other
{
    NSString *format = @"yyyy-MM-dd HH:mm:ss";;
    return [[self stringWithFormat:format] compare:[other stringWithFormat:format]];
}

- (NSInteger)numOfDaysSinceDate:(NSDate *)date
{
    NSTimeInterval interval = [self timeIntervalSinceDate:date];
    return interval / 86400;
}

- (NSDate *)beginningOfDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                     fromDate:self];
    NSDate *beginOfToday = [cal dateFromComponents:comps];
    return beginOfToday;
}

- (NSDate *)endOfDay
{
    return [[self beginningOfDay] dateByAddingTimeInterval:24 * 3600 - 1];
}

- (NSDate *)beginningOfWeek
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[[NSDateComponents alloc] init] autorelease];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the original date (today).
     To normalize to midnight, extract the year, month, and day components and create a new date from those components.
     */
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                 fromDate: beginningOfWeek];
    beginningOfWeek = [gregorian dateFromComponents:components];
    return beginningOfWeek;
}

- (NSDate *)endOfWeek
{
    return [[[self beginningOfWeek] dateByAddingDays:7] dateByAddingTimeInterval:-1];
}

- (NSDate *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateStr = [formatter stringFromDate:self];
    NSDate *other = [formatter dateFromString:dateStr];
    [formatter release];
    return other;
}

- (NSDate *)dateByAddingMonths:(NSInteger)numOfMonths
{    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = numOfMonths;
    
    NSDate *nextMonth = [gregorian dateByAddingComponents:components toDate:self options:0];
    [components release];
    
    NSDateComponents *otherComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:nextMonth];
    
    NSDateComponents *thisDayComponents = [gregorian components:NSDayCalendarUnit fromDate:self];
    
    otherComponents.day = thisDayComponents.day;
    NSDate *date = [gregorian dateFromComponents:otherComponents];
    
    [gregorian release];
    return date;
}

- (NSDate *)dateBySubtractingMonths:(NSInteger)numOfMonths
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-numOfMonths];
    NSDate *other = [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
    [offsetComponents release];
    return other;
}

- (NSDate *)beginningOfMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [comp setDay:1];
    return [gregorian dateFromComponents:comp];
}

- (NSDate *)endOfMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *beginningOfMonth = [self beginningOfMonth];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:beginningOfMonth];
    
    [comp setMonth:[comp month] + 1];
    
    return [[gregorian dateFromComponents:comp] dateByAddingTimeInterval:-1];
}

@end
