//
//  SentryBreadcrumb.h
//  Sentry
//
//  Created by Daniel Griesser on 22/05/2017.
//  Copyright © 2017 Sentry. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<Sentry/Sentry.h>)

#import <Sentry/SentryDefines.h>
#import <Sentry/SentrySerializable.h>

#else
#import "SentryDefines.h"
#import "SentrySerializable.h"
#endif

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Breadcrumb)
@interface SentryBreadcrumb : NSObject <SentrySerializable>

/**
 * Level of breadcrumb
 */
@property(nonatomic) enum SentryLevel level;

/**
 * Category of bookmark, can be any string
 */
@property(nonatomic, copy) NSString *category;

/**
 * NSDate when the breadcrumb happened
 */
@property(nonatomic, strong) NSDate *_Nullable timestamp;

/**
 * Type of breadcrumb, can be e.g.: http, empty, user, navigation
 * This will be used as icon of the breadcrumb
 */
@property(nonatomic, copy) NSString *_Nullable type;

/**
 * Message for the breadcrumb
 */
@property(nonatomic, copy) NSString *_Nullable message;

/**
 * Arbitrary additional data that will be sent with the breadcrumb
 */
@property(nonatomic, strong) NSDictionary<NSString *, id> *_Nullable data;

/**
 * Initializer for SentryBreadcrumb
 *
 * @param level SentryLevel
 * @param category String
 * @return SentryBreadcrumb
 */
- (instancetype)initWithLevel:(enum SentryLevel)level category:(NSString *)category;
- (instancetype)init;
+ (instancetype)new NS_UNAVAILABLE;

- (NSDictionary<NSString *, id> *)serialize;

@end

NS_ASSUME_NONNULL_END
