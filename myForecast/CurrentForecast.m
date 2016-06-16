//
//  CurrentForecast.m
//  myForecast
//
//  Created by Angelica Bato on 6/15/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import "CurrentForecast.h"

@implementation CurrentForecast

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _apparentTemp = [NSString stringWithFormat:@"%.0f", [dictionary[@"apparentTemperature"] doubleValue]];
        _humidity = [dictionary[@"humidity"] doubleValue] * 100;
        _icon = [NSString stringWithFormat:@"%@", dictionary[@"icon"]];
        _summary = [NSString stringWithFormat:@"%@", dictionary[@"summary"]];
        _currentTemp = [NSString stringWithFormat:@"%.0f", [dictionary[@"temperature"] doubleValue]];
        _precipProbability = [dictionary[@"precipProbability"] doubleValue] * 100;
    }
    
    return self;
}

@end
