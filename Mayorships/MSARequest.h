//
//  MSARequest.h
//  Mayorships
//
//  Created by Katlyn Schwaebe on 8/19/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MSARequest : NSObject
+ (void) findMayorshipsWithLocation:(CLLocation *)location completion:(void(^)(NSArray * mayors))completion;
+ (void) findVenuesWithLocation:(CLLocation *)location completion:(void(^)(NSArray * venues))completion;



@end
