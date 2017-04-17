//
//  TableViewCell.h
//  YoutubeTest
//
//  Created by test on 4/17/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *myimageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLb;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLb;
@property (strong, nonatomic) IBOutlet UILabel *timeLb;

@end
