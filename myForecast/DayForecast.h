//
//  Forecast.h
//  myForecast
//
//  Created by Angelica Bato on 6/14/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayForecast : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *tempMax;
@property (strong, nonatomic) NSString *tempMin;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *icon;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
