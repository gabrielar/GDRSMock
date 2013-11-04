//
//  GDRSMock.h
//  GDRSMock
//
//  Created by Gabriel Radu on 03/11/2013.
//  Copyright (c) 2013 GADRS Consulting Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDRSMockMethodCall.h"

@class GDRSMock;



@interface GDRSMockCallLog : NSObject

@property (nonatomic) SEL selector;
@property (nonatomic, readonly) NSArray *invocations;

@end



#pragma mark -


typedef void(^GDRSMockSelectorResponderBlock)(GDRSMockMethodCall *methodCall);

@interface GDRSMock : NSProxy

+ (id)mockWithMockedObject:(id)mockedObject forwardCalls:(BOOL)forwardCalls setupBlock:(void(^)(GDRSMock *mock))setupBlock;
- (void)gdrs_mock_setResponderForSelector:(SEL)aSelector block:(GDRSMockSelectorResponderBlock)responderBlock;
- (GDRSMockCallLog *)gdrs_mock_callLogForSelector:(SEL)aSelector;

@end



