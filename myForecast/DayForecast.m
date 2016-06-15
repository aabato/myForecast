//
//  Forecast.m
//  myForecast
//
//  Created by Angelica Bato on 6/14/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import "DayForecast.h"

@implementation DayForecast

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSUInteger tempTime = [dictionary[@"time"] integerValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:tempTime];
        _date = [dateFormatter stringFromDate:tempDate];
        _day = @""; //Change this later.
        
        _tempMax = [NSString stringWithFormat:@"%@", dictionary[@"temperatureMax"]];
        _tempMin = [NSString stringWithFormat:@"%@", dictionary[@"temperatureMin"]];
        _summary = [NSString stringWithFormat:@"%@", dictionary[@"summary"]];
        _icon = [NSString stringWithFormat:@"%@", dictionary[@"icon"]];
    }
    
    return self;
}

@end
