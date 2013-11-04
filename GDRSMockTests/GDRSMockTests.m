//
//  GDRSMockTests.m
//  GDRSMockTests
//
//  Created by Gabriel Radu on 03/11/2013.
//  Copyright (c) 2013 Gabriel Adrian Radu. See License file for details.
//

#import <XCTest/XCTest.h>
#import "GDRSMock.h"

typedef void(^GDRSMockedTestClassBlock)(NSUInteger index);

@interface GDRSMockedTestClass : NSObject
@property (nonatomic) NSUInteger integerProp;
- (void)blockMethod:(GDRSMockedTestClassBlock)block;
@end

@implementation GDRSMockedTestClass
- (void)blockMethod:(GDRSMockedTestClassBlock)block {
}
@end



#pragma mark -

@interface GDRSMockTests : XCTestCase

@end

@implementation GDRSMockTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testIntegerHandling {

    GDRSMockedTestClass *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
        [mock gdrs_mock_setResponderForSelector:@selector(integerProp) block:^(GDRSMockMethodCall *methodCall) {
            [methodCall setUIntegerRetrunValue:2];
        }];
    }];
    
    XCTAssertEqual(mock.integerProp, (NSUInteger)2, @"Testing in integer property has failed. Returned value is %i, while it should have been 2.", mock.integerProp);
}

- (void)testRetrivingBlockArgument {
    
    __block NSUInteger result = 0;
    GDRSMockedTestClass *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
        [mock gdrs_mock_setResponderForSelector:@selector(blockMethod:) block:^(GDRSMockMethodCall *methodCall) {
            GDRSMockedTestClassBlock blockArg = [methodCall getObjectArgumentAtIndex:0];
            blockArg(5);
        }];
    }];
    
    [mock blockMethod:^(NSUInteger index) {
        result = index;
    }];
    
    XCTAssertEqual(result, (NSUInteger)5, @"Testing block execution has failed.");
}


@end
