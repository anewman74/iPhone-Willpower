//
//  EarthScreen.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "EarthScreen.h"


@implementation EarthScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    //NSLog(@"screen size for iphone: %2f", screensize);
    if ((int)screensize == 480) {
        
        earth = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,366)];
        earth.image = [UIImage imageNamed:@"aurora.png"];
        [self.view addSubview:earth];
        [earth release];
    }
    else{
        earth = [[UIImageView alloc] initWithFrame:CGRectMake(0,109,320,366)];
        earth.image = [UIImage imageNamed:@"aurora.png"];
        [self.view addSubview:earth];
        [earth release];
    }
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
