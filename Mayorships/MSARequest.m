//
//  MSARequest.m
//  Mayorships
//
//  Created by Katlyn Schwaebe on 8/19/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

#import "MSARequest.h"
#define API @"https://api.foursquare.com/v2/"
#define CLIENT_ID @"FUTLZFDDQDFFA534YA1M2MQSSCMDQUBZMTP0AU3HRF5TXBIO"
#define CLIENT_SECRET @"OW0V5Q213I1D1ZWV0LVUSKUJQWAMDPOI4EV2TEHVHNTQRSEH"

//venues/search?ll=40.7,-74&client_id=CLIENT_ID&client_secret=CLIENT_SECRET&v=YYYYMMDD
@implementation MSARequest
//+(NSArray *)findMayorshipsWithLocation:(CLLocation *) location
+(void)findMayorshipsWithLocation:(CLLocation *)location completion:(void (^)(NSArray * mayors))completion
{
    //NSArray * venues = [MSARequest findVenuesWithLocation:location];
    [MSARequest findVenuesWithLocation:location completion:^(NSArray *venues)
    {
        NSMutableArray * mayors = [@[]mutableCopy];
        
        for (NSDictionary * venue in venues)
        {
            NSString * endpoint = [NSString stringWithFormat:@"venues/%@",venue[@"id"]];
            [MSARequest foursquareRequestWithEndPoint:endpoint andParameters:@{} completion:^(NSDictionary *responseInfo)
            {
                NSDictionary * mayor = responseInfo[@"response"][@"venue"][@"mayor"];
                if (mayor) [mayors addObject:mayor];
                if(completion) completion(mayors);
            }];
            //NSDictionary *venueInfo = [MSARequest foursquareRequestWithEndpoint:endpoint andParameters:@{}];
        }
     
        //return mayors;
     }];
    
}

+(void) findVenuesWithLocation:(CLLocation *)location completion:(void(^)(NSArray * venues))completion
{
    NSDictionary * parameters = @{
                                  @"ll": [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude]
                                      };

    [MSARequest foursquareRequestWithEndPoint:@"venues/search" andParameters:parameters completion:^(NSDictionary *responseInfo) {
        if (completion) completion(responseInfo[@"response"][@"venues"]);
            
    }];
    //return [MSARequest foursquareRequestWithEndpoint:@"venues/search" andParameters:parameters][@"response"][@"venues"];
}

+(void)foursquareRequestWithEndPoint: (NSString *) endpoint andParameters: (NSDictionary *)parameters completion :(void(^)(NSDictionary * responseInfo))completion
{
    NSMutableString * requestString = [[API stringByAppendingString:endpoint]mutableCopy];
    NSDate *currentDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    //  [dateFormatter setDateFormat:@"yyyyMMdd'T'HH:mm:ss.SSS'Z'"];
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"%@", currentDate);
    NSLog(@"%@", localDateString);
    [requestString appendString:[NSString stringWithFormat:@"?client_id=%@&client_secret=%@&v=%@", CLIENT_ID, CLIENT_SECRET,localDateString]];
  //  [requestString appendString:[NSString stringWithFormat:@"?client_id=%@&client_secret=%@&v=20140819",CLIENT_ID,CLIENT_SECRET ]];
    for (NSString * key in [parameters allKeys])
    {
        
     [requestString appendFormat:@"&%@=%@",key, [parameters objectForKey:key]];
        
    }
    NSLog(@"%@", requestString);
    //NSString * endpointURL = [API stringByAppendingString:endpoint];
    NSURL * requestURL = [NSURL URLWithString:requestString];
    NSURLRequest * request = [NSURLRequest requestWithURL:requestURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary * responseInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(completion) completion(responseInfo);

        
    }];
    //NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSLog(@"%@",responseInfo[@"response"][@"venues"]);
    //return responseInfo;
    
}

@end
