//
//  MFWeatherAPIClient.h
//  myForecast
//
//  Created by Angelica Bato on 6/14/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Constants.h"
#import "Secrets.h"

@interface WeatherAPIClient : NSObject

+ (void)getWeatherInfoForCurrentLocationForLatitude:(NSString *)latitude longitude:(NSString *)longitude withCompletion:(void (^)(NSDictionary *dict,BOOL hasValidData))completionBlock;

@end
