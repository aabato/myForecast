//
//  ViewController.m
//  myForecast
//
//  Created by Angelica Bato on 6/14/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherAPIClient.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:spinner];
    
    spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [spinner.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [spinner.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [spinner.widthAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    
    [spinner startAnimating];
    
    [self getLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadWeather {
    [self getWeatherWithCompletionBlock:^(NSDictionary *currently, NSDictionary *day) {
        NSLog(@"Currently: %@",currently);
        NSLog(@"Temp:%@", currently[@"apparentTemperature"]);
        NSLog(@"Summary:%@", currently[@"summary"]);
        NSLog(@"Day: %@",day);
        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.currentTempLabel.text = [NSString stringWithFormat:@"%@",self.currently[@"apparentTemperature"]];
//            self.currentSummaryLabel.text = [NSString stringWithFormat:@"%@",self.currently[@"summary"]];
//        }];
        
    }];
}

# pragma mark - Data Retrieval

- (void)getLocation {
    
    NSLog(@"1");
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"2");
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
}

-(void)getWeatherWithCompletionBlock:(void(^)(NSDictionary *currently, NSDictionary *day))completionBlock {
    
    [WeatherAPIClient getWeatherInfoForCurrentLocationForLatitude:self.latitude longitude:self.longitude withCompletion:^(NSDictionary *dict, BOOL hasValidData) {
//        completionBlock(dict[@"currently"],dict[@"daily"][@"data"][0]);
        if (hasValidData){
            NSLog(@"-------Original Dictionary from API: %@",dict);
        }
    }];
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //    [self.locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.currentLocation = [locations lastObject];
    
    self.latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSUInteger count = placemarks.count;
        
        for (CLPlacemark *placemark in placemarks) {
            self.city = [placemark locality];
            self.state = [placemark administrativeArea];
            NSLog(@"%@,%@",self.latitude, self.longitude);
            count--;
        }
        if (count == 0) {
            NSLog(@"Loc info done!");
            [self loadWeather];
        }
    }];
    
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.locationManager startUpdatingLocation];
        } break;
        default:
            break;
    }
}



@end
