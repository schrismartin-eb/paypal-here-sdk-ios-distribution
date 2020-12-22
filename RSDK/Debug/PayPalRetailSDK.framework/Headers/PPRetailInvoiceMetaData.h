/**
 * PPRetailInvoiceMetaData.h
 *
 * DO NOT EDIT THIS FILE! IT IS AUTOMATICALLY GENERATED AND SHOULD NOT BE CHECKED IN.
 * Generated from: node_modules/paypal-invoicing/lib/InvoiceMetaData.js
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
 * Invoice MetaData
 */
@interface PPRetailInvoiceMetaData : PPRetailObject
/**
 * Date when the resource was created. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSDate* createdDate;/**
 * Email address of the account that created the resource. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSString* createdBy;/**
 * Date when the resource was cancelled. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSDate* cancelledDate;/**
 * Actor who cancelled the resource. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSString* cancelledBy;/**
 * Date when the resource was last edited. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSDate* lastUpdatedDate;/**
 * Email address of the account that last
 * edited the resource. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSString* lastUpdatedBy;/**
 * Date when the resource was first sent. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSDate* firstSentDate;/**
 * Date when the resource was last sent. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSDate* lastSentDate;/**
 * Email address of the account that last sent the resource. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSString* lastSentBy;/**
 * URL representing the payer's view of the invoice. @readonly
 */
@property (nonatomic,strong,nullable,readonly) NSString* payerViewURL;








@end
