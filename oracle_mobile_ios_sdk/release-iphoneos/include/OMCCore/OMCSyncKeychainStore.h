//
//  OMCSyncKeychainWrapper.h
//  OMCSynchronization
//
//  Created by Jay Vachhani on 11/20/14.
//  Copyright (c) 2014 Oracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

/**
 * Secure storage wrapper for iOS keychain.
 */
@interface OMCSyncKeychainStore : NSObject

/*
 * Shared keychain store for perticular service as specified.
 @param service name of the store service
 @return class object
 */
+ (OMCSyncKeychainStore *) sharedKeychainStoreWithService:(NSString *) service;

/*
 * Sets a string securely.
 @param aString value to be store
 @param key key for the value
 */
- (void) setKeychainObject:(NSString *) aString forKey:(NSString *) key;

/*
 * Gets a string securely.
 @param key key for the value
 @return returns a value
 */
- (NSString *) getKeychainObjectForKey:(NSString *) key;

/*
 * Remove all the storage for specified service name.
 @param service name of the store service
 @return boolean result
 */
- (BOOL) removeAllItemsForService:(NSString *)service;

/*
 * Remove an item from the storage for specified service name.
 @param key key for the value
 @param service name of the store service
 @return boolean result
 */
- (BOOL) removeItemForKey:(NSString *)key service:(NSString *)service;

@end
