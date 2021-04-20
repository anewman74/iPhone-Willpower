//
//  NewDepViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//


#import "NewDepViewController.h"

@implementation NewDepViewController

@synthesize textView2;

- (void)setupTextView
{
    self.textView2 = [[[UITextView alloc] initWithFrame:self.view.frame] autorelease];
    self.textView2.textColor = [UIColor colorWithRed:0.000 green:0.00 blue:0.00 alpha:1.0];
    self.textView2.font = [UIFont fontWithName:@"Arial" size:16];
    self.textView2.delegate = self;
    self.textView2.backgroundColor = [UIColor whiteColor];
    
    self.textView2.text = @"";
    self.textView2.returnKeyType = UIReturnKeyDefault;
    self.textView2.keyboardType = UIKeyboardTypeDefault; // use the default type input method (entire keyboard)
    self.textView2.scrollEnabled = YES;
    
    // this will cause automatic vertical resize when the table is resized
    self.textView2.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // note: for UITextView, if you don't like autocompletion while typing use:
    // myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self.view addSubview: self.textView2];
}


//If application terminates, save data into kFileName file with these two methods.
-(NSString *)filePath4 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
														 NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFileName4];	
}


- (void)applicationDidEnterBackground:(NSNotification *)notification {
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[array addObject:textView2.text];
	
	[array writeToFile:[self filePath4] atomically:YES];
	[array release];
    
    sqlite3_close(database);
    [self.textView2 resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}


-(void)applicationWillTerminate:(NSNotification *)notification {
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[array addObject:textView2.text];
	
	[array writeToFile:[self filePath4] atomically:YES];
	[array release];
    
    sqlite3_close(database);
    [self.textView2 resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

//Get values from the KFileName3.
-(void)viewDidLoad {
	
	self.title = NSLocalizedString(@"Warning Signs", @"");
    [self setupTextView];
    NSString *filePath4 = [self filePath4];
    
    // Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	char *errorMsg;
    
    // Create warningschanged table.
	createSQL = @"CREATE TABLE IF NOT EXISTS warningschanged (row integer primary key,changed integer);";
	if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0,@"Error creating table: %s", errorMsg);
	}
    
    // Get changed variable from table. Variable changed = 0 at first so we need to make it equal to 1 in the database after example wartnings inserted.
	query = [[NSString alloc] initWithFormat: @"SELECT changed FROM warningschanged where row = '1'"];     
    //NSLog(@"query - %@", query);
    
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, [query UTF8String],-1, &stmt, nil) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){  
            changed = sqlite3_column_int(stmt, 0);
            
        }
        sqlite3_finalize(stmt);
    }
    
    // If changed = 0, then there are no rows in database because the variable 'changed' has not been changed from 0.
    if (changed == 0) {
        
        // Create example warnings
        warning1 = [[NSString alloc] initWithFormat: @"Less patient."];
        warning2 = [[NSString alloc] initWithFormat: @"More irritable."];
        warning3 = [[NSString alloc] initWithFormat: @"Lack of energy."];
        warning4 = [[NSString alloc] initWithFormat: @"More selfish."];
        suggestion = [[NSString alloc] initWithFormat: @"(Delete this list and make your own list of your typical signs of willpower depletion.)"];
        exampleWarnings = [[NSString alloc] initWithFormat: @"%@\n%@\n%@\n%@\n\n%@",warning1,warning2,warning3,warning4,suggestion];
        
        textView2.text = exampleWarnings;
        
        // Make the changed = 1. then I don't have to insert the quotes into the database every time I load this view.
        changed = 1;
        char *insert = "INSERT INTO warningschanged (changed) VALUES(?);";	
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, insert, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_int(stmt,1, changed);
        }
        if(sqlite3_step(stmt) != SQLITE_DONE)
        {
            //NSLog(@"statement failed");
        }
        sqlite3_finalize(stmt);        
    }
    
    else {
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath4]) {
            NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath4];
            textView2.text = [array objectAtIndex:0];
            [array autorelease];
        }
    }
		
	UIApplication *app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:app];
	
	UIApplication *app2 = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app2];
	
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated 
{
    // listen for keyboard hide/show notifications so we can properly adjust the table's height
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
    [self.textView2 resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)keyboardWillShow:(NSNotification *)aNotification 
{
    // the keyboard is showing so resize the table's height
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
	
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        frame.size.height = 415;
    }
    else {
        frame.size.height = 568;
    }
    
    frame.size.height -= keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
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


#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //NSLog(@"in text view did begin editing");
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
    [self.textView2 resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;   // this will remove the "save" button
}

- (void)dealloc
{
    [super dealloc];
    [createSQL release];
    [query release];
    [warning1 release];
    [warning2 release];
    [warning3 release];
    [warning4 release];
    [suggestion release];
    [textView2 release];
}

@end
