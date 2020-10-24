/**
 * PPRetailDeviceConnectorOptions.h
 *
 * DO NOT EDIT THIS FILE! IT IS AUTOMATICALLY GENERATED AND SHOULD NOT BE CHECKED IN.
 * Generated from: dist/paymentDevice/DeviceConnectorOptions.js
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
 * Device connector options to send it over to native side
 */
@interface PPRetailDeviceConnectorOptions : PPRetailObject
/**
 * Card reader name as it shows up in the bluetooth settings page
 */
@property (nonatomic,strong,nullable) NSString* readerId;/**
 * Card reader description
 */
@property (nonatomic,strong,nullable) NSString* readerDescription;/**
 * Image identifier
 */
@property (nonatomic,strong,nullable) NSString* readerImgId;/**
 * Bluetooth card reader hardware mac address
 */
@property (nonatomic,strong,nullable) NSString* hardwareAddress;/**
 * Title for last reader used prompt
 */
@property (nonatomic,strong,nullable) NSString* titleLastReaderUsed;/**
 * Title for connected prompt
 */
@property (nonatomic,strong,nullable) NSString* titleConnected;/**
 * Connecting message
 */
@property (nonatomic,strong,nullable) NSString* msgConnecting;/**
 * Check Reader message
 */
@property (nonatomic,strong,nullable) NSString* msgCheckReader;/**
 * Turn On BlueTooth message
 */
@property (nonatomic,strong,nullable) NSString* msgTurnOnBlueTooth;/**
 * Connection failed message
 */
@property (nonatomic,strong,nullable) NSString* msgConnectionFailed;/**
 * Find Failed message
 */
@property (nonatomic,strong,nullable) NSString* msgFindFailed;/**
 * Connect button text
 */
@property (nonatomic,strong,nullable) NSString* btnConnect;/**
 * Find another button text
 */
@property (nonatomic,strong,nullable) NSString* btnFindAnother;/**
 * Done button text
 */
@property (nonatomic,strong,nullable) NSString* btnDone;/**
 * Switch card reader button text
 */
@property (nonatomic,strong,nullable) NSString* btnSwitchCardReader;/**
 * Try again button text
 */
@property (nonatomic,strong,nullable) NSString* btnTryAgain;/**
 * Cancel button text
 */
@property (nonatomic,strong,nullable) NSString* btnCancel;





/**
 * Connect to the last active reader
 */
-(void)connectToLastReader;




/**
 * Add a listener for the onConnectionResult event
 * @returns PPRetailOnConnectionResultSignal an object that can be used to remove the listener when
 * you're done with it.
 */
-(PPRetailOnConnectionResultSignal _Nullable)addOnConnectionResultListener:(PPRetailOnConnectionResultEvent _Nullable)listener;

/**
 * Remove a listener for the onConnectionResult event given the signal object that was returned from addOnConnectionResultListener
 */
-(void)removeOnConnectionResultListener:(PPRetailOnConnectionResultSignal _Nullable)listenerToken;


@end
