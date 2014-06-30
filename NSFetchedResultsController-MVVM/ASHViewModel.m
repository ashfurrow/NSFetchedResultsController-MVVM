//
//  ASHViewModel.m
//  NSFetchedResultsController-MVVM
//
//  Created by Ash Furrow on 2014-06-30.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "ASHViewModel.h"

@interface ASHViewModel ()

@property (nonatomic, strong) RACSignal *willChangeContentSignal;
@property (nonatomic, strong) RACSignal *itemChangeSignal;
@property (nonatomic, strong) RACSignal *sectionChangeSignal;
@property (nonatomic, strong) RACSignal *didChangeContentSignal;

@end

@implementation ASHViewModel

-(instancetype)initWithManagedObjectContext:(id)moc {
    self = [super init];
    if (self == nil) return nil;
    
    self.willChangeContentSignal = [[RACSubject subject] setNameWithFormat:@"ASHViewModel willChangeContentSignal"];
    self.itemChangeSignal = [[RACSubject subject] setNameWithFormat:@"ASHViewModel itemChangeSignal"];
    self.sectionChangeSignal = [[RACSubject subject] setNameWithFormat:@"ASHViewModel sectionChangeSignal"];
    self.didChangeContentSignal = [[RACSubject subject] setNameWithFormat:@"ASHViewModel didChangeContentSignal"];
    
    @weakify(self)
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
        // You'd need an actual fetched results controller
        [self.fetchedResultsController performFetch:nil];
    }];
    
    return self;
}

#pragma mark - Public Methods

-(NSInteger)numberOfSections {
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [(id<RACSubscriber>)(self.willChangeContentSignal) sendNext:nil];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    [(id<RACSubscriber>)(self.itemChangeSignal) sendNext:RACTuplePack(indexPath, @(type), newIndexPath)];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    [(id<RACSubscriber>)(self.sectionChangeSignal) sendNext:RACTuplePack(@(sectionIndex), @(type))];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [(id<RACSubscriber>)(self.didChangeContentSignal) sendNext:nil];
}

@end
