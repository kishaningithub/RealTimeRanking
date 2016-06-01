//
//  AddPostViewController.h
//  RealTimeRanking
//
//  Created by Kishan B on 24/05/16.
//  Copyright © 2016 rtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface AddPostViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property FIRDatabaseReference* usersRef;
@property NSMutableArray *users;
@property FIRDatabaseReference* postsRef;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *usersPickerView;

@end
