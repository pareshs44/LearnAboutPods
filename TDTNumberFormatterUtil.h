/**
 Utility class with methods for formatting numbers in user's locale.
 */
#import <Foundation/Foundation.h>

@interface TDTNumberFormatterUtil : NSObject

/**
 Converts passed number value to a human readable formatted currency value in user's locale
 with the currency symbol.

 @param value Value which is to be converted.
 @param currencyCode Three letter currency code. e.g., GBP, INR.
 @param tryCentesimal To specify whether value should be formatted to the decimal
 currency value, if available. e.g. ¢ for USD.
 @note Centesimal currencies are supported for limited currencies.
 @note decimal values are formatted with 0-1 decimal points and normal currency
 values are formatted with 2 decimal points.

 @returns formatted string with currency symbol for the specified value.
 */
+ (NSString *)humanReadableCurrencyStringForValue:(NSDecimalNumber *)value
                                       inCurrency:(NSString *)currencyCode
                                    tryCentesimal:(BOOL)tryCentesimal;

/**
 Convenience method to convert passed dollar value to a human readable formatted
 currency using humanReadableCurrencyStringForValue:inCurrency:tryCentesimal:

 @param dollarValue Value in dollars which is to be converted.
 @param conversionRate Conversion rate of the currency to dollar.
 @param currencyCode Three letter currency code. e.g., GBP, INR.
 @param tryCentesimal To specify whether value should be formatted to the decimal
 currency value, if available. e.g. ¢ for USD.
 @note Centesimal currencies are supported for limited currencies.

 @returns formatted string with currency symbol for the specified value.
 */
+ (NSString *)humanReadableCurrencyStringInLocalCurrencyForDollarValue:(NSDecimalNumber *)dollarValue
                                                dollarConversationRate:(NSDecimalNumber *)conversionRate
                                            inCurrencyWithCurrencyCode:(NSString *)currencyCode
                                                         tryCentesimal:(BOOL)tryCentesimal;

/**
 Converts passed number value to a formatted currency value in user's locale
 without any currency symbol.

 @param value Value which is to be converted.
 @note Returns the value with 2 decimal points.

 @returns formatted string in NSNumberFormatterCurrencyStyle for the specified value.
 */
+ (NSString *)formattedCurrencyStringWithoutCurrencySymbolForValue:(NSDecimalNumber *)value;

@end
