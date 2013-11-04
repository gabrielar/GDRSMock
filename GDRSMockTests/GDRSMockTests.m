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
- (void)logTestWithAnInteger:(NSInteger)anInteger aFloat:(float)aFloat;
@end

@implementation GDRSMockedTestClass
- (void)blockMethod:(GDRSMockedTestClassBlock)block {
}
- (void)logTestWithAnInteger:(NSInteger)anInteger aFloat:(float)aFloat {
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

     GDRSMockedTestClass<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
        [mock gdrs_mock_setResponderForSelector:@selector(integerProp) block:^(GDRSMockMethodCall *methodCall) {
            [methodCall setUIntegerRetrunValue:2];
        }];
    }];
    
    XCTAssertEqual(mock.integerProp, (NSUInteger)2, @"Testing in integer property has failed. Returned value is %i, while it should have been 2.", mock.integerProp);
}

- (void)testRetrivingBlockArgument {
    
    __block NSUInteger result = 0;
     GDRSMockedTestClass<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
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

- (void)testLoggingMethodCalls {
    
    GDRSMockedTestClass<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
        [mock gdrs_mock_setResponderForSelector:@selector(logTestWithAnInteger:aFloat:) block:^(GDRSMockMethodCall *methodCall) { }];
    }];
    
    [mock logTestWithAnInteger:2 aFloat:3.0];
    [mock logTestWithAnInteger:5 aFloat:6.5];
    
    NSArray *callLog = [mock gdrs_mock_callLogForSelector:@selector(logTestWithAnInteger:aFloat:)];
    XCTAssertEqual([callLog count], (NSUInteger)2, @"");
    
    GDRSMockMethodCall *methodCall = nil;
    
    methodCall = callLog[0];
    XCTAssertEqual([methodCall getIntegerArgumentAtIndex:0], 2, @"");
    XCTAssertEqualWithAccuracy([methodCall getFloatArgumentAtIndex:1], 3.0, 0.001, @"");
    
    methodCall = callLog[1];
    XCTAssertEqual([methodCall getIntegerArgumentAtIndex:0], 5, @"");
    XCTAssertEqualWithAccuracy([methodCall getFloatArgumentAtIndex:1], 6.5, 0.001, @"");
    
}

@end
