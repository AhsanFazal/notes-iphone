//
//  ViewController.m
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSString *noteKey;
}

-(id) initWithNoteIndex:(NSInteger)index{
    self = [super init];
    if (self){
        noteKey = [NSString stringWithFormat:@"note_%li",(long)index];
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _textView = [[UITextView alloc] initWithFrame:self.view.frame];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_textView setFont:[UIFont fontWithName:@"Avenir-Book" size:17.0f]];
    _textView.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12);
    [_textView setBackgroundColor:[UIColor colorWithRed:0.973 green:0.973 blue:0.941 alpha:1]];
    [self.view addSubview:_textView];

	NSString *string = [[NSUserDefaults standardUserDefaults] stringForKey:noteKey];
    [_textView setText:string];

    self.navigationItem.title = @"";
  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped)];
    
}

- (NSString*) getSlug:(NSString*)text{
    if(text.length > 63){
        return [NSString stringWithFormat:@"%@...", [text substringToIndex:60]];
    }
    return text;
}

-(void) shareTapped{
    NSString* noteURL = @"http://notes.scholica.com/AKJOIu940hdoihddscnkjdh902";
  
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[self getSlug:[_textView text]], [NSURL URLWithString:noteURL]] applicationActivities:@[]];
    activityViewController.excludedActivityTypes = @[ UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard ];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  
    [self presentViewController:activityViewController animated:YES completion:nil];
  
    [self saveNote:noteKey willDie:NO];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self saveNote:noteKey willDie:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [_textView resignFirstResponder];
}

-(void) saveNote:(NSString*)key willDie:(BOOL)dies{
    if([[_textView text] isEqual: @""] && dies){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
      
        NSInteger notesCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"notesCount"];
        notesCount--;
        if(notesCount < 0){ notesCount = 0; }
        [[NSUserDefaults standardUserDefaults] setInteger:notesCount forKey:@"notesCount"];
      
        [self syncAction:@"remove" withKey:key withText:@""];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[_textView text] forKey:key];
      
        [self syncAction:@"sync" withKey:key withText:[_textView text]];
    }
  
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) syncAction:(NSString*)action withKey:(NSString*)key withText:(NSString*)text{
    
    if([action isEqual:@"remove"]){
        // TODO: sync action -> remove note
        //NSLog([NSString stringWithFormat:@"Should: remove note with id #%@", key]);
    }else{
        // TODO: sync action -> change note
        //NSLog([NSString stringWithFormat:@"Should: sync note with id #%@", key]);
    }
}






@end
