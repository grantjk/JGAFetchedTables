//
//  HMSDataFetcher.m
//  WellxProviders
//
//  Created by John Grant on 2013-06-06.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import "JGADataFetcher.h"

@interface JGADataFetcher () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSMutableIndexSet *inserstedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *deletedSectionIndexes;

@end

@implementation JGADataFetcher

+ (instancetype)fetcherWithDelegate:(id<JGADataFetcherDelegate>)delegate {
    NSAssert(NO, @"this class should be overriden in subclass");
    
    // Override in subclass
    return nil;
}

- (instancetype)initForClass:(Class)klass predicate:(NSPredicate *)predicate sortBy:(NSString *)sortTerms delegate:(id<JGADataFetcherDelegate>)delegate {
    return [self initForClass:klass predicate:predicate sortBy:sortTerms ascending:YES groupBy:nil delegate:delegate];
}

- (instancetype)initForClass:(Class)klass
                   predicate:(NSPredicate *)predicate
                      sortBy:(NSString *)sortTerms
                   ascending:(BOOL)ascending
                     groupBy:(NSString *)groupBy
                    delegate:(id<JGADataFetcherDelegate>)delegate
{

    self = [super init];
    if (self) {
        self.fetchedResultsController = [klass fetchAllSortedBy:sortTerms
                                                      ascending:ascending
                                                  withPredicate:predicate
                                                        groupBy:groupBy
                                                       delegate:self];
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Accessors
- (NSArray *)fetchedObjects {
    return [self.fetchedResultsController fetchedObjects];
}
- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSUInteger)countOfSections {
    return [[self.fetchedResultsController sections] count];
}
- (NSArray *)sectionIndexTitles {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSString *)sectionNameAtIndex:(NSUInteger)sectionIndex {
    if (sectionIndex >= [[self.fetchedResultsController sections] count]) {
        return nil;
    }
    
    return [[[self.fetchedResultsController sections] objectAtIndex:sectionIndex] name];
}

- (NSUInteger)countOfObjectsInSection:(NSUInteger)sectionIndex {
    return [[[self.fetchedResultsController sections] objectAtIndex:sectionIndex] numberOfObjects];
}

- (NSUInteger)countOfObjects {
    return [[self.fetchedResultsController fetchedObjects] count];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.delegate fetcherWillStartUpdating:self];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.inserstedSectionIndexes addIndex:sectionIndex];
            [self.delegate fetcher:self didInsertSectionAtIndex:sectionIndex];
            break;
        case NSFetchedResultsChangeDelete:
            [self.deletedSectionIndexes addIndex:sectionIndex];
            [self.delegate fetcher:self didDeleteSectionAtIndex:sectionIndex];
            break;
    }    
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            if (![self.inserstedSectionIndexes containsIndex:newIndexPath.section]) {
                [self.delegate fetcher:self didInsertObject:object atIndexPath:newIndexPath];
            }
            break;
        case NSFetchedResultsChangeDelete:
            if (![self.deletedSectionIndexes containsIndex:indexPath.section]) {
                [self.delegate fetcher:self didDeleteObject:object atIndexPath:indexPath];
            }
            break;
        case NSFetchedResultsChangeUpdate:
            [self.delegate fetcher:self didChangeObject:object atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.delegate fetcher:self didMoveObject:object fromIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    self.inserstedSectionIndexes = nil;
    self.deletedSectionIndexes = nil;
    [self.delegate fetcherDidEndUpdating:self];    
}

#pragma mark - Lazy Loaders
- (NSMutableIndexSet *)inserstedSectionIndexes {
    if (!_inserstedSectionIndexes) {
        self.inserstedSectionIndexes = [NSMutableIndexSet indexSet];
    }
    return _inserstedSectionIndexes;
}
- (NSMutableIndexSet *)deletedSectionIndexes {
    if (!_deletedSectionIndexes) {
        self.deletedSectionIndexes = [NSMutableIndexSet indexSet];
    }
    return _deletedSectionIndexes;
}

@end
