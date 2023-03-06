//
//  ADJResultFail.m
//  Adjust
//
//  Created by Pedro Silva on 01.03.23.
//  Copyright © 2023 Adjust GmbH. All rights reserved.
//

#import "ADJResultFail.h"

#import "ADJConstants.h"
#import "ADJUtilF.h"
#import "ADJUtilConv.h"

#pragma mark Fields
#pragma mark - Public properties
/*
 @property (nonnull, readonly, strong, nonatomic) NSString *message;
 @property (nullable, readonly, strong, nonatomic) NSDictionary<NSString *, id> *params;
 @property (nullable, readonly, strong, nonatomic) NSError *error;
 @property (nullable, readonly, strong, nonatomic) NSException *exception;
 */

@implementation ADJResultFail
#pragma mark Instantiation
- (nonnull instancetype)initWithMessage:(nonnull NSString *)message
                                 params:(nullable NSDictionary<NSString *, id> *)params
                                  error:(nullable NSError *)error
                              exception:(nullable NSException *)exception
{
    self = [super init];
    _message = message;
    _params = params;
    _error = error;
    _exception = exception;

    return self;
}

- (nullable instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark Public API
- (nonnull NSDictionary<NSString *, id> *)foundationDictionary {
    NSMutableDictionary *_Nonnull resultFailDictionary =
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.message, ADJLogMessageKey,  nil];

    if (self.error != nil) {
        [resultFailDictionary setObject:
         [ADJResultFail generateFoundationDictionaryFromNsError:self.error]
                                 forKey:ADJLogErrorKey];
    }
    if (self.exception != nil) {
        [resultFailDictionary setObject:
         [ADJResultFail generateFoundationDictionaryFromNsException:self.exception]
                                 forKey:ADJLogExceptionKey];
    }
    if (self.params != nil) {
        [resultFailDictionary setObject:self.params
                                 forKey:ADJLogParamsKey];
    }

    return resultFailDictionary;
}

#pragma mark Internal Methods
+ (nonnull NSDictionary<NSString *, id> *)generateFoundationDictionaryFromNsError:(nonnull NSError *)nsError {
    NSMutableDictionary *_Nonnull errorFoundationDictionary =
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:
         nsError.domain, @"domain",
         [ADJUtilF integerFormat:nsError.code], @"code",  nil];

    if (nsError.userInfo != nil) {
        [errorFoundationDictionary
         setObject:[ADJUtilConv convertToFoundationObject:nsError.userInfo]
         forKey:@"userInfo"];
    }

    return errorFoundationDictionary;
}

+ (nonnull NSDictionary<NSString *, id> *)generateFoundationDictionaryFromNsException:
    (nonnull NSException *)nsException
{
    NSMutableDictionary *_Nonnull exceptionFoundationDictionary =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     nsException.name, @"name", nil];

    if (nsException.reason != nil) {
        [exceptionFoundationDictionary setObject:nsException.reason
                                          forKey:@"reason"];
    }

    if (nsException.userInfo != nil) {
        [exceptionFoundationDictionary
         setObject:[ADJUtilConv convertToFoundationObject:nsException.userInfo]
         forKey:@"userInfo"];
    }

    return exceptionFoundationDictionary;
}

@end

#pragma mark Fields
@interface ADJResultFailBuilder ()
#pragma mark - Injected dependencies
@property (nonnull, readonly, strong, nonatomic) NSString *message;

#pragma mark - Internal variables
@property (nullable, readwrite, strong, nonatomic) NSMutableDictionary<NSString *, id> *paramsMut;
@property (nullable, readwrite, strong, nonatomic) NSError *error;
@property (nullable, readwrite, strong, nonatomic) NSException *exception;
@end

@implementation ADJResultFailBuilder
#pragma mark Instantiation
- (nonnull instancetype)initWithMessage:(nonnull NSString *)message {
    self = [super init];
    _message = message;

    _paramsMut = nil;
    _error = nil;
    _exception = nil;

    return self;
}

- (nullable instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark Public API
- (void)withError:(nonnull NSError *)error {
    self.error = error;
}
- (void)withException:(nonnull NSException *)exception {
    self.exception = exception;
}
- (void)withKey:(nonnull NSString *)key
          value:(nullable id)value
{
    if (self.paramsMut == nil) {
        self.paramsMut = [[NSMutableDictionary alloc] init];
    }

    [self.paramsMut setObject:[ADJUtilF idOrNsNull:value]
                       forKey:key];
}

- (nonnull ADJResultFail *)build {
    return [[ADJResultFail alloc] initWithMessage:self.message
                                           params:
            self.paramsMut != nil ? [self.paramsMut copy] : nil
                                            error:self.error
                                        exception:self.exception];
}

@end
