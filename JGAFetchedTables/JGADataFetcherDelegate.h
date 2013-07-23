//
//  HMSCDataFetcherProtocol.h
//  WellxProviders
//
//  Created by John Grant on 2013-06-06.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JGADataFetcher;

@protocol JGADataFetcherDelegate <NSObject>
- (void)fetcherWillStartUpdating:(JGADataFetcher *)fetcher;
- (void)fetcher:(JGADataFetcher *)fetcher didInsertSectionAtIndex:(NSUInteger)index;
- (void)fetcher:(JGADataFetcher *)fetcher didDeleteSectionAtIndex:(NSUInteger)index;
- (void)fetcher:(JGADataFetcher *)fetcher didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)fetcher:(JGADataFetcher *)fetcher didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)fetcher:(JGADataFetcher *)fetcher didMoveObject:(id)object fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)fetcher:(JGADataFetcher *)fetcher didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)fetcherDidEndUpdating:(JGADataFetcher *)fetcher;

@end
