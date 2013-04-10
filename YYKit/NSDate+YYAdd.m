//
//  NSDate+YYAdd.m
//  YYKit
//
//  Created by ibireme on 13-4-11.
//  Copyright (c) 2013年 ibireme. All rights reserved.
//

#import "NSDate+YYAdd.h"

#import "YYCoreMacro.h"

DUMMY_CLASS(NSDate_YYAdd)

@implementation NSDate (YYAdd)


- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self] second];
}

- (NSInteger)week {
    return [[[NSCalendar currentCalendar] components:NSWeekCalendarUnit fromDate:self] week];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSWeekdayOrdinalCalendarUnit fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSWeekOfMonthCalendarUnit fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit fromDate:self] weekOfYear];
}

@end
