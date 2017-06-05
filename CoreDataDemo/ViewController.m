//
//  ViewController.m
//  CoreDataDemo
//
//  Created by iOS-School-1 on 30.05.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataStack.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) CoreDataStack *coreDataStack;
@property (nonatomic, strong) NSFetchRequest *request;
@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIAlertController *userInput;

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.coreDataStack = [CoreDataStack stack];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_coreDataStack save];
    [self createPerson];
    
    NSArray<Person *> *persons = self.frc.fetchedObjects;
    NSLog(@"%@", persons);
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [self setupNavBar];
    _frc.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identificator"];
    // asyncRequest.fetchRequest = request;
    [self setupAlertController];
}

- (void)setupAlertController {
    self.userInput = [UIAlertController alertControllerWithTitle: @"New Person"
                                                         message: @"Input full name and age"
                                                  preferredStyle:UIAlertControllerStyleAlert];
    [self.userInput addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"First Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [self.userInput addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Last Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [self.userInput addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Age";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [self.userInput addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray *textfields = self.userInput.textFields;
        UITextField *firstNameField = textfields[0];
        UITextField *lastNameField = textfields[1];
        UITextField *ageField = textfields[2];
        [self createPersonWithFirstName:firstNameField.text
                               LastName:lastNameField.text
                                 AndAge:(uint16_t)ageField.text.intValue];
    }]];
}

- (void)setupNavBar {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableView)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createPerson)];
    self.navigationItem.rightBarButtonItem = add;
}

- (void)asyncRequest:(NSFetchRequest *)request {
    NSError *err = nil;
    NSAsynchronousFetchRequest *asyncRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:^(NSAsynchronousFetchResult * _Nonnull result) {
        NSLog(@"%@", result.finalResult);
    }];
    [_coreDataStack.coreDataContext executeRequest:asyncRequest error:&err];
    NSLog(@"%@", err.localizedDescription);
}

- (NSFetchRequest *)syncRequest {
    _request.predicate = [NSPredicate predicateWithFormat:@"age==16"];
    _request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]];
    _request.fetchBatchSize = 15;
    NSError *err = nil;
    NSArray<Person*> *persons = [_coreDataStack.coreDataContext executeFetchRequest:_request error:&err];
    NSLog(@"%@", err.localizedDescription);
    NSLog(@"%@", persons);
    
    return _request;
}

- (void)removePerson:(Person*)person {
    [_coreDataStack.coreDataContext deleteObject:person];
    [_coreDataStack save];
}

- (void)createPerson {
    [_coreDataStack.coreDataContext performBlock:^{
        Person *person = (id)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self->_coreDataStack.coreDataContext];
        person.firstName = @"New";
        person.lastName = @"Newanov";
        person.age = 80;
        [_coreDataStack save];
    }];
}

- (void)createPersonWithFirstName: (NSString *)firstName LastName: (NSString *)lastName AndAge: (uint16_t)age{
    [_coreDataStack.coreDataContext performBlock:^{
        Person *person = (id)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self->_coreDataStack.coreDataContext];
        person.firstName = firstName;
        person.lastName = lastName;
        person.age = age;
        [_coreDataStack save];
    }];
}

- (NSFetchRequest*)fetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    request.predicate = [NSPredicate predicateWithFormat:@"age > 10"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]];
    request.fetchBatchSize = 10;
    return request;
}

- (NSArray<Person*>*)findPerson {
    NSError *err = nil;
    NSArray<Person *>*persons = [_coreDataStack.coreDataContext executeFetchRequest:[self fetchRequest] error:&err];
    NSLog(@"%@", err.localizedDescription);
    NSLog(@"%@", persons);
    
    return persons;
}

- (NSFetchedResultsController *)frc {
    if (_frc) return _frc;
    
    NSFetchRequest *request = [self fetchRequest];
    NSManagedObjectContext *ctx = _coreDataStack.coreDataContext;
    _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:ctx sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    [_frc performFetch:&error];
    return _frc;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identificator" forIndexPath:indexPath];
    Person *p = [_frc objectAtIndexPath:indexPath];
    NSString *str = [[NSString alloc] initWithFormat:@"%@ %@ %hd",p.firstName, p.lastName, p.age];
    cell.textLabel.text = str;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_frc sections] objectAtIndex:section].numberOfObjects;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [_tableView cellForRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)editTableView {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete){
        Person *perosn = _frc.fetchedObjects[indexPath.row];
        [self removePerson:perosn];
    } else if (editingStyle==UITableViewCellEditingStyleInsert){
        //Use non-modal alert dialog to add a person with specified data
        [self presentViewController:self.userInput animated:YES completion:nil];
    }
    [self.tableView reloadData];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
