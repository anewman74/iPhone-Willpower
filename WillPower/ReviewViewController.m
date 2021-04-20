//
//  ReviewViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "ReviewViewController.h"
#import "DailyViewController.h"
#import "WeeklyViewController.h"
#import "MonthlyViewController.h"
#import "WillPowerAppDelegate_iPhone.h"

@implementation ReviewViewController
@synthesize dailyVC;
@synthesize weeklyVC;
@synthesize monthlyVC;


-(void) viewWillAppear:(BOOL)animated {
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        
        iphone4Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,455)];
        iphone4Background.image = [UIImage imageNamed:@"iphone4Background.png"];
        [self.view addSubview:iphone4Background];
        [iphone4Background release];
        
        btnDaily = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDaily setFrame:CGRectMake(19,61,282,48)];
        [btnDaily setImage:[UIImage imageNamed:@"button-daily-performance.png"] forState:UIControlStateNormal];
        [btnDaily addTarget:self action:@selector(toDaily) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDaily];
        
        btnWeekly = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnWeekly setFrame:CGRectMake(19,159,282,48)];
        [btnWeekly setImage:[UIImage imageNamed:@"button-weekly-performance.png"] forState:UIControlStateNormal];
        [btnWeekly addTarget:self action:@selector(toWeekly) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnWeekly];
        
        btnMonthly = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMonthly setFrame:CGRectMake(19,262,282,48)];
        [btnMonthly setImage:[UIImage imageNamed:@"button-monthly-performance.png"] forState:UIControlStateNormal];
        [btnMonthly addTarget:self action:@selector(toMonthly) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnMonthly];
    }
    else {
        iphone5Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,320,455)];
        iphone5Background.image = [UIImage imageNamed:@"iphone5Background.png"];
        [self.view addSubview:iphone5Background];
        [iphone5Background release];
        
        btnDaily = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDaily setFrame:CGRectMake(19,140,282,48)];
        [btnDaily setTitle:@"Daily Performance" forState:UIControlStateNormal];
        [btnDaily setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnDaily addTarget:self action:@selector(toDaily) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDaily];
        
        btnWeekly = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnWeekly setFrame:CGRectMake(19,240,282,48)];
        [btnWeekly setTitle:@"Weekly Performance" forState:UIControlStateNormal];
        [btnWeekly setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnWeekly addTarget:self action:@selector(toWeekly) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnWeekly];
        
        btnMonthly = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMonthly setFrame:CGRectMake(19,340,282,48)];
        [btnMonthly setTitle:@"Monthly Performance" forState:UIControlStateNormal];
        [btnMonthly setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnMonthly addTarget:self action:@selector(toMonthly) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnMonthly];
    }
}


-(void) toDaily {	
    
	if (self.dailyVC == nil)
	{
		DailyViewController *aDetail = [[DailyViewController alloc] initWithNibName: @"DailyViewController" bundle:[NSBundle mainBundle]];
		self.dailyVC = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:dailyVC animated:YES];
}

-(void) toWeekly {	
    
	if (self.weeklyVC == nil)
	{
		WeeklyViewController *aDetail = [[WeeklyViewController alloc] initWithNibName: @"WeeklyViewController" bundle:[NSBundle mainBundle]];
		self.weeklyVC = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:weeklyVC animated:YES];
}

-(void) toMonthly {	
    
	if (self.monthlyVC == nil)
	{
		MonthlyViewController *aDetail = [[MonthlyViewController alloc] initWithNibName: @"MonthlyViewController" bundle:[NSBundle mainBundle]];
		self.monthlyVC = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:monthlyVC animated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"Performance", @"performance");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle.
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
    [dailyVC release];
    [weeklyVC release];
    [monthlyVC release];
}

@end