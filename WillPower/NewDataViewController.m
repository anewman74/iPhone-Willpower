//
//  NewDataViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "NewDataViewController.h"
#import "WillPowerAppDelegate.h"
#import "Singleton.h"

@implementation NewDataViewController
@synthesize keyboardToolbar;

#pragma mark - Save Goal function.
-(void) saveGoal {
    
    //If there is no name for label 1.
    if([scoretitle1.text isEqualToString:@""]){
        scoretitle1.text = @"N/A";
    }
    
    //If there is no name for label 2.
       if([scoretitle2.text isEqualToString:@""]){
        scoretitle2.text = @"N/A";
    }
    
    //Save new goal into database
    txtGoal.text = [txtGoal.text lowercaseString];
    
    char *insert = "INSERT INTO goals (name,scoretitle1, scoretitle2) VALUES(?,?,?);";	
	sqlite3_stmt *stmt;
	if(sqlite3_prepare_v2(database, insert, -1, &stmt, nil) == SQLITE_OK){
		sqlite3_bind_text(stmt, 1, [txtGoal.text UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [scoretitle1.text UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [scoretitle2.text UTF8String], -1, NULL);
	}
	if(sqlite3_step(stmt) != SQLITE_DONE)
		//NSLog(@"statement failed");
    sqlite3_finalize(stmt);
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.title =  NSLocalizedString(@"New Goal", @"new goal");
    }
    return self;
}

#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    //NSLog(@"screen size for iphone: %2f", screensize);
    if ((int)screensize == 480) {
        
        iphone4Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,455)];
        iphone4Background.image = [UIImage imageNamed:@"iphone4Background.png"];
        [self.view addSubview:iphone4Background];
        [iphone4Background release];
        
        lblGoal = [[UILabel alloc] initWithFrame:CGRectMake(111,20,96,22)];
        lblGoal.numberOfLines = 0;
        lblGoal.backgroundColor = [UIColor clearColor];
        lblGoal.textColor = [UIColor yellowColor];
        lblGoal.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [lblGoal setTextAlignment:UITextAlignmentCenter];
        lblGoal.text = @"Goal Name";
        [self.view  addSubview:lblGoal];
        
        txtGoal = [[UITextField alloc] initWithFrame:CGRectMake(20, 47, 280, 31)];
        txtGoal.borderStyle = UITextBorderStyleRoundedRect;
        txtGoal.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        txtGoal.font = [UIFont systemFontOfSize:15];
        txtGoal.autocorrectionType = UITextAutocorrectionTypeNo;
        txtGoal.keyboardType = UIKeyboardTypeDefault;
        txtGoal.returnKeyType = UIReturnKeyDone;
        txtGoal.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtGoal.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [txtGoal setTextAlignment:UITextAlignmentCenter];
        txtGoal.delegate = self;
        [self.view addSubview:txtGoal];
        [txtGoal release];
        
        lblScore1 = [[UILabel alloc] initWithFrame:CGRectMake(65,93,188,22)];
        lblScore1.numberOfLines = 0;
        lblScore1.backgroundColor = [UIColor clearColor];
        lblScore1.textColor = [UIColor yellowColor];
        lblScore1.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [lblScore1 setTextAlignment:UITextAlignmentCenter];
        lblScore1.text = @"Measurement Name 1";
        [self.view  addSubview:lblScore1];
        
        scoretitle1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 280, 31)];
        scoretitle1.borderStyle = UITextBorderStyleRoundedRect;
        scoretitle1.font = [UIFont systemFontOfSize:15];
        scoretitle1.autocorrectionType = UITextAutocorrectionTypeNo;
        scoretitle1.keyboardType = UIKeyboardTypeDefault;
        scoretitle1.returnKeyType = UIReturnKeyDone;
        scoretitle1.clearButtonMode = UITextFieldViewModeWhileEditing;
        scoretitle1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [scoretitle1 setTextAlignment:UITextAlignmentCenter];
        scoretitle1.delegate = self;
        [self.view addSubview:scoretitle1];
        [scoretitle1 release];
        
        lblScore2 = [[UILabel alloc] initWithFrame:CGRectMake(65,170,188,22)];
        lblScore2.numberOfLines = 0;
        lblScore2.backgroundColor = [UIColor clearColor];
        lblScore2.textColor = [UIColor yellowColor];
        lblScore2.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [lblScore2 setTextAlignment:UITextAlignmentCenter];
        lblScore2.text = @"Measurement Name 2";
        [self.view  addSubview:lblScore2];
        
        scoretitle2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 197, 280, 31)];
        scoretitle2.borderStyle = UITextBorderStyleRoundedRect;
        scoretitle2.font = [UIFont systemFontOfSize:15];
        scoretitle2.autocorrectionType = UITextAutocorrectionTypeNo;
        scoretitle2.keyboardType = UIKeyboardTypeDefault;
        scoretitle2.returnKeyType = UIReturnKeyDone;
        scoretitle2.clearButtonMode = UITextFieldViewModeWhileEditing;
        scoretitle2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [scoretitle2 setTextAlignment:UITextAlignmentCenter];
        scoretitle2.delegate = self;
        [self.view addSubview:scoretitle2];
        [scoretitle2 release];
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSave setFrame:CGRectMake(19,264,282,48)];
        [btnSave setImage:[UIImage imageNamed:@"button-save.png"] forState:UIControlStateNormal];
        [btnSave addTarget:self action:@selector(saveGoal) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSave];
    }
    else{
        iphone5Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,320,455)];
        iphone5Background.image = [UIImage imageNamed:@"iphone5Background.png"];
        [self.view addSubview:iphone5Background];
        [iphone5Background release];
        
        lblGoal = [[UILabel alloc] initWithFrame:CGRectMake(111,100,96,22)];
        lblGoal.numberOfLines = 0;
        lblGoal.backgroundColor = [UIColor clearColor];
        lblGoal.textColor = [UIColor blackColor];
        lblGoal.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16];
        [lblGoal setTextAlignment:UITextAlignmentCenter];
        lblGoal.text = @"Goal Name";
        [self.view  addSubview:lblGoal];
        
        txtGoal = [[UITextField alloc] initWithFrame:CGRectMake(20, 127, 280, 31)];
        txtGoal.borderStyle = UITextBorderStyleRoundedRect;
        txtGoal.font = [UIFont systemFontOfSize:15];
        txtGoal.autocorrectionType = UITextAutocorrectionTypeNo;
        txtGoal.keyboardType = UIKeyboardTypeDefault;
        txtGoal.returnKeyType = UIReturnKeyDone;
        txtGoal.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtGoal.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [txtGoal setTextAlignment:UITextAlignmentCenter];
        txtGoal.delegate = self;
        [self.view addSubview:txtGoal];
        [txtGoal release];
        
        lblScore1 = [[UILabel alloc] initWithFrame:CGRectMake(65,187,188,22)];
        lblScore1.numberOfLines = 0;
        lblScore1.backgroundColor = [UIColor clearColor];
        lblScore1.textColor = [UIColor blackColor];
        lblScore1.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16];
        [lblScore1 setTextAlignment:UITextAlignmentCenter];
        lblScore1.text = @"Measurement Name 1";
        [self.view  addSubview:lblScore1];
        
        scoretitle1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 214, 280, 31)];
        scoretitle1.borderStyle = UITextBorderStyleRoundedRect;
        scoretitle1.font = [UIFont systemFontOfSize:15];
        scoretitle1.autocorrectionType = UITextAutocorrectionTypeNo;
        scoretitle1.keyboardType = UIKeyboardTypeDefault;
        scoretitle1.returnKeyType = UIReturnKeyDone;
        scoretitle1.clearButtonMode = UITextFieldViewModeWhileEditing;
        scoretitle1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [scoretitle1 setTextAlignment:UITextAlignmentCenter];
        scoretitle1.delegate = self;
        [self.view addSubview:scoretitle1];
        [scoretitle1 release];
        
        lblScore2 = [[UILabel alloc] initWithFrame:CGRectMake(65,274,188,22)];
        lblScore2.numberOfLines = 0;
        lblScore2.backgroundColor = [UIColor clearColor];
        lblScore2.textColor = [UIColor blackColor];
        lblScore2.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16];
        [lblScore2 setTextAlignment:UITextAlignmentCenter];
        lblScore2.text = @"Measurement Name 2";
        [self.view  addSubview:lblScore2];
        
        scoretitle2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 301, 280, 31)];
        scoretitle2.borderStyle = UITextBorderStyleRoundedRect;
        scoretitle2.font = [UIFont systemFontOfSize:15];
        scoretitle2.autocorrectionType = UITextAutocorrectionTypeNo;
        scoretitle2.keyboardType = UIKeyboardTypeDefault;
        scoretitle2.returnKeyType = UIReturnKeyDone;
        scoretitle2.clearButtonMode = UITextFieldViewModeWhileEditing;
        scoretitle2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [scoretitle2 setTextAlignment:UITextAlignmentCenter];
        scoretitle2.delegate = self;
        [self.view addSubview:scoretitle2];
        [scoretitle2 release];
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSave setFrame:CGRectMake(19,350,282,48)];
        [btnSave setTitle:@"Save" forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnSave addTarget:self action:@selector(saveGoal) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSave];
        
        suggestion = [[UILabel alloc] initWithFrame:CGRectMake(20,400,290,100)];
        suggestion.backgroundColor = [UIColor clearColor];
        suggestion.textColor = [UIColor blackColor];
        suggestion.numberOfLines = 4;
        suggestion.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16];
        [suggestion setTextAlignment:UITextAlignmentLeft];
        suggestion.text = @"Write the goal title and add one or two measurement names. For example, the goal could be 'Exercises' and the names could be 'Push Ups' and 'Sit Ups'.";
        [self.view  addSubview:suggestion];
    }

	
	//Registering a notification when keyboard will show.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:self.view.window];
    
    app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app];
    
	// Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	char *errorMsg;
    
	NSString *createSQL = @"CREATE TABLE IF NOT EXISTS goals (row integer primary key,date double, datestring varchar(25), monthstring varchar(25), yearstring varchar(25), name varchar(25), scoretitle1 varchar(25), score1 integer, scoretitle2 varchar(25), score2 integer, comment varchar(25), rating integer);";
    
	if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0,@"Error creating table: %s", errorMsg);
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title =  NSLocalizedString(@"New Goal", @"new goal");
    
    //Set up the keyboard toolbar.
    if(keyboardToolbar == nil) {
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousField:)];
        
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextField:)];
        
        previousButton.width = 77.0f;
        nextButton.width = 77.0f;
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
        
        [keyboardToolbar setItems:[[[NSArray alloc] initWithObjects:previousButton,nextButton,extraSpace,doneButton,nil] autorelease]];
        
        [previousButton release];
        [nextButton release];
        [extraSpace release];
        [doneButton release];
    }
    
    txtGoal.inputAccessoryView = keyboardToolbar;
    scoretitle1.inputAccessoryView = keyboardToolbar;
    scoretitle2.inputAccessoryView = keyboardToolbar;
}

// If 'done' is clicked.
-(void) resignKeyboard:(id)sender {
    
    // If goal has the keyboard, we want to resign the keyboard to disappear because 'done' was clicked.
    if ([txtGoal isFirstResponder]) {
        [txtGoal resignFirstResponder];
        [self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
    }
    else if ([scoretitle1 isFirstResponder]) {
        [scoretitle1 resignFirstResponder];
        [self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
    }
    else if ([scoretitle2 isFirstResponder]) {
        [scoretitle2 resignFirstResponder];
        [self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
    }
}
  
-(void) previousField:(id)sender {

    if ([txtGoal isFirstResponder]) {
        [scoretitle2 becomeFirstResponder];
    }
    else if ([scoretitle1 isFirstResponder]) {
        [txtGoal becomeFirstResponder];
    }
    else if ([scoretitle2 isFirstResponder]) {
        [scoretitle1 becomeFirstResponder];
    }
}

-(void) nextField:(id)sender {
    
    if ([txtGoal isFirstResponder]) {
        [scoretitle1 becomeFirstResponder];
    }
    else if ([scoretitle1 isFirstResponder]) {
        [scoretitle2 becomeFirstResponder];
    }
    else if ([scoretitle2 isFirstResponder]) {
        [txtGoal becomeFirstResponder];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
	
	//Scroll keyboard down screen if showing.
    if(txtGoal.editing){
		[txtGoal resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
	else if(scoretitle1.editing){
		[scoretitle1 resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
    else if(scoretitle2.editing){
		[scoretitle2 resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
    
    //Empty text fields
    txtGoal.text = @"";
    scoretitle1.text = @"";
    scoretitle2.text = @"";
    
	
	//Unregistering keyboard notification.
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification object:nil];
	
	[super viewWillDisappear:animated];
}

-(void)applicationWillTerminate:(NSNotification *)notification {
	sqlite3_close(database);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - methods for the keyboard scrolling effect.
-(void) keyboardWillShow:(NSNotification *)notif {
	CGRect keyboardEndFrame;
	[[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
		keyboardSize = keyboardEndFrame.size.height;
	}
	else {
		keyboardSize = keyboardEndFrame.size.width;
	}

    [[Singleton sharedSingleton] setkeyboardsize:keyboardSize];
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        
        if(txtGoal.editing){
            float bottomPoint = (txtGoal.frame.origin.y +
                                 txtGoal.frame.size.height);
            scrollAmount = keyboardSize - (411 - bottomPoint);
        }
        else if(scoretitle1.editing){
            float bottomPoint = (scoretitle1.frame.origin.y +
                                 scoretitle1.frame.size.height);
            scrollAmount = keyboardSize - (411 - bottomPoint);
        }
        else if(scoretitle2.editing){
            float bottomPoint = (scoretitle2.frame.origin.y +
                                 scoretitle2.frame.size.height);
            scrollAmount = keyboardSize - (411 - bottomPoint);
        }
    }
    
    if(scrollAmount > 0) {
		moveViewUp = YES;
		[self scrollTheView:YES];
	}
	else {
		moveViewUp = NO;
	}
	
}

- (void) scrollTheView: (BOOL) movedUp {
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];	
	CGRect rect = self.view.frame;
	
	if(movedUp){
		rect.origin.y -= scrollAmount;
	}
	else {
        if (scrollAmount > 0) {
            //if there was an existing scroll amount, then move keyboard back whole way.
            rect.origin.y += scrollAmount;
        }
	}
	
	self.view.frame = rect;	
	[UIView commitAnimations];	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    keyboardSize = (int)[[Singleton sharedSingleton] getkeyboardsize];
    
    // Keyboard just appeared.
    if (keyboardSize == 0) {
        keyboardJustAppeared = true;
    }
    else {
        keyboardJustAppeared = false;
    }
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        if(txtGoal.editing){
            // Get the existing scroll amount.
            if (scrollAmount  > 0) {
                scrollAmount = -scrollAmount;
            }
            else {
                scrollAmount = 0;
            }
        }
        else if(scoretitle1.editing){
            // Get the existing scroll amount.
            if (scrollAmount  > 0) {
                scrollAmount = -scrollAmount;
            }
            else {
                scrollAmount = 0;
            }
        }
        else if(scoretitle2.editing){
            
            float bottomPoint = (scoretitle2.frame.origin.y +
                                 scoretitle2.frame.size.height);
            scrollAmount = keyboardSize - (411 - bottomPoint);
        }
        
        if (keyboardJustAppeared == true) {
            moveViewUp = NO;
        }
        else {
            moveViewUp = YES;
            [self scrollTheView:YES];
        }
    }
}


-(BOOL) textFieldShouldReturn: (UITextField *) theTextField {	
	
	[theTextField resignFirstResponder];
	[self becomeFirstResponder];
	
	if(moveViewUp) [self scrollTheView:NO];	
	
	//After keyboard has been set back down, set scroll amount to nil.
	scrollAmount = 0;	
    [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	
	return YES;
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *)event {	
	if(txtGoal.editing){
		[txtGoal resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
    else if(scoretitle1.editing){
		[scoretitle1 resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
    else if(scoretitle2.editing){
		[scoretitle2 resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}

	[super touchesBegan:touches withEvent:event];
}

- (void)dealloc
{
    [super dealloc];
    [txtGoal release];
    [scoretitle1 release];
    [scoretitle2 release];
    [app release];
    [keyboardToolbar release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
