//
//  SecondViewController.h
//  RealTimeRanking
//
//  Created by Kishan B on 22/05/16.
//  Copyright © 2016 rtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property FIRDatabaseReference* usersRef;
@property NSMutableArray* users;
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;

@end

