#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CryptoppECC.h"
#import "CryptoppECDSA.h"
#import "CryptoppHash.h"
#import "Curve.h"

FOUNDATION_EXPORT double CryptoppECCVersionNumber;
FOUNDATION_EXPORT const unsigned char CryptoppECCVersionString[];

