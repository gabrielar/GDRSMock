//
//  GDRSMockTests.m
//  GDRSMockTests
//
//  Created by Gabriel Radu on 03/11/2013.
//  Copyright (c) 2013 Gabriel Adrian Radu. See License file for details.
//

#import <XCTest/XCTest.h>
#import "GDRSMock.h"

typedef void(^GDRSRealObjectBlock)(NSUInteger index);

@interface GDRSRealObject : NSObject
@property (nonatomic) NSInteger integerProp;
@property (nonatomic) NSUInteger uIntegerProp;
@property (nonatomic) float floatProp;
@property (nonatomic) double doubleProp;
@property (nonatomic) id objectProp;
- (void)blockMethod:(GDRSRealObjectBlock)block;
- (void)anInteger:(NSInteger)anInteger andAFloat:(float)aFloat;
@end

@implementation GDRSRealObject
- (void)blockMethod:(GDRSRealObjectBlock)block {
}
- (void)anInteger:(NSInteger)anInteger andAFloat:(float)aFloat {
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
    
    usleep(2e5); // Work arround a possible XCode timing bug.
    
    GDRSRealObject<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSRealObject new] setupBlock:^(GDRSMock *mock, GDRSMockStub *stub) {
        [stub setIntegerRetVal:3 forSel:@selector(integerProp)];
    }];
    
    XCTAssertEqual(mock.integerProp, (NSInteger)3, @"Testing returning integer has failed. Returned value is %i, while it should have been 2.", mock.integerProp);
    
}

- (void)testReturningUInteger {

    usleep(2e5); // Work arround a possible XCode timing bug.
    
    GDRSRealObject<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSRealObject new] setupBlock:^(GDRSMock *mock, GDRSMockStub *stub) {
        [stub setUIntegerRetVal:2 forSel:@selector(uIntegerProp)];
    }];
    
    XCTAssertEqual(mock.uIntegerProp, (NSUInteger)2, @"Testing returning unsigned integer has failed. Returned value is %i, while it should have been 2.", mock.uIntegerProp);
}

- (void)testReturningFloat {
    
    usleep(2e5); // Work arround a possible XCode timing bug.
    
    GDRSRealObject<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSRealObject new] setupBlock:^(GDRSMock *mock, GDRSMockStub *stub) {
        [stub setFloatRetVal:3.5 forSel:@selector(floatProp)];
    }];
    
    XCTAssertEqualWithAccuracy(mock.floatProp, (float)3.5, 0.001, @"Testing returning float has failed. Returned value is %f, while it should have been 2.", mock.floatProp);
    
}

- (void)testReturningDoube {
    
    usleep(2e5); // Work arround a possible XCode timing bug.
    
    GDRSRealObject<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSRealObject new] setupBlock:^(GDRSMock *mock, GDRSMockStub *stub) {
        [stub setDoubleRetVal:4.5 forSel:@selector(doubleProp)];
    }];
    
    XCTAssertEqualWithAccuracy(mock.doubleProp, (double)4.5, 0.001, @"Testing returning double has failed. Returned value is %f, while it should have been 2.", mock.doubleProp);
    
}

- (void) testReturningObject {
    
    usleep(2e5); // Work arround a possible XCode timing bug.
    
    NSObject *expectedObject = [NSObject new];
    
    GDRSRealObject<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSRealObject new] setupBlock:^(GDRSMock *mock, GDRSMockStub *stub) {
        [stub setObjectRetVal:expectedObject forSel:@selector(objectProp)];
    }];
    
    XCTAssertEqual(mock.objectProp, expectedObject, @"Testing returning object has failed. Returned value is %@, while it should have been %@.", mock.objectProp, expectedObject);
    
}

- (void)testRetrivingBlockArgument {
    
    usleep(2e5); // Work arround a possible XCode timing bug.
    
    __block NSUInteger result = 0;
    
    GDRSRealObject<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSRealObject new] setupBlock:^(GDRSMock *mock, GDRSMockStub *stub) {
        [stub forSel:@selector(blockMethod:) setResponder:^(GDRSMockMethodCall *methodCall) {
            GDRSRealObjectBlock blockArg = [methodCall getObjectArgumentAtIndex:0];
            blockArg(5);
        }];
    }];
    
    [mock blockMethod:^(NSUInteger index) {
        result = index;
    }];
    
    XCTAssertEqual(result, (NSUInteger)5, @"Testing block execution has failed.");
}

- (void)testLoggingMethodCalls {
    
    usleep(2e5); // Work arround a possible XCode timing bug.
    
    GDRSRealObject<GDRSMock> *mock = [GDRSMock mockWithMockedObject:[GDRSRealObject new] setupBlock:^(GDRSMock *mock, GDRSMockStub *stub) {
        [stub forSel:@selector(anInteger:andAFloat:) setResponder:^(GDRSMockMethodCall *methodCall) { }];
    }];
    
    [mock anInteger:2 andAFloat:3.0];
    [mock anInteger:5 andAFloat:6.5];
    
    NSArray *callLog = [mock gdrs_mock_callLogForSelector:@selector(anInteger:andAFloat:)];
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
