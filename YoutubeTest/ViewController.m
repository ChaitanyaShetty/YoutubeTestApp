//
//  ViewController.m
//  YoutubeTest
//
//  Created by test on 4/17/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import "ViewController.h"
#import "ModalClass.h"
#import "TableViewCell.h"
#import "DetailsViewController.h"
#import "Reachability.h"

@interface ViewController ()
{
    Reachability *reachability;
    int decideFunctionality;
    NSMutableArray *array;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultsArray = [[NSMutableArray alloc] init];
    self.imageArray = [[NSMutableArray alloc] init];
    array = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHoteStatus = [reachability currentReachabilityStatus];
    if (remoteHoteStatus == NotReachable) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network not found" message:@"Please connect to the internet" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        

        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"values"];
        NSDictionary *jsonDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self parseData:jsonDict];
        decideFunctionality = 0;
        
        
    } else {
    
    [self getSession:@"https://www.googleapis.com/youtube/v3/search?part=id,snippet&maxResults=20&channelId=UCCq1xDJMBRF61kiOgU90_kw&key=AIzaSyBRLPDbLkFnmUv13B-Hq9rmf0y7q8HOaVs"];
        decideFunctionality = 1;
        
    }
    [self.myTableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)handleNetworkChange: (NSNotification *)notice{
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error in Loading..." message:@"Network not found" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


-(void)parseData :(NSDictionary *)jsonAPI{
    
    id items = [jsonAPI valueForKey:@"items"];
    
    if (items != nil) {
        
        if ([items isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dict in items) {
                ModalClass *modal = [[ModalClass alloc] initWithDict:dict];
                [self.resultsArray addObject:modal];
            }
        } else if ([items isKindOfClass:[NSDictionary class]]) {
           
            ModalClass *modal = [[ModalClass alloc] initWithDict:items];
            [self.resultsArray addObject:modal];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
    }
    
}

-(void)getSession :(NSString *)jsonUrl{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:jsonUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"jsonData:%@", json);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if (json) {
                
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:json];
                [defaults setObject:data forKey:@"values"];
                
            }
            
            [self parseData:json];
            
       
            for (int i = 0; i< self.resultsArray.count; i++) {
                ModalClass *class = [self.resultsArray objectAtIndex:i];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:class.imageString]];
                [self.imageArray addObject:data];
                [defaults setObject:self.imageArray forKey:@"images"];
                
            }
            [defaults synchronize];
        }
        
        else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error in loading" message:@"Data not found" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
    
    [dataTask resume];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ModalClass *modal = [self.resultsArray objectAtIndex:indexPath.row];
    cell.titleLb.text = modal.titleString;
    cell.descriptionLb.text = modal.descriptionString;
    cell.timeLb.text = modal.timeString;
    if (decideFunctionality == 0) {
        
        array = [[NSUserDefaults standardUserDefaults] objectForKey:@"images"];
        cell.myimageView.image = [UIImage imageWithData:[array objectAtIndex:indexPath.row]];
        
    } else if (decideFunctionality == 1) {
       
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:modal.imageString] options:0 error:nil];
        cell.myimageView.image = [UIImage imageWithData:data];

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"send" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"send"]) {
        
        NSIndexPath *path = [self.myTableView indexPathForSelectedRow];
        DetailsViewController *vc = [segue destinationViewController];
        ModalClass *modal = [self.resultsArray objectAtIndex:path.row];
        vc.descrptionStr = modal.descriptionString;
        vc.videoIdString = modal.videoId;
        
        if (decideFunctionality == 0) {
            
            vc.imageData = [array objectAtIndex:path.row];
            vc.decideFunctionality = 0;
            
        } else if (decideFunctionality == 1) {
            
            vc.imageStr = modal.imageString;
            vc.decideFunctionality = 1;

            
        }
        
    }
}

@end
