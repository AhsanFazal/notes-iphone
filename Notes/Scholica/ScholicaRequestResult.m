//
//  ScholicaRequestResult.m
//  Created by Tom Schoffelen on 21-04-14.
//

#import "Scholica.h"

@implementation ScholicaRequestResult

- (id) initWithData:(NSData*)data {
    
    NSError* errorObject;
    @try {
        self.data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errorObject];
            if([self.data objectForKey:@"error"]){
            self.status = ScholicaRequestStatusError;
            self.error = [[ScholicaRequestError alloc] initWithData:[self.data objectForKey:@"error"]];
        }else{
            self.status = ScholicaRequestStatusOK;
        }
    }
    @catch(NSException* exception){
        self.data = @{};
        self.status = ScholicaRequestStatusError;
        self.error = [[ScholicaRequestError alloc] initWithData:@{
                                                                  @"code": @"999",
                                                                  @"description": @"Response is no valid JSON",
                                                                  @"documentation": @""
                                                                  }];
    }
    
    NSLog(@"Source:%@", self.data);
    
    return [super init];
}

@end
