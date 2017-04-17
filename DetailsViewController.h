//
//  DetailsViewController.h
//  YoutubeTest
//
//  Created by test on 4/17/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) NSString *imageStr;
@property (strong, nonatomic) NSString *descrptionStr, *videoIdString;
@property (assign, nonatomic) int decideFunctionality;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLb;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)playButton:(id)sender;

@end
