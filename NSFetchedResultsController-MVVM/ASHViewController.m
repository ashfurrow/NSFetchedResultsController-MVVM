//
//  ASHViewController.m
//  NSFetchedResultsController-MVVM
//
//  Created by Ash Furrow on 2014-06-30.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHViewController.h"
#import "ASHViewModel.h"

#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ASHViewController ()

// This would need to be set by someone
@property (nonatomic, strong) ASHViewModel *viewModel;

@end

@implementation ASHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    [self.viewModel.willChangeContentSignal subscribeNext:^(id _) {
        @strongify(self);
        [self.tableView beginUpdates];
    }];
    
    [self.viewModel.itemChangeSignal subscribeNext:^(RACTuple *params) {
        @strongify(self);
        RACTupleUnpack(NSIndexPath *indexPath, NSNumber *typeNumber, NSIndexPath *newIndexPath) = params;
        NSFetchedResultsChangeType type = typeNumber.unsignedIntegerValue;
        
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSFetchedResultsChangeMove:
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;
        }
    }];
    
    [self.viewModel.sectionChangeSignal subscribeNext:^(RACTuple *params) {
        @strongify(self);
        
        RACTupleUnpack(NSNumber *sectionIndexNumber, NSNumber *typeNumer) = params;
        NSUInteger sectionIndex = sectionIndexNumber.unsignedIntegerValue;
        NSUInteger type = typeNumer.unsignedIntegerValue;
        
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }];
    
    [self.viewModel.didChangeContentSignal subscribeNext:^(id _) {
        @strongify(self);
        [self.tableView endUpdates];
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // configure cell
    return cell;
}


@end
