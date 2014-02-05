//
//  STTransactionViewController.m
//  SimplerTransaction
//
//  Created by Cotter, Vince on 11/19/13.
//  Copyright (c) 2013 PayPal Partner. All rights reserved.
//

#import "STTransactionViewController.h"
#import "SASettingsViewController.h"
#import "SASignatureViewController.h"

#import <PayPalHereSDK/PayPalHereSDK.h>
#import <PayPalHereSDK/PPHTransactionManager.h>
#import <PayPalHereSDK/PPHTransactionWatcher.h>
#import <PayPalHereSDK/PPHTransactionRecord.h>

#define kAPPLES			@"Apples"
#define kBANANAS		@"Bananas"
#define kORANGES		@"Oranges"
#define kSTRAWBERRIES	@"Strawberries"
#define kPRICE			@"Price"
#define kQUANTITY		@"Quantity"

@interface STTransactionViewController ()
@property (nonatomic,strong) PPHTransactionWatcher *transactionWatcher;
@property (nonatomic,strong) TransactionButton *appleItemButton;
@property (nonatomic,strong) TransactionButton *bananaItemButton;
@property (nonatomic,strong) TransactionButton *orangeItemButton;
@property (nonatomic,strong) TransactionButton *strawberryItemButton;
@property (nonatomic,strong) NSMutableDictionary *shoppingCart;
@property BOOL waitingForCardSwipe;
@end

@implementation STTransactionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.transactionWatcher = [[PPHTransactionWatcher alloc] initWithDelegate:self];
		self.shoppingCart =
			[NSMutableDictionary 
				dictionaryWithObjectsAndKeys:

					[NSMutableDictionary 
						dictionaryWithObjectsAndKeys:
							[NSDecimalNumber numberWithDouble:0.95], kPRICE,
						[NSDecimalNumber numberWithInt:0], kQUANTITY,
						nil], 
				kAPPLES,

				[NSMutableDictionary 
					dictionaryWithObjectsAndKeys:
						[NSDecimalNumber numberWithDouble:0.50], kPRICE,
					[NSDecimalNumber numberWithInt:0], kQUANTITY,
					nil], 
				kBANANAS,
				
				[NSMutableDictionary 
					dictionaryWithObjectsAndKeys:
						[NSDecimalNumber numberWithDouble:0.45], kPRICE,
					[NSDecimalNumber numberWithInt:0], kQUANTITY,
					nil], 
				kORANGES,
				
				[NSMutableDictionary 
					dictionaryWithObjectsAndKeys:
						[NSDecimalNumber numberWithDouble:0.25], kPRICE,
					[NSDecimalNumber numberWithInt:0], kQUANTITY,
					nil], 
				kSTRAWBERRIES,
				
				nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.waitingForCardSwipe = NO;
	self.title = @"Transaction";
	self.amountTextField.delegate = self;


	self.appleItemButton = [[TransactionButton alloc] 
							   initWithTransactionVC:self
							   forItem:kAPPLES
							   onButton:self.appleButton];


	self.bananaItemButton = [[TransactionButton alloc] 
							   initWithTransactionVC:self
							   forItem:kBANANAS
							   onButton:self.bananaButton];

	self.orangeItemButton = [[TransactionButton alloc] 
							   initWithTransactionVC:self
							   forItem:kORANGES
							   onButton:self.orangeButton];

	self.strawberryItemButton = [[TransactionButton alloc] 
							   initWithTransactionVC:self
							   forItem:kSTRAWBERRIES
							   onButton:self.strawberryButton];


    self.shoppingCartTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.shoppingCartTable setDataSource:self];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	// Now do your setup:

	// Make sure the UI is in the right state for the selectd mode:
	[self changeUIStateForItemizedMode:[self.itemizedModeSegmentedControl selectedSegmentIndex]];
    
    [self.processingTransactionSpinny stopAnimating];
    self.processingTransactionSpinny.hidden = YES;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alertView =
    [[UIAlertView alloc]
     initWithTitle:title
     message: message
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
    
    [alertView show];
}

- (BOOL) isOnMultiItemScreen {
    return self.amountTextField.hidden;
}

- (IBAction)onChargePressed:(id)sender {
    
	if (self.waitingForCardSwipe) {
        [self showAlertWithTitle:@"Waiting for Card Swipe!" andMessage:@"To complete your Purchase, please swipe your credit card."];
        return;
	}

	NSString *amountString = nil;
	double transactionAmount = 0;

	if ([self isOnMultiItemScreen]) {
		NSLog(@"On Multi-Item Screen!");

		transactionAmount = [self sumShoppingCart];
	}
	else {
		NSLog(@"On Single Item Screen!");

		[self.amountTextField resignFirstResponder];

		// Make sure the user has entered some amount:
		amountString = self.amountTextField.text;
		if ([amountString length] == 0) {
			[self showAlertWithTitle:@"Input Error" andMessage:@"You need to enter a transaction amount before you can purchase something."];
			return;
		}

		// Check to make sure this is a non-zero amount:
		NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber *formattedAmount = [f numberFromString:amountString];
		if (formattedAmount == nil) {
			[self showAlertWithTitle:@"Input Error" andMessage:@"You must specify a proper numerical transaction amount in order to purchase something"];
			return;
		}

		transactionAmount = [formattedAmount doubleValue];

	}

	if (transactionAmount < 0.01 && transactionAmount > -0.01) {
		[self showAlertWithTitle:@"Input Error" andMessage:@"You cannot specify amounts less than a penny."];
		return;
	}

    // Hmm.  Seems the app didn't setup the merchant after logging in???
    PPHMerchantInfo *currentMerchant = [PayPalHereSDK activeMerchant];
    if(currentMerchant == nil) {
        [self showAlertWithTitle:@"Bad State!" andMessage:@"The merchant hasn't been created yet?   We can't use the SDK until the merchant exists."];
        return;
    }
    
	
    // If it is setup then let's proceede with a test:
    
    //This is a test of calling beginTransaciton on the new transaciton manager.
    PPHTransactionManager *tm = [PayPalHereSDK sharedTransactionManager];

    if([self isOnMultiItemScreen]) {
        [tm beginPayment];
        
        NSArray *itemList = @[kAPPLES, kBANANAS, kORANGES, kSTRAWBERRIES];
        
        for (NSString *itemName in itemList) {
            NSMutableDictionary *items = [self.shoppingCart valueForKey:itemName];
            NSDecimalNumber *quantity = [items valueForKey:kQUANTITY];
            NSDecimalNumber *costEach = [items valueForKey:kPRICE];
                                  
            [tm.currentInvoice addItemWithId:itemName name:itemName quantity:quantity unitPrice:costEach taxRate:nil taxRateName:nil];
        }
    }
    else {
        NSLog(@"About to call beginPaymentWithAmount for amount %@", amountString);
        [tm beginPaymentWithAmount:[PPHAmount amountWithString:amountString inCurrency:@"USD"] andName:@"FixedAmountPayment"];
    }
    
    self.waitingForCardSwipe = YES;

    [self showAlertWithTitle:@"Please Swipe your Credit Card" andMessage:@"The PayPalHereSDK is now waiting for a card swipe to proceed."];

}

- (IBAction)onManualCardChargePressed:(id)sender {
    // Hmm.  Seems the app didn't setup the merchant after logging in???
    PPHMerchantInfo *currentMerchant = [PayPalHereSDK activeMerchant];
    if(currentMerchant == nil) {
        [self showAlertWithTitle:@"Bad State!" andMessage:@"The merchant hasn't been created yet?   We can't use the SDK until the merchant exists."];
        return;
    }
    
    // Setup the manually entered card data
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:9];
    [comps setYear:2019];
    
    PPHCardNotPresentData *manualCardData = [[PPHCardNotPresentData alloc] init];
    manualCardData.cardNumber = @"4111111111111111";
    manualCardData.cvv2 = @"408";
    manualCardData.expirationDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
    //Now, take a payment with it
    PPHTransactionManager *tm = [PayPalHereSDK sharedTransactionManager];
    
    [tm beginPaymentWithAmount:[PPHAmount amountWithString:@"33.00" inCurrency:@"USD"] andName:@"FixedAmountPayment"];
    tm.manualEntryOrScannedCardData = manualCardData;
    
    
    [tm processPaymentWithPaymentType:ePPHPaymentMethodKey
              withTransactionController:self
                      completionHandler:^(PPHTransactionResponse *record) {
        if(record.error) {
            NSString *message = [NSString stringWithFormat:@"Manual Entry payment finished with an error: %@", record.error.apiMessage];
            [self showAlertWithTitle:@"Payment Failed" andMessage:message];
        }
        else {
            PPHTransactionResponse *localTransactionResponse = record;
            PPHTransactionRecord *transactionRecord = localTransactionResponse.record;
            NSString *message = [NSString stringWithFormat:@"Manual Entry finished successfully with transactionId: %@", transactionRecord.transactionId];
            [self showAlertWithTitle:@"Payment Success" andMessage:message];
        }
    }];

}

- (IBAction)onCashChargePressed:(id)sender {
    // Hmm.  Seems the app didn't setup the merchant after logging in???
    PPHMerchantInfo *currentMerchant = [PayPalHereSDK activeMerchant];
    if(currentMerchant == nil) {
        [self showAlertWithTitle:@"Bad State!" andMessage:@"The merchant hasn't been created yet?   We can't use the SDK until the merchant exists."];
        return;
    }
    
    //For Cash the PPHTransactionManager will simply record the invoice to the backend.
    PPHTransactionManager *tm = [PayPalHereSDK sharedTransactionManager];
    
    tm.ignoreHardwareReaders = YES;     //Let's not scan for any hardware during this transaciton.
    [tm beginPaymentWithAmount:[PPHAmount amountWithString:@"33.00" inCurrency:@"USD"] andName:@"FixedAmountPayment"];
    [tm processPaymentWithPaymentType:ePPHPaymentMethodCash
              withTransactionController:self
                      completionHandler:^(PPHTransactionResponse *record) {
                          if(record.error) {
                              NSString *message = [NSString stringWithFormat:@"Cash Entry payment finished with an error: %@", record.error.apiMessage];
                              [self showAlertWithTitle:@"Payment Failed" andMessage:message];
                          }
                          else {
                              PPHTransactionResponse *localTransactionResponse = record;
                              PPHTransactionRecord *transactionRecord = localTransactionResponse.record;
                              NSString *message = [NSString stringWithFormat:@"Cash Entry finished successfully with transactionId: %@", transactionRecord.transactionId];
                              [self showAlertWithTitle:@"Payment Success" andMessage:message];
                          }
                          tm.ignoreHardwareReaders = NO;    //Back to the default running state.
                      }];
    
}


- (double) sumShoppingCart
{
	NSArray *itemList = @[kAPPLES, kBANANAS, kORANGES, kSTRAWBERRIES];

	double total = 0;

	for (NSString *item in itemList) {
		NSMutableDictionary *items = [self.shoppingCart valueForKey:item];

		total += ([[items valueForKey:kQUANTITY] intValue] * [[items valueForKey:kPRICE] doubleValue]);
	}

	return total;
}

- (IBAction)onSettingsPressed:(id)sender {
    SASettingsViewController *settings = nil;
    
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		settings = [[SASettingsViewController alloc]
                        initWithNibName:@"SASettingsViewController_iPhone"
                        bundle:nil];
	}
	else {
		settings = [[SASettingsViewController alloc]
                        initWithNibName:@"SASettingsViewController_iPad"
                        bundle:nil];
	}
    
    [self.navigationController pushViewController:settings animated:YES];
}

#pragma mark - UITableViewDataSource callbacks
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
        }
    }
    else
    {
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
    }
    
	NSMutableDictionary *items = nil;
	NSString *item = nil;
	switch (indexPath.row) {
	case 0:
		item = kAPPLES;
		break;

	case 1:
		item = kBANANAS;
		break;

	case 2:
		item = kORANGES;
		break;

	case 3:
		item = kSTRAWBERRIES;
		break;

	}

	if (indexPath.row == 4) {
		cell.textLabel.text = 
			[NSString stringWithFormat:@"TOTAL: $%0.2f", [self sumShoppingCart]];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
	}
	else {
		NSString *spacer = (indexPath.row == 3 ? @"\t\t" : @"\t\t\t");
		items = [self.shoppingCart valueForKey:item];
		cell.textLabel.text = 
			[NSString 
				stringWithFormat:
					[[@"%@ ($%0.2f)" stringByAppendingString:spacer] stringByAppendingString:@"%d"],
				item, 
				[[items valueForKey:kPRICE] doubleValue], 
				[[items valueForKey:kQUANTITY] intValue]];
	
		cell.textLabel.textAlignment = NSTextAlignmentLeft;

	}


	return cell;
}

#pragma mark -
#pragma mark PPHTransactionManagerDelegate overrides

- (void)onPaymentEvent:(PPHTransactionManagerEvent *) event {
    if(event.eventType == ePPHTransactionType_Idle) {
        [self.processingTransactionSpinny stopAnimating];
        self.processingTransactionSpinny.hidden = YES;
    }
    else {
        [self.processingTransactionSpinny startAnimating];
        self.processingTransactionSpinny.hidden = NO;
    }
    
	NSLog(@"Our local instance of PPHTransactionWatcher picked up a PPHTransactionManager event notification: <%@>", event);
    if(event.eventType == ePPHTransactionType_CardDataReceived && self.waitingForCardSwipe)  {

        self.waitingForCardSwipe = NO;
        
        //Now ask to authorize (and take) payment.
        [[PayPalHereSDK sharedTransactionManager] processPaymentWithPaymentType:ePPHPaymentMethodSwipe
                  withTransactionController:self
                          completionHandler:^(PPHTransactionResponse *response) {
                              if(response.error) {
                                  NSString *message = [NSString stringWithFormat:@"Card payment finished with an error: %@", response.error.apiMessage];
                                  [self showAlertWithTitle:@"Payment Failed" andMessage:message];
                              }
                              else {
                                  PPHTransactionResponse *localTransactionResponse = response;
                                  PPHTransactionRecord *transactionRecord = localTransactionResponse.record;
                                  
                                  // Is a signature required for this payment?  If so
                                  // then let's collect a signature and provide it to the SDK.
                                  if(response.isSignatureRequiredToFinalize) {
                                      [self collectSignatureAndFinalizePurchaseWithRecord:transactionRecord];
                                  }
                                  else {
                                      // All done.  Tell the user the good news.
                                      NSString *message = [NSString stringWithFormat:@"Card payment finished successfully with transactionId: %@", transactionRecord.transactionId];
                                      [self showAlertWithTitle:@"Payment Success" andMessage:message];
                                  }
                                  
                              }
                          }];
    }
}

#pragma mark PPHTransactionControllerDelegate
-(PPHTransactionControlActionType)onPreAuthorizeForInvoice:(PPHInvoice *)inv withPreAuthJSON:(NSString*) preAuthJSON {
    NSLog(@"STTransactionViewController: onPreAuthorizeForInvoice called");
    return ePPHTransactionType_Continue;
}

-(void)onPostAuthorize:(BOOL)didFail {
    NSLog(@"STTransactionViewController: onPostAuthorize called.  'authorize' %@ fail", didFail ? @"DID" : @"DID NOT");
}


-(void)collectSignatureAndFinalizePurchaseWithRecord:(PPHTransactionRecord*)record {
    
    SASignatureViewController *settings = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        settings = [[SASignatureViewController alloc]
                    initWithNibName:@"SASignatureViewController_iPhone"
                    bundle:nil
                    transactionRecord:record];
    }
    else {
        settings = [[SASignatureViewController alloc]
                    initWithNibName:@"SASignatureViewController_iPad"
                    bundle:nil
                    transactionRecord:record];
    }
    
    [self.navigationController pushViewController:settings animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.amountTextField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	// Allow the Backspace character:
	if (!string.length)
		return YES;

	// Do not allow pasting of a range of characters:
	if (string.length > 1)
		return NO;

	// Allow leading '+' or '-' signs:
	if ([textField.text length] == 0 && 
		(
			[string rangeOfString:@"+"].location != NSNotFound ||
			[string rangeOfString:@"-"].location != NSNotFound 
		)
		) {
		return YES;
	}

	NSUInteger currentDecimalPointLocation = [textField.text rangeOfString:@"."].location;
	NSUInteger newDecimalPointLocation = [string rangeOfString:@"."].location;

	// Reject any non-numeric inputs (other than '.').
	if ([string 
			rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location 
		!= NSNotFound  &&
		newDecimalPointLocation == NSNotFound
		)
		return NO;

	// If you haven't already got a decimal point yet, any numeric input is OK:
	if (currentDecimalPointLocation == NSNotFound)
		return YES;

	// If you've already got a decimal point, and the user tries to
	// feed you another, the input is definitely invalid:
	if (newDecimalPointLocation != NSNotFound)
		return NO;


	// Finally, check for more than 2 digits to the right of the decimal point:
	BOOL notTooManyDigitsFollowTheDecimalPoint = ([textField.text length] - currentDecimalPointLocation) <= 2;

	return notTooManyDigitsFollowTheDecimalPoint;

}



#pragma mark -
#pragma mark UISegmentedControl

- (IBAction)itemizedModeChanged:(id)sender
{
	UISegmentedControl *itemizedModeSelector = (UISegmentedControl *) sender;
	NSInteger itemizedMode = [itemizedModeSelector selectedSegmentIndex];
	[self changeUIStateForItemizedMode:itemizedMode];
}

- (void) changeUIStateForItemizedMode:(NSInteger )mode
{
	const NSInteger kSingleItemMode = 0;
	const NSInteger kItemizedMode = 1;

	if (mode == kSingleItemMode) {
		self.amountTextField.hidden = NO;
		self.enterAmountLabel.hidden = NO;

		self.appleButton.hidden = YES;
		self.bananaButton.hidden = YES;
		self.orangeButton.hidden = YES;
		self.strawberryButton.hidden = YES;
		self.longPressExplanationLabel.hidden = YES;

		self.shoppingCartTable.hidden = YES;
	}
	else if (mode == kItemizedMode) {
		self.amountTextField.hidden = YES;
		self.enterAmountLabel.hidden = YES;

		self.appleButton.hidden = NO;
		self.bananaButton.hidden = NO;
		self.orangeButton.hidden = NO;
		self.strawberryButton.hidden = NO;
		self.longPressExplanationLabel.hidden = NO;

		self.shoppingCartTable.hidden = NO;
	}
	else {
		NSLog(@"WTF? Somehow got this undefined mode specifier value: %d:", mode);
	}

}
@end

@interface TransactionButton ()
@property (nonatomic, strong) STTransactionViewController *target;
@property (nonatomic, strong) NSString *item;
@end

@implementation TransactionButton
- (id) initWithTransactionVC:(STTransactionViewController *)vc forItem:(NSString *)item onButton:(UIButton *)aButton
{
	if ((self = [super initWithButton:aButton])) {
		_target = vc;
		_item = item;
	}

	return self;
}

- (void) itemWasTouchedUpAndDidHold
{
	NSMutableDictionary *items = [self.target.shoppingCart valueForKey:self.item];
	[items 
		setObject:[NSDecimalNumber numberWithInt:0]
		forKey:kQUANTITY];

	[self.target.shoppingCartTable reloadData];

}

- (void) itemWasTouchedUp
{
	NSMutableDictionary *items = [self.target.shoppingCart valueForKey:self.item];
	NSNumber *quantity = [items valueForKey:kQUANTITY];
	[items 
		setObject:[NSDecimalNumber numberWithInt:[quantity intValue] + 1]
		forKey:kQUANTITY];


	[self.target.shoppingCartTable reloadData];

}



@end

