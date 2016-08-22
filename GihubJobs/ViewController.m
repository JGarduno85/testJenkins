//
//  ViewController.m
//  GihubJobs
//
//  Created by jose humberto Partida Garduño on 8/4/16.
//  Copyright © 2016 jose humberto Partida Garduño. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:
                  @"https://jobs.github.com/positions.json?description=ios&location=NY"];
    NSURLSessionDataTask *jobTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data,NSURLResponse *response, NSError *error) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (error) {
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hola" message:@"mundo" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                                    [alert show];
                                                                       return;
                                            }
                                                                       
                                            NSError *jsonError = nil;
                                        self.jobsArray = [NSJSONSerialization JSONObjectWithData: data options: 0 error: &jsonError];
                                        [self.tableView reloadData];
                                                                       
                                    });
        
        [SVProgressHUD showSuccessWithStatus: [NSString stringWithFormat: @"%lu jobs fetched",
                                               (unsigned long)[self.jobsArray count]]];
    }];
    
    [SVProgressHUD showWithStatus:@"Fetching jobs.."];
    
    [jobTask resume];
                                                 
                                                
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jobsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.jobsArray[indexPath.row][@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *jobUrl = [NSURL URLWithString: self.jobsArray[indexPath.row][@"url"]];
    [[UIApplication sharedApplication] openURL: jobUrl];
}

@end
