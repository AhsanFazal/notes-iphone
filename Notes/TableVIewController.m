//
//  TableVIewController.m
//

#import "TableVIewController.h"
#import "ViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface TableVIewController ()

@end

@implementation TableVIewController{
    NSInteger notesCount;
}

@synthesize imageView;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)animate{
    
    if(self.i){
        [imageView.layer removeAnimationForKey:@"rotationAnimation"];
    }else{
        
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 120 ];
        rotationAnimation.duration = 120;
        rotationAnimation.cumulative = YES;
        
        [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    
    self.i = !self.i;
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.navigationItem.title = @"NOTES";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped)];
    
    // Sync image
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SettingsButton"]];
    imageView.autoresizingMask = UIViewAutoresizingNone;
    imageView.contentMode = UIViewContentModeCenter;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 26, 26);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(settingsTapped) forControlEvents:UIControlEventTouchUpInside];
    imageView.center = button.center;
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barItem;
}

-(void) addTapped{
    ViewController *controller = [[ViewController alloc] initWithNoteIndex:notesCount];
    notesCount++;
    [[NSUserDefaults standardUserDefaults] setInteger:notesCount forKey:@"notesCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)settingsTapped{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    SettingsViewController *vc = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    notesCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"notesCount"];
    NSLog(@"Reloaded notesCount");
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    // TODO: remove (DEBUGGING)
//    [NSTimer scheduledTimerWithTimeInterval:1.0
//    target:self
//    selector:@selector(settingsTapped)
//    userInfo:nil
//    repeats:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"note_%li",(long)indexPath.row]];
    if([value isEqual:@""]){ value = @"Untitled note"; }
    cell.textLabel.text = value;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ViewController *controller = [[ViewController alloc] initWithNoteIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (void) sync {
    if(notesCount == 0){
        self.navigationItem.title = @"LOADING";
    }else{
        self.navigationItem.title = @"SYNCING";
    }
    
    [self animate];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    Scholica* scholica = appDelegate.scholica;
    
    [scholica request:@"/methods" callback:^(ScholicaRequestResult *result) {
        NSLog(@"Done syncing");
        [self animate];
        if(result.status == ScholicaRequestStatusOK){
            
            // Load changed/new notes
            // Save them to NSUserDefaults
            
            // Set and save notesCount
            
            // Redraw tableView
            self.navigationItem.title = @"NOTES";
            [self.tableView reloadData];
            
        }else{
            
            // Show error
            
        }
    }];
}


@end
