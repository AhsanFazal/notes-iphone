//
//  ScholicaRequestError.h
//  Created by Tom Schoffelen on 21-04-14.
//

#import <Foundation/Foundation.h>
#import "Scholica.h"

@interface ScholicaRequestError : NSObject

@property (nonatomic) NSDictionary* data;
@property (nonatomic) int code;
@property (nonatomic) NSString* description;
@property (nonatomic) NSString* documentationURL;

- (id) initWithData:(NSDictionary*)data;

@end