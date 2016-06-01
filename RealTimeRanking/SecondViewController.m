//
//  SecondViewController.m
//  RealTimeRanking
//
//  Created by Kishan B on 22/05/16.
//  Copyright © 2016 rtr. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usersRef = [[[FIRDatabase database] reference] child:@"unreal-users"];
    _users = [[NSMutableArray alloc] init];
    
    [[_usersRef queryOrderedByPriority]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshotLst) {
         _users = [[NSMutableArray alloc] init];
         for (FIRDataSnapshot *snapshot in snapshotLst.children) {
             [_users addObject:snapshot.value];
         }
         [_usersTableView reloadData];
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addUser:(UIBarButtonItem *)sender {
    UIAlertController* postInput = [UIAlertController alertControllerWithTitle:@"User Name"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
    [postInput addTextFieldWithConfigurationHandler:nil];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSDictionary *userObj = @{
                                                                                        @"name": postInput.textFields[0].text,
                                                                                        @"likes": @0
                                                                                        };
                                                              [[_usersRef childByAutoId] setValue:userObj andPriority:@0];
                                                          }];
    [postInput addAction:defaultAction];
    [self presentViewController:postInput animated:YES completion:nil];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.users count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.usersTableView dequeueReusableCellWithIdentifier:@"usersCell"];
    NSDictionary *userData = self.users[indexPath.row];
    cell.textLabel.text = [userData objectForKey: @"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ likes", [userData objectForKey:@"likes"]];
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
