//
//  MFWeatherAPIClient.m
//  myForecast
//
//  Created by Angelica Bato on 6/14/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import "MFWeatherAPIClient.h"

@implementation MFWeatherAPIClient

+ (void)getWeatherInfoForCurrentLocationForLatitude:(NSString *)latitude longitude:(NSString *)longitude withCompletion:(void (^)(NSDictionary *))completionBlock {
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@,%@",darkSkyForecastURL,DarkSkyForecastAPIKey,latitude,longitude];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //            NSLog(@"SUCCESS!");
        //            NSLog(@"%@",responseObject);
        completionBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"SOMETHING WENT WRONG");
        NSLog(@"%@",error);
    }];
    
    
}

@end
