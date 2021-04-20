//
//  DailyReminderUpdate.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "DailyReminderUpdate.h"
#import "Singleton.h"
#import "DailyRemindersTableViewController.h"
#import "WillPowerAppDelegate.h"

@implementation DailyReminderUpdate
@synthesize quote;
@synthesize dailyTab;

-(IBAction) update {
    
    // Check if text view has content.
    if([quote.text isEqualToString:@""]){
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Notice."];
        message = [[NSString alloc] initWithFormat:
                   @"Please insert a new quote in the box."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
    else {

        quoteDB = [[Singleton sharedSingleton] formatQuoteDB:quote.text];
        newrownumber  = (int)[[Singleton sharedSingleton] getnewrownumber];
        
        char *update = "update reminders set quote = ? where row = ?;";    
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [quoteDB UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 2, newrownumber);
        }
        
        if(sqlite3_step(stmt) != SQLITE_DONE) {
            //NSLog(@"statement failed");
        }
        sqlite3_finalize(stmt);
        
        //Close database
        sqlite3_close(database);
        
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Confirmed."];
        message = [[NSString alloc] initWithFormat:
                   @"The quote has been updated."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"Thanks coach!"
                                 otherButtonTitles:nil];
        [alert show];   
        
        [self.navigationController popViewControllerAnimated:YES];    
        quote.text = [NSString stringWithFormat:@""];
    }
}

-(IBAction)deleteQuote{
    
    // Get the saved row number from the Singleton class.
    newrownumber  = (int)[[Singleton sharedSingleton] getnewrownumber];
    
    // Delete log in DB.
	char *update = "delete from reminders where row = ?;";	
	sqlite3_stmt *stmt;
	if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
		sqlite3_bind_int(stmt, 1, newrownumber);		
	}
    
    // Check if DB delete functioned
	if(sqlite3_step(stmt) != SQLITE_DONE)
    {
        //NSLog(@"statement failed");
    }
    else {
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Game Over"];
        message = [[NSString alloc] initWithFormat:
                   @"Your quote has been deleted."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"God Job!"
                                 otherButtonTitles:nil];
        [alert show];
    }
	sqlite3_finalize(stmt);
    
    //Close database
	sqlite3_close(database);
    
    [self.navigationController popViewControllerAnimated:YES];
    quote.text = [NSString stringWithFormat:@""];
}

-(IBAction)insertQuote {
    
    // Check if text view has content.
    if([quote.text isEqualToString:@""]){
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Notice."];
        message = [[NSString alloc] initWithFormat:
                   @"Please insert your quote into the box."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
    else {
        // Format the quote.
        newquote = [[Singleton sharedSingleton] formatQuoteDB:quote.text];
        
        // Insert the quote into the table
        char *insert = "INSERT INTO reminders (quote) VALUES(?);";	
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, insert, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [newquote UTF8String], -1, NULL);
        }
        if(sqlite3_step(stmt) != SQLITE_DONE) {
            //NSLog(@"statement failed");
        }
        sqlite3_finalize(stmt);
        
        //Close database
        sqlite3_close(database);
        
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Confirmed."];
        message = [[NSString alloc] initWithFormat:
                   @"This new quote has been saved."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"Thanks coach!"
                                 otherButtonTitles:nil];
        [alert show];
        
        if (self.dailyTab == nil)
        {
            DailyRemindersTableViewController *aDetail = [[DailyRemindersTableViewController alloc] initWithNibName: @"DailyRemindersTableViewController" bundle:[NSBundle mainBundle]];
            self.dailyTab = aDetail;
            [aDetail release];
        }	
        WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.navController pushViewController:dailyTab animated:YES];
        
        quote.text = [NSString stringWithFormat:@""];
    }
}


#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        
        iphone4Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,455)];
        iphone4Background.image = [UIImage imageNamed:@"iphone4Background.png"];
        [self.view addSubview:iphone4Background];
        [iphone4Background release];
        
        quote = [[UITextView alloc] initWithFrame:CGRectMake(63,9,193,182)];
        quote.font = [UIFont fontWithName:@"Helvetica" size:15];
        quote.autocorrectionType = UITextAutocorrectionTypeNo;
        quote.keyboardType = UIKeyboardTypeDefault;
        quote.returnKeyType = UIReturnKeyDone;
        [quote setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        quote.backgroundColor = [UIColor whiteColor];
        quote.textColor = [UIColor blackColor];
        quote.delegate = self;
        [self.view addSubview:quote];
        
        btnSaveQuote = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSaveQuote setFrame:CGRectMake(19,202,282,48)];
        [btnSaveQuote setImage:[UIImage imageNamed:@"button-save-new-quote.png"] forState:UIControlStateNormal];
        [btnSaveQuote addTarget:self action:@selector(insertQuote) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSaveQuote];
        
        btnUpdateQuote = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUpdateQuote setFrame:CGRectMake(19,257,282,48)];
        [btnUpdateQuote setImage:[UIImage imageNamed:@"button-update-existing-quote.png"] forState:UIControlStateNormal];
        [btnUpdateQuote addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnUpdateQuote];
        
        btnDeleteQuote = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDeleteQuote setFrame:CGRectMake(19,311,282,48)];
        [btnDeleteQuote setImage:[UIImage imageNamed:@"button-delete-quote.png"] forState:UIControlStateNormal];
        [btnDeleteQuote addTarget:self action:@selector(deleteQuote) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDeleteQuote];
    }
    else{
        iphone5Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,320,455)];
        iphone5Background.image = [UIImage imageNamed:@"iphone5Background.png"];
        [self.view addSubview:iphone5Background];
        [iphone5Background release];
        
        quote = [[UITextView alloc] initWithFrame:CGRectMake(33,100,254,202)];
        quote.font = [UIFont fontWithName:@"Helvetica" size:15];
        quote.autocorrectionType = UITextAutocorrectionTypeNo;
        quote.keyboardType = UIKeyboardTypeDefault;
        quote.returnKeyType = UIReturnKeyDefault;
        [quote setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        quote.backgroundColor = [UIColor whiteColor];
        quote.textColor = [UIColor blackColor];
        quote.delegate = self;
        [self.view addSubview:quote];
        
        btnSaveQuote = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSaveQuote setFrame:CGRectMake(19,332,282,48)];
        [btnSaveQuote setTitle:@"Save New Quote" forState:UIControlStateNormal];
        [btnSaveQuote setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnSaveQuote addTarget:self action:@selector(insertQuote) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSaveQuote];
        
        btnUpdateQuote = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUpdateQuote setFrame:CGRectMake(19,387,282,48)];
        [btnUpdateQuote setTitle:@"Update Existing Quote" forState:UIControlStateNormal];
        [btnUpdateQuote setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnUpdateQuote addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnUpdateQuote];
        
        btnDeleteQuote = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDeleteQuote setFrame:CGRectMake(19,442,282,48)];
        [btnDeleteQuote setTitle:@"Delete Quote" forState:UIControlStateNormal];
        [btnDeleteQuote setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnDeleteQuote addTarget:self action:@selector(deleteQuote) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDeleteQuote];
    }

    // Get the row carried forward from the last view
    newrownumber  = (int)[[Singleton sharedSingleton] getnewrownumber];
    
	//Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
    }
    
    // Get changed to confirm
    query = [[NSString alloc] initWithFormat: @"SELECT quote FROM reminders where row = '%i'",newrownumber];     
    //NSLog(@"query - %@", query);
    
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, [query UTF8String],-1, &stmt, nil) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){  
            quoteChar = (char *)sqlite3_column_text(stmt, 0);
            quoteDB = [[NSString alloc] initWithFormat:@"%s",quoteChar];
            
            // Take out backslashes from single quotes or double quotes.
            quote.text = [quoteDB stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
        }
        sqlite3_finalize(stmt);
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:app];
	
	app2 = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app2];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  NSLocalizedString(@"Quote", @"quote");
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    sqlite3_close(database);
    [self.quote resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil; 
    quote.text = [NSString stringWithFormat:@""];
}

-(void)applicationWillTerminate:(NSNotification *)notification {
	sqlite3_close(database);
    [self.quote resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    quote.text = [NSString stringWithFormat:@""];
}
- (void)applicationDidEnterBackground:(NSNotification *)notification {
	
	sqlite3_close(database);
    [self.quote resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil; 
    quote.text = [NSString stringWithFormat:@""];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - methods for the keyboard scrolling effect.
- (void)keyboardWillShow:(NSNotification *)aNotification 
{
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        // the keyboard is showing so resize the table's height
        CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSTimeInterval animationDuration =
        [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect frame = self.view.frame;
        frame.size.height = 415;
        frame.size.height -= keyboardRect.size.height;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        // the keyboard is hiding reset the table's height
        CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSTimeInterval animationDuration =
        [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect frame = self.view.frame;
        frame.size.height += keyboardRect.size.height;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}


#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // provide my own Save button to dismiss the keyboard
    UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																			  target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = saveItem;
    [saveItem release];
}

- (void)saveAction:(id)sender
{
    // finish typing text/dismiss the keyboard by removing it as the first responder
    //
    [self.quote resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;   // this will remove the "save" button
}

- (void)dealloc
{
    [super dealloc];
    [dailyTab release];
    [quoteDB release];
    [title release];
    [message release];
    [alert release];
    [quote release];
    [newquote release];
    [app release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
