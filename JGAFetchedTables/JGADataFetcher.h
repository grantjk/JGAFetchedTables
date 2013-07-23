//
//  HMSDataFetcher.h
//  WellxProviders
//
//  Created by John Grant on 2013-06-06.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JGADataFetcherDelegate.h"

@interface JGADataFetcher : NSObject

@property (nonatomic, assign) id <JGADataFetcherDelegate> delegate;

// Override this in subclass for easy creation
+ (instancetype)fetcherWithDelegate:(id<JGADataFetcherDelegate>)delegate;

- (instancetype)initForClass:(Class)klass
                   predicate:(NSPredicate *)predicate
                      sortBy:(NSString *)sortTerms
                    delegate:(id<JGADataFetcherDelegate>)delegate;

- (instancetype)initForClass:(Class)klass
                   predicate:(NSPredicate *)predicate
                      sortBy:(NSString *)sortTerms
                   ascending:(BOOL)ascending
                     groupBy:(NSString *)groupBy
                    delegate:(id<JGADataFetcherDelegate>)delegate;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)sectionNameAtIndex:(NSUInteger)sectionIndex;
- (NSArray *)sectionIndexTitles;
- (NSArray *)fetchedObjects;
- (NSUInteger)countOfSections;
- (NSUInteger)countOfObjectsInSection:(NSUInteger)sectionIndex;
- (NSUInteger)countOfObjects;

@end
