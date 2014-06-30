//
//  ASHViewModel.h
//  NSFetchedResultsController-MVVM
//
//  Created by Ash Furrow on 2014-06-30.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "RVMViewModel.h"

// Based off of https://github.com/AshFurrow/C-41/blob/master/C-41/ASHMasterViewModel.h
@interface ASHViewModel : RVMViewModel

-(instancetype)initWithManagedObjectContext:(id)moc;

@property (nonatomic, readonly) RACSignal *willChangeContentSignal;
@property (nonatomic, readonly) RACSignal *itemChangeSignal;
@property (nonatomic, readonly) RACSignal *sectionChangeSignal;
@property (nonatomic, readonly) RACSignal *didChangeContentSignal;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;

@end
