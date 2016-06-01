//
//  FirstViewController.h
//  RealTimeRanking
//
//  Created by Kishan B on 22/05/16.
//  Copyright © 2016 rtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface FirstViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property FIRDatabaseReference* postsRef;
@property NSMutableArray* posts;
@property FIRDatabaseReference* usersRef;
@property NSMutableArray* users;
@end

