//
//  MFWeatherAPIClient.m
//  myForecast
//
//  Created by Angelica Bato on 6/14/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import "WeatherAPIClient.h"

@implementation WeatherAPIClient

+ (void)getWeatherInfoForCurrentLocationForLatitude:(NSString *)latitude longitude:(NSString *)longitude withCompletion:(void (^)(NSDictionary *dict, BOOL hasValidData))completionBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@,%@",darkSkyForecastURL,DarkSkyForecastAPIKey,latitude,longitude];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionBlock(responseObject, YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDict = @{@"Error":error};
        completionBlock(errorDict, NO);
    }];
    
    
}

@end
