//
//  AddPostViewController.m
//  RealTimeRanking
//
//  Created by Kishan B on 24/05/16.
//  Copyright © 2016 rtr. All rights reserved.
//

#import "AddPostViewController.h"

@interface AddPostViewController ()

@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_usersPickerView reloadAllComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)post:(UIButton *)sender {
    NSInteger selectedUserIndex = [_usersPickerView selectedRowInComponent:0];
    NSDictionary *user = _users[selectedUserIndex];
    NSDictionary *postsDict = @{
                                @"post": [_postTextView text],
                                @"likes": @0,
                                @"user": [user objectForKey:@"name"],
                                @"timestamp": [NSNumber numberWithDouble:[[[NSDate alloc] init] timeIntervalSince1970]]
                                };
    [[_postsRef childByAutoId]setValue:postsDict andPriority:@(-[[postsDict objectForKey:@"timestamp"] integerValue])];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_users count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary * user = _users[row];
    return [user objectForKey:@"name"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

@end
