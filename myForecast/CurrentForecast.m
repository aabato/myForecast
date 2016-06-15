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
        _tempMin = @"";
        _tempMax = @"";
        _apparentTemp = dictionary[@"apparentTemperature"];
        _humidity = [dictionary[@"humidity"] doubleValue];
        _icon = dictionary[@"icon"];
        _summary = dictionary[@"summary"];
        _currentTemp = dictionary[@"temperature"];
        _precipProbability = [dictionary[@"precipProbability"] doubleValue];
    }
    
    return self;
}

@end
