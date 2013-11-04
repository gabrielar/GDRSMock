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
@property (nonatomic) NSInteger integerProp;
@property (nonatomic) NSUInteger uIntegerProp;
@property (nonatomic) float floatProp;
@property (nonatomic) double doubleProp;
@property (nonatomic) id objectProp;
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

- (void)testReturningInteger {
    
    GDRSMockedTestClass<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
        [mock gdrs_mock_setResponderForSelector:@selector(integerProp) block:^(GDRSMockMethodCall *methodCall) {
            [methodCall setIntegerRetrunValue:3];
        }];
    }];
    
    XCTAssertEqual(mock.integerProp, (NSInteger)3, @"Testing returning integer has failed. Returned value is %i, while it should have been 2.", mock.integerProp);
    
}

- (void)testReturningUInteger {

     GDRSMockedTestClass<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
        [mock gdrs_mock_setResponderForSelector:@selector(uIntegerProp) block:^(GDRSMockMethodCall *methodCall) {
            [methodCall setUIntegerRetrunValue:2];
        }];
    }];
    
    XCTAssertEqual(mock.uIntegerProp, (NSUInteger)2, @"Testing returning unsigned integer has failed. Returned value is %i, while it should have been 2.", mock.uIntegerProp);
}

- (void)testReturningFloat {
    
    GDRSMockedTestClass<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
        [mock gdrs_mock_setResponderForSelector:@selector(floatProp) block:^(GDRSMockMethodCall *methodCall) {
            [methodCall setFloatRetrunValue:3.5];
        }];
    }];
    
    XCTAssertEqualWithAccuracy(mock.floatProp, (float)3.5, 0.001, @"Testing returning float has failed. Returned value is %f, while it should have been 2.", mock.floatProp);
    
}

- (void)testReturningDoube {
    
    GDRSMockedTestClass<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
        [mock gdrs_mock_setResponderForSelector:@selector(doubleProp) block:^(GDRSMockMethodCall *methodCall) {
            [methodCall setDoubleRetrunValue:4.5];
        }];
    }];
    
    XCTAssertEqualWithAccuracy(mock.doubleProp, (double)4.5, 0.001, @"Testing returning double has failed. Returned value is %f, while it should have been 2.", mock.doubleProp);
    
}

- (void) testReturningObject {
    
    NSObject *expectedObject = [NSObject new];
    
    GDRSMockedTestClass<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSMockedTestClass new] forwardCalls:NO setupBlock:^(GDRSMock *mock) {
        [mock gdrs_mock_setResponderForSelector:@selector(objectProp) block:^(GDRSMockMethodCall *methodCall) {
            [methodCall setObjectRetrunValue:expectedObject];
        }];
    }];
    
    XCTAssertEqual(mock.objectProp, expectedObject, @"Testing returning object has failed. Returned value is %@, while it should have been %@.", mock.objectProp, expectedObject);
    
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
