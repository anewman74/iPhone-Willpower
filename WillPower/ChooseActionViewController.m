//
//  ChooseActionViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "ChooseActionViewController.h"
#import "WillPowerAppDelegate.h"
#import "NotesViewController.h"
#import "NewDataViewController.h"
#import "LogResultsViewController.h"
#import "GoalResultViewController.h"
#import "ReviewViewController.h"
#import "NewDepViewController.h"
#import "DailyRemindersViewController.h"

@implementation ChooseActionViewController

@synthesize notesViewController;
@synthesize theNewData;
@synthesize logResults;
@synthesize goalRes;
@synthesize reviewVC;
@synthesize theNewDep;
@synthesize dailyVC;

-(void)viewWillAppear:(BOOL)animated {
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    //NSLog(@"screen size for iphone: %2f", screensize);
    if ((int)screensize == 480) {
        
        iphone4Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,30,320,455)];
        iphone4Background.image = [UIImage imageNamed:@"iphone4Background.png"];
        [self.view addSubview:iphone4Background];
        [iphone4Background release];
        
        btnWhy = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnWhy setFrame:CGRectMake(19,6,282,48)];
        [btnWhy setImage:[UIImage imageNamed:@"button-the-why.png"] forState:UIControlStateNormal];
        [btnWhy addTarget:self action:@selector(notes) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnWhy];
        
        btnNewGoal = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNewGoal setFrame:CGRectMake(19,57,282,48)];
        [btnNewGoal setImage:[UIImage imageNamed:@"button-set-new-goal.png"] forState:UIControlStateNormal];
        [btnNewGoal addTarget:self action:@selector(toNewData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnNewGoal];
        
        btnLogResults = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLogResults setFrame:CGRectMake(19,108,282,48)];
        [btnLogResults setImage:[UIImage imageNamed:@"button-record-result.png"] forState:UIControlStateNormal];
        [btnLogResults addTarget:self action:@selector(toLogResults) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLogResults];
        
        btnGoalResults = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnGoalResults setFrame:CGRectMake(19,159,282,48)];
        [btnGoalResults setImage:[UIImage imageNamed:@"button-edit-or-delete-data.png"] forState:UIControlStateNormal];
        [btnGoalResults addTarget:self action:@selector(toGoalRes) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnGoalResults];
        
        btnReview = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnReview setFrame:CGRectMake(19,210,282,48)];
        [btnReview setImage:[UIImage imageNamed:@"button-monitor-performance.png"] forState:UIControlStateNormal];
        [btnReview addTarget:self action:@selector(toReview) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnReview];
        
        btnDailyReminders = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDailyReminders setFrame:CGRectMake(19,261,282,48)];
        [btnDailyReminders setImage:[UIImage imageNamed:@"button-daily-reminders.png"] forState:UIControlStateNormal];
        [btnDailyReminders addTarget:self action:@selector(toDailyReminders) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDailyReminders];
        
        btnNewDep = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNewDep setFrame:CGRectMake(19,312,282,48)];
        [btnNewDep setImage:[UIImage imageNamed:@"button-signs-of-willpower-depletion.png"] forState:UIControlStateNormal];
        [btnNewDep addTarget:self action:@selector(toNewDep) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnNewDep];
    }
    else{
        iphone5Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,320,455)];
        iphone5Background.image = [UIImage imageNamed:@"iphone5Background.png"];
        [self.view addSubview:iphone5Background];
        [iphone5Background release];
        
        btnWhy = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnWhy setFrame:CGRectMake(19,90,282,48)];
        [btnWhy setTitle:@"The WHY" forState:UIControlStateNormal];
        [btnWhy setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnWhy addTarget:self action:@selector(notes) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnWhy];
        
        btnNewGoal = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNewGoal setFrame:CGRectMake(19,145,282,48)];
        [btnNewGoal setTitle:@"Set New Goal" forState:UIControlStateNormal];
        [btnNewGoal setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnNewGoal addTarget:self action:@selector(toNewData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnNewGoal];
        
        btnLogResults = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLogResults setFrame:CGRectMake(19,200,282,48)];
        [btnLogResults setTitle:@"Record Result" forState:UIControlStateNormal];
        [btnLogResults setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnLogResults addTarget:self action:@selector(toLogResults) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLogResults];
        
        btnGoalResults = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnGoalResults setFrame:CGRectMake(19,255,282,48)];
        [btnGoalResults setTitle:@"Edit or Delete Result" forState:UIControlStateNormal];
        [btnGoalResults setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnGoalResults addTarget:self action:@selector(toGoalRes) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnGoalResults];
        
        btnReview = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnReview setFrame:CGRectMake(19,310,282,48)];
        [btnReview setTitle:@"Monitor Performance" forState:UIControlStateNormal];
        [btnReview setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnReview addTarget:self action:@selector(toReview) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnReview];
        
        btnDailyReminders = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDailyReminders setFrame:CGRectMake(19,365,282,48)];
        [btnDailyReminders setTitle:@"Daily Reminders" forState:UIControlStateNormal];
        [btnDailyReminders setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnDailyReminders addTarget:self action:@selector(toDailyReminders) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDailyReminders];
        
        btnNewDep = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNewDep setFrame:CGRectMake(19,420,282,48)];
        [btnNewDep setTitle:@"Signs of Willpower Depletion" forState:UIControlStateNormal];
        [btnNewDep setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnNewDep addTarget:self action:@selector(toNewDep) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnNewDep];
    }
}

#pragma mark - View Controller chosen
-(void) notes {	
	if (self.notesViewController == nil)
	{
		NotesViewController *aDetail = [[NotesViewController alloc] initWithNibName: @"NotesView" bundle:[NSBundle mainBundle]];
		self.notesViewController = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:notesViewController animated:YES];
}

-(void) toNewData {
	if (self.theNewData == nil)
	{
		NewDataViewController *aDetail = [[NewDataViewController alloc] initWithNibName: @"NewDataViewController" bundle:[NSBundle mainBundle]];
		self.theNewData = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:theNewData animated:YES];		
}

-(void) toLogResults {
	if (self.logResults == nil)
	{
		LogResultsViewController *aDetail = [[LogResultsViewController alloc] initWithNibName: @"LogResultsViewController" bundle:[NSBundle mainBundle]];
		self.logResults = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:logResults animated:YES];		
}

-(void) toGoalRes {	
	if (self.goalRes == nil)
	{
		GoalResultViewController *aDetail = [[GoalResultViewController alloc] initWithNibName: @"GoalResultViewController" bundle:[NSBundle mainBundle]];
		self.goalRes = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:goalRes animated:YES];		
}

-(void) toReview {	
	if (self.reviewVC == nil)
	{
		ReviewViewController *aDetail = [[ReviewViewController alloc] initWithNibName: @"ReviewViewController" bundle:[NSBundle mainBundle]];
		self.reviewVC = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:reviewVC animated:YES];		
}

-(void) toNewDep {	
	if (self.theNewDep == nil)
	{
		NewDepViewController *aDetail = [[NewDepViewController alloc] initWithNibName: @"NewDepViewController" bundle:[NSBundle mainBundle]];
		self.theNewDep = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:theNewDep animated:YES];		
}

-(void) toDailyReminders {	
	if (self.dailyVC == nil)
	{
		DailyRemindersViewController *aDetail = [[DailyRemindersViewController alloc] initWithNibName: @"DailyRemindersViewController" bundle:[NSBundle mainBundle]];
		self.dailyVC = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:dailyVC animated:YES];		
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title =  NSLocalizedString(@"Choose Action", @"choose action");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
    [notesViewController release];
    [theNewData release];
    [logResults release];
    [goalRes release];
    [reviewVC release];
    [theNewDep release];
    [dailyVC release];
}

@end
