//
//  ViewController.h
//  myForecast
//
//  Created by Angelica Bato on 6/14/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherViewController : UIViewController <CLLocationManagerDelegate>

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;




@end

