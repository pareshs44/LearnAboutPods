#import "TDTNumberFormatterUtil.h"

@implementation TDTNumberFormatterUtil

+ (NSString *)centesimalFormatStringForCurrencyCode:(NSString *)currencyCode {
  NSDictionary *centesimalFormatStringMap =
  @{
    @"USD": @"%@¢"
    ,@"GBP": @"%@p"
    ,@"AUD": @"%@¢"
    ,@"EUR": @"%@c"
    ,@"CAD": @"%@¢"
    ,@"SGD": @"%@S¢"
    ,@"CHF": @"%@Rp"
    };
  return [centesimalFormatStringMap objectForKey:currencyCode];
}

+ (NSString *)formattedCentesimalCurrencyValue:(NSDecimalNumber *)value
                                    inCurrency:(NSString *)currencyCode {
  NSString *formatString = [self centesimalFormatStringForCurrencyCode:currencyCode];
  if (formatString) {
    NSDecimalNumber *hundred = [NSDecimalNumber decimalNumberWithMantissa:100
                                                                 exponent:0
                                                               isNegative:NO];
    NSDecimalNumber *newValue = [value decimalNumberByMultiplyingBy:hundred];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfEven];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:0];
    NSString *stringValue = [formatter stringFromNumber:newValue];
    return [self stripWhiteSpaceChars:[NSString stringWithFormat:formatString, stringValue]];
  }
  return nil;
}

/** We will find all currency symbols on en_US locale base. We are doing it coz we want to
 explicitely show the prefix of the local currency if it is same as $.
 e.g., For an Australian user, if we find out currency symbol on his own locale, we will get $ only.
 But, we want to show AU$ and keep $ only for USD.
 At the same time, we will use user's system locale for formatting the value.
 */
+ (NSString *)formattedOriginalCurrencyStringForValue:(NSDecimalNumber *)value
                                           inCurrency:(NSString *)currencyCode {
  NSLocale *USLocale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
  NSString *internationalCurrencySymbol = [USLocale displayNameForKey:NSLocaleCurrencySymbol
                                                                value:currencyCode];

  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setLocale:[NSLocale currentLocale]];
  [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [numberFormatter setCurrencySymbol:internationalCurrencySymbol];
  [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfEven];
  [numberFormatter setMaximumFractionDigits:2];
  [numberFormatter setMinimumFractionDigits:2];
  return [self stripWhiteSpaceChars:[numberFormatter stringFromNumber:value]];
}

+ (NSString *)humanReadableCurrencyStringForValue:(NSDecimalNumber *)value
                                       inCurrency:(NSString *)currencyCode
                                    tryCentesimal:(BOOL)tryCentesimal {
  if (tryCentesimal) {
    NSString *centesimal = [self formattedCentesimalCurrencyValue:value
                                                       inCurrency:currencyCode];
    if (centesimal) {
      return centesimal;
    }
  }
  return [self formattedOriginalCurrencyStringForValue:value
                                            inCurrency:currencyCode];
}

+ (NSString *)humanReadableCurrencyStringInLocalCurrencyForDollarValue:(NSDecimalNumber *)dollarValue
                                                dollarConversationRate:(NSDecimalNumber *)conversionRate
                                            inCurrencyWithCurrencyCode:(NSString *)currencyCode
                                                         tryCentesimal:(BOOL)tryCentesimal {
  NSDecimalNumber *localCurrencyValue = [dollarValue decimalNumberByMultiplyingBy:conversionRate];
  NSString *localValueFormattedString = [self humanReadableCurrencyStringForValue:localCurrencyValue
                                                                       inCurrency:currencyCode
                                                                    tryCentesimal:tryCentesimal];
  return localValueFormattedString;
}

+ (NSString *)formattedCurrencyStringWithoutCurrencySymbolForValue:(NSDecimalNumber *)value {
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setLocale:[NSLocale currentLocale]];
  [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [numberFormatter setMinimumFractionDigits:2];
  [numberFormatter setMaximumFractionDigits:2];
  [numberFormatter setCurrencySymbol:@""];
  [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfEven];
  return [self stripWhiteSpaceChars:[numberFormatter stringFromNumber:value]];
}

+ (NSString *)stripWhiteSpaceChars:(NSString *)string {
  NSCharacterSet *completeWhiteSpaceCharSet = [NSCharacterSet characterSetWithCharactersInString:@"\u00a0\n "];
  NSString *strippedString = [[string componentsSeparatedByCharactersInSet:completeWhiteSpaceCharSet]
                              componentsJoinedByString:@""];
  return strippedString;
}

@end
