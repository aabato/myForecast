//
//  CurrentDetailedTableViewCell.h
//  myForecast
//
//  Created by Angelica Bato on 6/15/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentDetailedTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *feelsLikeTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *chanceOfPrecipLabel;

@end
