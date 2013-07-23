//
//  HMSFetchedTableDataSource.h
//  WellxProviders
//
//  Created by John Grant on 2013-06-06.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGADataFetcherDelegate.h"
#import "JGAFetchedTableDataSourceDelegate.h"

@class JGADataFetcher;
@interface JGAFetchedTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, JGADataFetcherDelegate>
@property (nonatomic, assign) id <JGAFetchedTableDataSourceDelegate> delegate;

@property (nonatomic, strong) JGADataFetcher *fetcher;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) UITableViewRowAnimation rowAnimationType;

/**
 The designated initializer. 
 
 @param tableView The UITableView instance that will be associated with this datasource. This allows
 this datasource to register the appropriate classes and reuse identifiers.
 
*/
- (instancetype)initWithTableView:(UITableView *)tableView;

/** 
 The other desiginated initializer. Optionally set a delegate

 @param tableView The UITableView instance that will be associated with this datasource. This allows
 this datasource to register the appropriate classes and reuse identifiers.
 
 @param delegate The object you want to receive callbacks to. Typically the UIViewController instance.
*/
- (instancetype)initWithTableView:(UITableView *)tableView
                         delegate:(id<JGAFetchedTableDataSourceDelegate>)delegate;

/** 
 You override this method in your subclass to register cell classes and reuse identifers.
 The default implementation of this method does nothing.
 
 @param tableView The UITableView instance passed in as part of -initWithTableView
*/
- (void)registerCellClassesOnTableView:(UITableView *)tableView;

/** 
 Returns the number of objects returned from the fetcher
*/
- (NSUInteger)countOfObjects;



/* Force designated initializer */
- (id)init JGDesignatedInitializer(initWithTableView:);

@end
