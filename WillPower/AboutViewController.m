//
//  AboutViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController
@synthesize textView3;

-(void) url {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.theinfinite3.com"]];
}

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
    if ((int)screensize == 480) {
        
        about = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,411)];
        about.image = [UIImage imageNamed:@"about.png"];
        [self.view addSubview:about];
        [about release];
        
        url = [[UIImageView alloc] initWithFrame:CGRectMake(0,381,320,30)];
        url.image = [UIImage imageNamed:@"url.png"];
        [self.view addSubview:url];
        [url release];
    }
    else{
        self.textView3 = [[[UITextView alloc] initWithFrame:CGRectMake(10,15,300,500)] autorelease];
        self.textView3.textColor = [UIColor colorWithRed:0.000 green:0.00 blue:0.00 alpha:1.0];
        self.textView3.font = [UIFont fontWithName:@"Arial" size:14];
        self.textView3.delegate = self;
        [self.textView3 setTextAlignment:UITextAlignmentCenter];
        self.textView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.textView3.dataDetectorTypes = UIDataDetectorTypeLink;
        self.textView3.text = @"Willpower is a muscle that can be strengthened. To do this, it helps to set goals, monitor results and have a principle purpose for trying to do this.\n\n Willpower can be strengthened by performing simple daily activities, like sitting up straight, smiling at a stranger, eating healthy food or doing simple exercises. The key is to have the discipline to perform the tasks every day.\n\n A person's willpower is not unlimited so it is important to know the signs of willpower depletion so you can re-stock the fridge by eating some fruit or by taking a time out when the need arises.\n\n Inspired to create this App after reading a book titled 'Willpower: Rediscovering the Greatest Human Strength' by Roy F. Baumeister and John Tierney and listening to two interviews about 'Willpower and Self Control' (dated 12/31/11 and 6/22/12) on www.sciencefriday.com\n\nExamples: our images in the App Store.\n\nQuestions: willpower453@aol.com\n\nWebsite: http://theinfinite3.com";
        self.textView3.scrollEnabled = NO;
        self.textView3.editable = NO;
        [self.view addSubview: self.textView3];
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
