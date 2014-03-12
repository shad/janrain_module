/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2013, Janrain, Inc.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
 contributors may be used to endorse or promote products derived from this
 software without specific prior written permission.
 
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "LinkedProfilesViewController.h"

@interface LinkedProfilesViewController ()
@property(nonatomic, strong) UITableView *profileTable;
@end

@implementation LinkedProfilesViewController
@synthesize linkedProfiles;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.682 green:0.874 blue:0.960 alpha:1]];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.view.bounds.size.width, 45)];
    title.text = ([linkedProfiles count]) ? @"Select a profile to unlink" : @"No profiles found." ;
    title.font = [UIFont boldSystemFontOfSize:24];
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    [self.view addSubview:title];
    
    self.profileTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 75, self.view.bounds.size.width-40, self.view.bounds.size.height/1.5) style:UITableViewStylePlain];
    [self.profileTable setBackgroundColor:[UIColor clearColor]];
    [self.profileTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.profileTable setDataSource:self];
    [self.profileTable setDelegate:self];
    [self.view addSubview:self.profileTable];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-100, 100, 25);
    cancelButton.titleLabel.font = [UIFont fontWithName:@"verdana-bold" size:10];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:0.245 green:0.023 blue:0.945 alpha:1]];
    [cancelButton addTarget:self action:@selector(dismissModalViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    NSLog(@"viewDidLoad Count : %d", [linkedProfiles count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![linkedProfiles count]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma UITableViewDataSource methods
#pragma delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [linkedProfiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"verdana" size:12];
    cell.textLabel.text = ([[[linkedProfiles objectAtIndex:indexPath.row] valueForKey:@"verifiedEmail"] isKindOfClass:[NSNull class]]) ? @"No Name" :[[linkedProfiles objectAtIndex:indexPath.row] valueForKey:@"verifiedEmail"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"verdana" size:8];
    cell.detailTextLabel.text = [[linkedProfiles objectAtIndex:indexPath.row] valueForKey:@"identifier"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIButton *unlinkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    unlinkButton.frame = CGRectMake(0, 3, 55, 20);
    unlinkButton.titleLabel.font = [UIFont fontWithName:@"verdana-bold" size:8];
    [unlinkButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [unlinkButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [unlinkButton setTitle:@"Unlink" forState:UIControlStateNormal];
    [unlinkButton setBackgroundColor:[UIColor colorWithRed:0.945 green:0.023 blue:0.210 alpha:1]];
    [unlinkButton setTag:indexPath.row];
    [unlinkButton addTarget:self action:@selector(notifySelectedProfile:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = unlinkButton;
    return cell;
}

#pragma UITableViewDelegate methods
#pragma delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

#pragma helper method
-(void)notifySelectedProfile:(UIButton *)sender {
    NSLog(@"Selected : %@", [linkedProfiles objectAtIndex:sender.tag]);
    [delegate unlinkSelectedProfile:[[linkedProfiles objectAtIndex:sender.tag] valueForKey:@"identifier"]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
