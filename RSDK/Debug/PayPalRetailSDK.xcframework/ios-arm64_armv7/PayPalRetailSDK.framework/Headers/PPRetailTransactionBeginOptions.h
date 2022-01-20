/**
 * PPRetailTransactionBeginOptions.h
 *
 * DO NOT EDIT THIS FILE! IT IS AUTOMATICALLY GENERATED AND SHOULD NOT BE CHECKED IN.
 * Generated from: js/transaction/TransactionBeginOptions.js
 *
 * 
 */

#import "PayPalRetailSDKTypeDefs.h"
#import "PPRetailObject.h"


@class PPRetailSDK;
@class PPRetailError;
@class PPRetailPayPalErrorInfo;
@class PPRetailAccountSummary;
@class PPRetailAccountSummarySection;
@class PPRetailInvoiceAddress;
@class PPRetailInvoiceAttachment;
@class PPRetailInvoiceBillingInfo;
@class PPRetailInvoiceCCInfo;
@class PPRetailCountries;
@class PPRetailCountry;
@class PPRetailInvoiceCustomAmount;
@class PPRetailInvoice;
@class PPRetailInvoiceActions;
@class PPRetailInvoiceConstants;
@class PPRetailInvoiceListRequest;
@class PPRetailInvoiceListResponse;
@class PPRetailInvoiceMetaData;
@class PPRetailInvoiceTemplatesResponse;
@class PPRetailInvoicingService;
@class PPRetailInvoiceItem;
@class PPRetailInvoiceMerchantInfo;
@class PPRetailInvoiceNotification;
@class PPRetailInvoicePayment;
@class PPRetailInvoicePaymentTerm;
@class PPRetailInvoiceRefund;
@class PPRetailInvoiceSearchRequest;
@class PPRetailInvoiceShippingInfo;
@class PPRetailInvoiceTemplate;
@class PPRetailInvoiceTemplateSettings;
@class PPRetailMerchant;
@class PPRetailNetworkRequest;
@class PPRetailNetworkResponse;
@class PPRetailSdkEnvironmentInfo;
@class PPRetailRetailInvoice;
@class PPRetailRetailInvoicePayment;
@class PPRetailBraintreeManager;
@class PPRetailSimulationManager;
@class PPRetailMerchantManager;
@class PPRetailCaptureHandler;
@class PPRetailRecord;
@class PPRetailTransactionContext;
@class PPRetailTransactionManager;
@class PPRetailTransactionBeginOptions;
@class PPRetailReceiptDestination;
@class PPRetailDeviceManager;
@class PPRetailSignatureReceiver;
@class PPRetailReceiptOptionsViewContent;
@class PPRetailReceiptEmailEntryViewContent;
@class PPRetailReceiptSMSEntryViewContent;
@class PPRetailReceiptViewContent;
@class PPRetailOfflinePaymentStatus;
@class PPRetailOfflinePaymentInfo;
@class PPRetailOfflineTransactionRecord;
@class PPRetailQRCRecord;
@class PPRetailTokenExpirationHandler;
@class PPRetailCard;
@class PPRetailBatteryInfo;
@class PPRetailMagneticCard;
@class PPRetailDigitalCard;
@class PPRetailPaymentDevice;
@class PPRetailManuallyEnteredCard;
@class PPRetailDeviceUpdate;
@class PPRetailCardInsertedHandler;
@class PPRetailDeviceStatus;
@class PPRetailPayer;
@class PPRetailDigitalCardInfo;
@class PPRetailTransactionRecord;
@class PPRetailVaultRecord;
@class PPRetailAuthorizedTransaction;
@class PPRetailPage;
@class PPRetailDiscoveredCardReader;
@class PPRetailCardReaderScanAndDiscoverOptions;
@class PPRetailDeviceConnectorOptions;
@class PPRetailReaderConfiguration;
@class PPRetailSimulationOptions;

/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
/**
 * TransactionOptions provides the list of customizations for a given transaction
 */
@interface PPRetailTransactionBeginOptions : PPRetailObject
/**
 * Show a payment prompt on the card reader's screen (if available) to
 * indicate that the customer/cashier should insert, swipe or tap a card
 */
@property (nonatomic,assign) BOOL showPromptInCardReader;/**
 * Show a payment prompt in-app to indicate that the customer/cahsier should
 * insert, swipe or tap a card
 */
@property (nonatomic,assign) BOOL showPromptInApp;/**
 * Use this property to set the preferred list of form factors for the
 * transaction. The actual list of form factors that will be used for a transaction will be an intersection of
 * available form factors and preferred list
 */
@property (nonatomic,strong,nullable) NSArray* preferredFormFactors;/**
 * Set the flag if the tipping on the reader is enabled
 */
@property (nonatomic,assign) BOOL tippingOnReaderEnabled;/**
 * Set the flag if you want to enable quickChip option
 */
@property (nonatomic,assign) BOOL quickChipEnabled;/**
 * Set the type of payment, default value is card
 */
@property (nonatomic,assign) PPRetailTransactionBeginOptionsPaymentTypes paymentType;/**
 * manually entered card details
 */
@property (nonatomic,strong,nullable) PPRetailCard* manualCard;/**
 * Digital Card information
 */
@property (nonatomic,strong,nullable) PPRetailDigitalCard* digitalCard;/**
 * Set the flag if the amount based tipping type used, otherwise, percentage based used
 */
@property (nonatomic,assign) BOOL amountBasedTipping;/**
 * Setting this to true will only authorize the transaction and a payment will NOT be taken.
 * The money will be moved only when a capture call is made on an authorized transaction.
 */
@property (nonatomic,assign) BOOL isAuthCapture;/**
 * Vaulting service provider
 */
@property (nonatomic,assign) PPRetailTransactionBeginOptionsVaultProvider vaultProvider;/**
 * Order Id provided by PayPal Order creation API
 */
@property (nonatomic,strong,nullable) NSString* paypalOrderId;/**
 * Vaulting action to take
 */
@property (nonatomic,assign) PPRetailTransactionBeginOptionsVaultType vaultType;/**
 * The customer id with the specified Vaulting Service Provider
 */
@property (nonatomic,strong,nullable) NSString* vaultCustomerId;/**
 * Reserved for restricted use
 */
@property (nonatomic,strong,nullable) NSString* tag;/**
 * QRC payment service provider
 */
@property (nonatomic,strong,nullable) NSString* qrcProvider;/**
 * Set the flag if you want to enable qrc payment with UIs for Paypal and Venmo providers
 */
@property (nonatomic,assign) BOOL qrcPromptEnabled;/**
 * Set the flag to take signature on eligible card readers
 */
@property (nonatomic,assign) BOOL signatureOnCardReader;

- (instancetype _Nullable)init;
    




-(NSString* _Nullable)getAllTags;

/**
 * Add a tag if not present to the list of tags
 */
-(void)addTag:(NSString* _Nullable)newTag;

/**
 * Remove tag from the list of tags
 */
-(void)removeTag:(NSString* _Nullable)removeTag;




@end