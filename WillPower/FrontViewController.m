//
//  FrontViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "FrontViewController.h"
#import "WillPowerAppDelegate.h"
#import "ChooseActionViewController.h"


@implementation FrontViewController
@synthesize chooseActionView;

#pragma mark - start - see chooseAction view controller.
-(void) start {
	
	if (self.chooseActionView == nil)
	{
		ChooseActionViewController *aDetail = [[ChooseActionViewController alloc] initWithNibName: @"ChooseActionViewController" bundle:[NSBundle mainBundle]];
		self.chooseActionView = aDetail;
		[aDetail release];
	}
	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:chooseActionView animated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title =  NSLocalizedString(@"Willpower", @"willpower");
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        
        earth = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,367)];
        earth.image = [UIImage imageNamed:@"aurora.png"];
        [self.view addSubview:earth];
        [earth release];
        
        btnCreate = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCreate setFrame:CGRectMake(84,308,152,35)];
        [btnCreate setTitle:@"Create Willpower" forState:UIControlStateNormal];
        [btnCreate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnCreate addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnCreate];
    }
    else{
        earth = [[UIImageView alloc] initWithFrame:CGRectMake(0,25,320,366)];
        earth.image = [UIImage imageNamed:@"aurora.png"];
        [self.view addSubview:earth];
        [earth release];
        
        btnCreate = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCreate setFrame:CGRectMake(19,398,282,48)];
        [btnCreate setTitle:@"Create Willpower" forState:UIControlStateNormal];
        [btnCreate setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnCreate addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnCreate];
    }
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

- (void)dealloc
{
    [super dealloc];
    [chooseActionView release];
}

@end
