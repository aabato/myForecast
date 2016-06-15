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
        
        _tempMax = [dictionary[@"temperatureMax"] stringValue];
        _tempMin = [dictionary[@"temperatureMin"] stringValue];
        _summary = [dictionary[@"summary"] stringValue];
        _icon = [dictionary[@"icon"] stringValue];
    }
    
    return self;
}

@end
