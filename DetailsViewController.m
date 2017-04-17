//
//  DetailsViewController.m
//  YoutubeTest
//
//  Created by test on 4/17/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_decideFunctionality == 0) {
        
        self.imageView.image = [UIImage imageWithData:self.imageData];
        
    } else if (_decideFunctionality == 1) {
        
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageStr]];
    self.imageView.image = [UIImage imageWithData:data];
    NSLog(@"video:%@", self.videoIdString);
    
}
    
    self.descriptionLb.text = self.descrptionStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)playButton:(id)sender {
    
    NSString *str = [NSString stringWithFormat:@"youtube://%@", self.videoIdString];
    NSString *safari = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", self.videoIdString];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:safari]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:safari] options:@{} completionHandler:nil];
    }
    
    
}
@end
