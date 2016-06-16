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

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;

@property (strong, nonatomic) CurrentForecast *currentForecast;
@property (strong, nonatomic) NSMutableArray *dayForecasts;

@end

@implementation WeatherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getLocation];
    
}

- (IBAction)refreshData:(id)sender {
    
    self.currentForecast = nil;
    [self.dayForecasts removeAllObjects];
    self.currentLocation = nil;
    self.latitude = @"";
    self.longitude = @"";
    self.city = @"";
    self.state = @"";
    
    NSLog(@"Refreshing");
    
    NSLog(@"%@, %@, %@, %@, %@, %@, %@", self.currentForecast, self.dayForecasts, self.currentLocation, self.latitude, self.longitude, self.city, self.state);
    
    [self getLocation];
    [self.refreshControl endRefreshing];
    
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
        return self.dayForecasts.count - 1;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        CurrentWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currentSummary" forIndexPath:indexPath];
        
        DayForecast *today = self.dayForecasts[0];
        
        cell.currentTempLabel.text = [NSString stringWithFormat:@"%@\u00B0 F", self.currentForecast.currentTemp];
        cell.summaryLabel.text = self.currentForecast.summary;
        cell.highLowTempLabel.text = [NSString stringWithFormat:@"%@\u00B0 F/%@\u00B0 F",today.tempMin,today.tempMax];
        cell.weatherIconImage.image = [UIImage imageNamed:self.currentForecast.icon];
        
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        CurrentDetailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currentDetail" forIndexPath:indexPath];
        
        cell.feelsLikeTempLabel.text = [NSString stringWithFormat:@"Feels like: %@\u00B0 F", self.currentForecast.apparentTemp];
        cell.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %.0f %%", self.currentForecast.humidity];
        cell.chanceOfPrecipLabel.text = [NSString stringWithFormat:@"Chance of Precipitation: %.0f %%", self.currentForecast.precipProbability];

        return cell;
        
    }
    else if (indexPath.section == 1) {
        DailyWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dayForecast" forIndexPath:indexPath];
        
        DayForecast *day = self.dayForecasts[indexPath.row + 1];
        
        cell.MMDDLabel.text = day.date;
        cell.highLowTempLabel.text = [NSString stringWithFormat:@"%@\u00B0F/%@\u00B0F",day.tempMin,day.tempMax];
        cell.summaryLabel.text = day.summary;
        cell.weatherIconImage.image = [UIImage imageNamed:day.icon];
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 300.0;
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        return 200.0;
    }
    
    return 100;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [NSString stringWithFormat: @"Current Weather in %@, %@", self.city, self.state];
    }
    if (section == 1) {
        return @"7 Day Forecast";
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

# pragma mark - Data Retrieval

- (void)getLocation {
    
    NSLog(@"GET LOCATION CALLED");
    
    if ([CLLocationManager locationServicesEnabled]) {
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oh no!" message:@"We couldn't get your current location. Please try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"Location found");
    self.currentLocation = [locations lastObject];
    
    self.latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    
    NSLog(@"LAT: %@, LON: %@", self.latitude, self.longitude);
    
    [self.locationManager stopUpdatingLocation];
    
    [WeatherAPIClient getWeatherInfoForCurrentLocationForLatitude:self.latitude longitude:self.longitude withCompletion:^(NSDictionary *dict, BOOL hasValidData) {
        if (hasValidData){
            
            NSLog(@"Hitting API");
            self.currentForecast = [[CurrentForecast alloc] initWithDictionary:dict[@"currently"]];
            self.dayForecasts = [NSMutableArray new];
            NSArray *temp = dict[@"daily"][@"data"];
            for (NSDictionary *dictionary in temp) {
                DayForecast *day = [[DayForecast alloc] initWithDictionary:dictionary];
                [self.dayForecasts addObject:day];
            }
        }
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            NSUInteger count = placemarks.count;
            
            for (CLPlacemark *placemark in placemarks) {
                self.city = [placemark locality];
                self.state = [placemark administrativeArea];
                NSLog(@"%@, %@", self.city, self.state);
                count--;
            }
            if (count == 0) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSLog(@"Updating tableview");
                    [self.tableView reloadData];
                }];
            }
        }];
    }];
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
            [self.locationManager requestWhenInUseAuthorization];
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"This app won't work without being authorized to use Location Services." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *openSettings = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }];
            [alert addAction:openSettings];
            [self presentViewController:alert animated:YES completion:nil];
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
