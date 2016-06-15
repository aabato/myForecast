//
//  WeatherTableViewController.m
//  myForecast
//
//  Created by Angelica Bato on 6/15/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import "WeatherTableViewController.h"
#import "WeatherAPIClient.h"
#import "CurrentWeatherTableViewCell.h"
#import "CurrentDetailedTableViewCell.h"
#import "DailyWeatherTableViewCell.h"
#import "DayForecast.h"
#import "CurrentForecast.h"

@interface WeatherTableViewController ()

@property (strong, nonatomic) CurrentForecast *current;
@property (strong, nonatomic) NSMutableArray *dayForecasts;

@end

@implementation WeatherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [self.view addSubview:spinner];
//    
//    spinner.translatesAutoresizingMaskIntoConstraints = NO;
//    [spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
//    [spinner.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
//    [spinner.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
//    [spinner.widthAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
//    
//    [spinner startAnimating];
    
    [self getLocation];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return self.dayForecasts.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        CurrentWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currentSummary" forIndexPath:indexPath];
        DayForecast *today = self.dayForecasts[0];
        
        cell.currentTempLabel.text = self.current.currentTemp;
        cell.summaryLabel.text = self.current.summary;
        cell.highLowTempLabel.text = [NSString stringWithFormat:@"%@%@F/%@%@F",today.tempMin,@"\u00B0",today.tempMax,@"\u00B0"];
        cell.weatherIconImage.image = [UIImage imageNamed:self.current.icon];
        
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        CurrentDetailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currentDetail" forIndexPath:indexPath];
        
        cell.feelsLikeTempLabel.text = self.current.apparentTemp;
        cell.humidityLabel.text = [NSString stringWithFormat:@"%f %%", self.current.humidity];
        cell.chanceOfPrecipLabel.text = [NSString stringWithFormat:@"%f %%", self.current.precipProbability];

        return cell;
        
    }
    else if (indexPath.section == 1) {
        DailyWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dayForecast" forIndexPath:indexPath];
        
        DayForecast *day = self.dayForecasts[indexPath.row];
        
        cell.MMDDLabel.text = day.date;
        cell.highLowTempLabel.text = [NSString stringWithFormat:@"%@%@F/%@%@F",day.tempMin,@"\u00B0",day.tempMax,@"\u00B0"];
        cell.summaryLabel.text = day.summary;
        cell.weatherIconImage.image = [UIImage imageNamed:day.icon];
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 350.0;
    }
    
    return 100;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"7 DAY FORECAST";
    }
    
    return nil;
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


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.currentLocation = [locations lastObject];
    
    self.latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    
    [self.locationManager stopUpdatingLocation];
    
    [WeatherAPIClient getWeatherInfoForCurrentLocationForLatitude:self.latitude longitude:self.longitude withCompletion:^(NSDictionary *dict, BOOL hasValidData) {
        if (hasValidData){
            NSLog(@"%@", dict);
            
            self.current = [[CurrentForecast alloc] initWithDictionary:dict[@"currently"]];
            self.dayForecasts = [NSMutableArray new];
            NSArray *temp = dict[@"daily"][@"data"];
            for (NSDictionary *dictionary in temp) {
                DayForecast *day = [[DayForecast alloc] initWithDictionary:dictionary];
                [self.dayForecasts addObject:day];
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
            
        }

    }];
    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        NSUInteger count = placemarks.count;
//        
//        for (CLPlacemark *placemark in placemarks) {
//            self.city = [placemark locality];
//            self.state = [placemark administrativeArea];
//            NSLog(@"%@,%@",self.latitude, self.longitude);
//            count--;
//        }
//        if (count == 0) {
//            NSLog(@"Loc info done!");
//            [self loadWeather];
//        }
//    }];
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
