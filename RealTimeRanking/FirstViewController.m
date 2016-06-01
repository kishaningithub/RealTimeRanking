//
//  FirstViewController.m
//  RealTimeRanking
//
//  Created by Kishan B on 22/05/16.
//  Copyright © 2016 rtr. All rights reserved.
//

#import "FirstViewController.h"
#import "AddPostViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _postsRef = [[[FIRDatabase database] reference] child:@"posts"];
    _usersRef = [[[FIRDatabase database] reference] child:@"unreal-users"];
    _posts = [[NSMutableArray alloc] init];
    _users = [[NSMutableArray alloc] init];

    [[_postsRef queryOrderedByPriority]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshotLst) {
         _posts = [[NSMutableArray alloc] init];
         for(FIRDataSnapshot *snapshot in snapshotLst.children){
             NSDictionary* data = snapshot.value;
             [data setValue:[snapshot ref] forKey: @"firebaseRef"];
             [data setValue:[snapshot priority] forKey: @"priority"];
             [_posts addObject:data];
         }
         [_postsTableView reloadData];
     }];
    
    [_usersRef
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshotLst) {
         _users = [[NSMutableArray alloc] init];
         for(FIRDataSnapshot *snapshot in snapshotLst.children){
             NSDictionary* data = snapshot.value;
             [data setValue:[snapshot ref] forKey: @"firebaseRef"];
             [_users addObject:data];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"addPostSegue"]){
        AddPostViewController *postController = segue.destinationViewController;
        postController.postsRef = _postsRef;
        postController.usersRef = _usersRef;
        postController.users = _users;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_posts count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_postsTableView dequeueReusableCellWithIdentifier:@"postCell"];
    NSDictionary *postData = _posts[indexPath.row];
    UILabel *postsLabel = [cell viewWithTag:1];
    UIButton *likeBtn = [cell viewWithTag:2];
    UILabel *likesLabel = [cell viewWithTag:3];
    UILabel *dateLabel = [cell viewWithTag:4];
    postsLabel.text = [postData objectForKey:@"post"];
    NSNumber *timeStamp = [postData objectForKey:@"timestamp"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [timeStamp doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    dateLabel.text = [dateFormatter stringFromDate:date];
    likesLabel.text = [NSString stringWithFormat: @"%@ likes", [postData objectForKey:@"likes"]];
    [likeBtn addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)likeButtonClicked:(UIButton*)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_postsTableView];
    NSIndexPath *clickedButtonIndexPath = [_postsTableView indexPathForRowAtPoint:touchPoint];
    NSDictionary *postData = _posts[clickedButtonIndexPath.row];
    FIRDatabaseReference *postRef = [postData objectForKey:@"firebaseRef"];
    
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"name = %@", [postData objectForKey:@"user"]];
    NSDictionary * user = [[_users filteredArrayUsingPredicate:userPredicate] objectAtIndex:0];
    FIRDatabaseReference *userRef = [user objectForKey:@"firebaseRef"];

    [postRef setValue: @{
                            @"post": [postData objectForKey:@"post"],
                            @"likes": [NSNumber numberWithInteger: [[postData objectForKey:@"likes"] integerValue] + 1 ],
                            @"user": [postData objectForKey:@"user"],
                            @"timestamp": [postData objectForKey:@"timestamp"]
                            }
          andPriority:  @([[postData objectForKey:@"priority"] integerValue])];

    NSDictionary *newUserObj = @{
                                 @"name": [user objectForKey:@"name"],
                                 @"likes": [NSNumber numberWithInteger: [[user objectForKey:@"likes"] integerValue] + 1 ]
                                 };
    [userRef setValue: newUserObj
          andPriority: @(- [[newUserObj objectForKey:@"likes"] integerValue])];
}

@end
