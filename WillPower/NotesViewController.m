//
//  NotesViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//


#import "NotesViewController.h"

@implementation NotesViewController

@synthesize textView;

- (void)setupTextView
{
    self.textView = [[[UITextView alloc] initWithFrame:self.view.frame] autorelease];
    self.textView.textColor = [UIColor colorWithRed:0.000 green:0.00 blue:0.00 alpha:1.0];
    self.textView.font = [UIFont fontWithName:@"Arial" size:16];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    
    self.textView.text = @"";
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault; // use the default type input method (entire keyboard)
    self.textView.scrollEnabled = YES;
    
    // this will cause automatic vertical resize when the table is resized
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // note: for UITextView, if you don't like autocompletion while typing use:
    // myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self.view addSubview: self.textView];
}


//If application terminates, save data into kFileName file with these two methods.
-(NSString *)filePath3 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
														 NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFileName3];	
}


- (void)applicationDidEnterBackground:(NSNotification *)notification {
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[array addObject:textView.text];
	
	[array writeToFile:[self filePath3] atomically:YES];
	[array release];
    
    sqlite3_close(database);
    [self.textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil; 
}


-(void)applicationWillTerminate:(NSNotification *)notification {
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[array addObject:textView.text];
	
	[array writeToFile:[self filePath3] atomically:YES];
	[array release];
    
    sqlite3_close(database);
    [self.textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil; 
}

//Get values from the KFileName3.
-(void)viewDidLoad {
	
	self.title = NSLocalizedString(@"THE 'WHY'", @"");
    [self setupTextView];	
	NSString *filePath3 = [self filePath3];
    
    // Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	char *errorMsg;
    
    // Create warningschanged table.
	createSQL = @"CREATE TABLE IF NOT EXISTS whychanged (row integer primary key,changed integer);";
	if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0,@"Error creating table: %s", errorMsg);
	}
    
    // Get changed variable from table. Variable changed = 0 at first so we need to make it equal to 1 in the database after example wartnings inserted.
	query = [[NSString alloc] initWithFormat: @"SELECT changed FROM whychanged where row = '1'"];     
    //NSLog(@"query - %@", query);
    
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, [query UTF8String],-1, &stmt, nil) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){  
            changed = sqlite3_column_int(stmt, 0);
            //NSLog(@"Changed is  %i", changed); 
            
        }
        sqlite3_finalize(stmt);
    }
    
    //NSLog(@"Changed outside is %i", changed);
    
    // If changed = 0, then there are no rows in database because the variable 'changed' has not been changed from 0.
    if (changed == 0) {
        //NSLog(@"Changed inside if is %i", changed);
        
        // Create example warnings
        why1 = [[NSString alloc] initWithFormat: @"Scientific studies have found that people who understand their long term goals ('The WHY'), were more able to pass up a quick reward now in order to reach their goals in the future."];
        why2 = [[NSString alloc] initWithFormat: @"Primary Goal example:\n\nThis App will help me monitor my behavior in order to transcend my every day wants and cravings so that I can increase my willpower.\n\nI want more willpower so that it will be easier for me to be less selfish and more compassionate to others."];
        suggestion = [[NSString alloc] initWithFormat: @"(Click on the screen and delete these comments. Then, create your own primary goal.)"];
        exampleWhy = [[NSString alloc] initWithFormat: @"%@\n\n\n%@\n\n%@",why1,why2,suggestion];
        //NSLog(@"example warnings: %@",exampleWhy);
        
        textView.text = exampleWhy;
        
        // Make the changed = 1. then I don't have to insert the quotes into the database every time I load this view.
        changed = 1;
        char *insert = "INSERT INTO whychanged (changed) VALUES(?);";	
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, insert, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_int(stmt,1, changed);
            //NSLog(@"in insert if");
        }
        if(sqlite3_step(stmt) != SQLITE_DONE)
            NSLog(@"statement failed");
        sqlite3_finalize(stmt);        
    }
    
    else {
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath3]) {
            NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath3];
            textView.text = [array objectAtIndex:0];
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
    [self.textView resignFirstResponder];
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
    [self.textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;   // this will remove the "save" button
}

- (void)dealloc
{
    [super dealloc];
    [createSQL release];
    [query release];
    [why1 release];
    [why2 release];
	[textView release];
}
NSString *createSQL;
NSString *query;
NSString *why1;
NSString *why2;
NSString *suggestion;
NSString *exampleWhy;

@end
