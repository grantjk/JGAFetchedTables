//
//  JGAAppDelegate.h
//  JGAFetchedTables
//
//  Created by John Grant on 2013-07-23.
//  Copyright (c) 2013 JGApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
