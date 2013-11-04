//
//  GDRSMock.h
//  GDRSMock
//
//  Created by Gabriel Radu on 03/11/2013.
//  Copyright (c) 2013 Gabriel Adrian Radu. See License file for details.
//

#import <Foundation/Foundation.h>
#import "GDRSMockMethodCall.h"

@class GDRSMock;

typedef void(^GDRSMockSelectorResponderBlock)(GDRSMockMethodCall *methodCall);

@interface GDRSMock : NSProxy

+ (id)mockWithMockedObject:(id)mockedObject forwardCalls:(BOOL)forwardCalls setupBlock:(void(^)(GDRSMock *mock))setupBlock;
- (void)gdrs_mock_setResponderForSelector:(SEL)aSelector block:(GDRSMockSelectorResponderBlock)responderBlock;
- (NSArray *)gdrs_mock_callLogForSelector:(SEL)aSelector;

@end



