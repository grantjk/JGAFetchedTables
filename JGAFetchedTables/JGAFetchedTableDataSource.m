//
//  HMSFetchedTableDataSource.m
//  WellxProviders
//
//  Created by John Grant on 2013-06-06.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import "JGAFetchedTableDataSource.h"
#import "JGADataFetcher.h"

@implementation JGAFetchedTableDataSource

- (void)dealloc {
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    return [self initWithTableView:tableView delegate:nil];
}

- (instancetype)initWithTableView:(UITableView *)tableView delegate:(id<JGAFetchedTableDataSourceDelegate>)delegate {
    self = [super init];
    if (self) {
        [self registerCellClassesOnTableView:tableView];
        self.tableView = tableView;
        self.delegate = delegate;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.rowAnimationType = UITableViewRowAnimationAutomatic;
    }
    return self;
}

- (void)registerCellClassesOnTableView:(UITableView *)tableView {
    // noop
}

- (NSUInteger)countOfObjects {
    return [self.fetcher countOfObjects];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetcher countOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetcher countOfObjectsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Good idea to override this in subclass
    
    static NSString *CellIdentifier = @"ca.wellx.fetchedTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.fetcher objectAtIndexPath:indexPath];
    [self.delegate fetchedDataSource:self didSelectObject:object];
}

#pragma mark - HMSDataFetcherDelegate

- (BOOL)shouldForwardResultsToTableView {
    return self.tableView.dataSource == self;
}

- (void)fetcherWillStartUpdating:(JGADataFetcher *)fetcher {
    if ([self shouldForwardResultsToTableView]) {
        [self.tableView beginUpdates];
    }
}

- (void)fetcher:(JGADataFetcher *)fetcher didInsertSectionAtIndex:(NSUInteger)index {
    if ([self shouldForwardResultsToTableView]) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        [self.tableView insertSections:indexSet withRowAnimation:self.rowAnimationType];
    }
}

- (void)fetcher:(JGADataFetcher *)fetcher didDeleteSectionAtIndex:(NSUInteger)index {
    if ([self shouldForwardResultsToTableView]) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        [self.tableView deleteSections:indexSet withRowAnimation:self.rowAnimationType];
    }
}

- (void)fetcher:(JGADataFetcher *)fetcher didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldForwardResultsToTableView]) {
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:self.rowAnimationType];
    }
}

- (void)fetcher:(JGADataFetcher *)fetcher didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldForwardResultsToTableView]) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:self.rowAnimationType];
    }
}

- (void)fetcher:(JGADataFetcher *)fetcher didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldForwardResultsToTableView]) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:self.rowAnimationType];
    }
}

- (void)fetcher:(JGADataFetcher *)fetcher didMoveObject:(id)object fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if ([self shouldForwardResultsToTableView]) {
        [self.tableView deleteRowsAtIndexPaths:@[fromIndexPath] withRowAnimation:self.rowAnimationType];
        [self.tableView insertRowsAtIndexPaths:@[toIndexPath] withRowAnimation:self.rowAnimationType];
    }
}

- (void)fetcherDidEndUpdating:(JGADataFetcher *)fetcher {
    if ([self shouldForwardResultsToTableView]) {
        [self.tableView endUpdates];
        
        if ([self.fetcher countOfObjects] == 0) {
            [_delegate fetchedDataSourceDidReturnNoResults:self];
        }
    }else{
        if ([self.fetcher countOfObjects] > 0) {
            [_delegate fetchedDataSourceDidFindResults:self];
        }
    }
}
@end
