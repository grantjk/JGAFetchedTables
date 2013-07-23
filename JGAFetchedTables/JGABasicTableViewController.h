//
//  HMSCBasicTableViewController.h
//  WellxProviders
//
//  Created by John Grant on 2013-06-20.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGAFetchedTableDataSourceDelegate.h"
#import "SSPullToRefreshView.h"

@class JGAFetchedTableDataSource;
@class JGAEmptyTableDataSource;
@class JGALoadingTableDataSource;

@interface JGABasicTableViewController : UIViewController <JGAFetchedTableDataSourceDelegate, SSPullToRefreshViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JGAFetchedTableDataSource *dataSource;
@property (nonatomic, strong) JGAEmptyTableDataSource *emptyDataSource;
@property (nonatomic, strong) JGALoadingTableDataSource *loadingDataSource;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;


/**
 Call this method to register your fetched table data source.
 Typically, you should call this from your -viewDidLoad method
 because you need the tableView loaded to instantiate the data source.
*/
- (void)registerFetchedDataSource:(JGAFetchedTableDataSource *)dataSource;

/**
 You can customize the text to display in the empty screen.
 The default is 'Nothing to display'
*/
- (NSString *)emptyDataSourceText;

/**
 Override this method to remove show or hide the pull to refresh view
 The default is YES
*/
- (BOOL)shouldAllowPullToRefresh;

/**
 Override this to provide a different pull to refresh content view
 The default is basic
*/
- (UIView <SSPullToRefreshContentView> *)pullToRefreshContentView;

///**
// Convenience method to add the menu button to the upper left
//*/
//- (void)addMenuButton;

/** 
 Will set up the view controller by:
 - adding the loading data source if necessary
 - coordinating with pull to refresh
 - performing Refresh through use of call backs
 
 @returns the date that represents the requests unique identifier
*/
- (NSDate *)refresh;

/**
 These are call back hooks from the refresh method
 If you override willStart or didFinish, it's probably a good idea to call super
*/
- (void)willStartRefreshing;
- (void)didFinishRefreshing:(NSError *)error requestIdentifier:(NSDate *)date;

/**
 Override this method in your subclass to make the appropriate network call.
 You should make sure you call the refreshCompletion block somewhere in your method.
 
 The default implementation of this method just calls the completion block
 
 @param refreshCompletion The block to be called when the refresh request completes
 
 @return The JSON request operation created by the refresh request
 
*/
- (NSOperation *)didRequestRefreshRequestWithCompletion:(void(^)(NSError *error))refreshCompletion;

/** 
 Convenience method to replace the current data source.
 Will call -reloadData on the tableView after changing
*/
- (void)showDataSource:(id<UITableViewDataSource, UITableViewDelegate>)dataSource;

@end
