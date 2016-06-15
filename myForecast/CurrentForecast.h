//
//  CurrentForecast.h
//  myForecast
//
//  Created by Angelica Bato on 6/15/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentForecast : NSObject

@property (strong, nonatomic) NSString *tempMin;
@property (strong, nonatomic) NSString *tempMax;
@property (strong, nonatomic) NSString *apparentTemp;
@property (assign, nonatomic) CGFloat humidity;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *currentTemp;
@property (assign, nonatomic) CGFloat precipProbability;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
