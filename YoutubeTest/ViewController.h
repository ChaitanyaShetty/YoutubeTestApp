//
//  ViewController.h
//  YoutubeTest
//
//  Created by test on 4/17/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *resultsArray, *imageArray;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

