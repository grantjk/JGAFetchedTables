//
//  HMSCFetchedTableDataSourceDelegate.h
//  WellxProviders
//
//  Created by John Grant on 2013-06-07.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JGAFetchedTableDataSource;
@protocol JGAFetchedTableDataSourceDelegate <NSObject>

/**
 This method is called when the datasource is not the current table's datasource
 But the datasource has found some new information. You can use this callback
 to remove empty data sources on the tableview and display the appropriate
 datasource
*/
- (void)fetchedDataSourceDidFindResults:(JGAFetchedTableDataSource *)dataSource;

// Use this method to change the table data source to an empty data source for example
// This is called when the controller changes content and there is nothing left
- (void)fetchedDataSourceDidReturnNoResults:(JGAFetchedTableDataSource *)dataSource;

// This method is called when a row in the table is selected. Use this method to
// push a detail view controller for the given object or perform some other action
- (void)fetchedDataSource:(JGAFetchedTableDataSource *)dataSource didSelectObject:(id)object;

@end
