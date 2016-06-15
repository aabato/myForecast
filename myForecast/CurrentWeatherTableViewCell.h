//
//  CurrentWeatherTableViewCell.h
//  myForecast
//
//  Created by Angelica Bato on 6/15/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentWeatherTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *summaryLabel;
@property (strong, nonatomic) IBOutlet UILabel *highLowTempLabel;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIconImage;


@end
