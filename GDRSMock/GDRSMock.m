//
//  GDRSMock.m
//  GDRSMock
//
//  Created by Gabriel Radu on 03/11/2013.
//  Copyright (c) 2013 Gabriel Adrian Radu. See License file for details.
//

#import "GDRSMock.h"


@interface GDRSMockCallLogMap : NSObject
@property (nonatomic) NSMutableDictionary *callLogDictionary;
@end

@implementation GDRSMockCallLogMap

- (id)init {
    self = [super init];
    if (self) {
        _callLogDictionary = [NSMutableDictionary new];
    }
    return self;
}

- (NSArray *)callLogForSelector:(SEL)selector {
    NSString *selectorName = NSStringFromSelector(selector);
    return self.callLogDictionary[selectorName];
}

- (void)logCallWithInvocation:(GDRSMockMethodCall *)methodCall {
    
    SEL selector = [methodCall.invocation selector];
    NSString *selectorName = NSStringFromSelector(selector);
    
    NSMutableArray *callLog = self.callLogDictionary[selectorName];
    if (!callLog) {
        callLog = [NSMutableArray new];
        self.callLogDictionary[selectorName] = callLog;
    }
    [callLog addObject:methodCall];
    
}


@end



#pragma mark -


@interface GDRSMockStub ()
@property (nonatomic) id mokedObject;
@property (nonatomic) BOOL forwardMessages;
@property (nonatomic) NSMutableDictionary *selectorBlocks;
@property (nonatomic) GDRSMockCallLogMap *callLogMap;
@end

@implementation GDRSMockStub

- (id)init {
    self = [super init];
    if (self) {
        _selectorBlocks = [NSMutableDictionary new];
        _callLogMap = [GDRSMockCallLogMap new];
    }
    return self;
}

#pragma mark Selector handling

- (void)forSel:(SEL)aSelector setResponder:(GDRSMockSelectorResponderBlock)responderBlock {
    NSString *selectorName = NSStringFromSelector(aSelector);
    self.selectorBlocks[selectorName] = responderBlock;
}

- (void)respondToSelector:(SEL)selector invocation:(NSInvocation *)invocation {
    
    GDRSMock *mock = [invocation target];
    NSString *selectorName = NSStringFromSelector(selector);
    
    GDRSMockSelectorResponderBlock responderBlock = self.selectorBlocks[selectorName];
    if (responderBlock) {
        
        GDRSMockMethodCall *methodCall = [GDRSMockMethodCall methodCallWithInvocation:invocation mock:mock mockedObject:self.mokedObject];
        [self.callLogMap logCallWithInvocation:methodCall];
        responderBlock(methodCall);
        
    }
    else {
        
        if (self.forwardMessages) {
            [self.callLogMap logCallWithInvocation:[GDRSMockMethodCall methodCallWithInvocation:invocation mock:mock mockedObject:self.mokedObject]];
            [invocation invokeWithTarget:self.mokedObject];
        }
        else {
            NSAssert3(FALSE, @"Mock object for class %@ can not forward invocation %@ for selector %@", NSStringFromClass([self.mokedObject class]), invocation, selectorName);
        }
        
    }
    
    
}


#pragma mark Call log

- (NSArray *)callLogForSelector:(SEL)aSelector {
    return [self.callLogMap callLogForSelector:aSelector];
}


#pragma mark Convenience methods

- (void)setBOOLRetVal:(BOOL)value forSel:(SEL)aSelector {
    [self forSel:aSelector setResponder:^(GDRSMockMethodCall *methodCall) {
        [methodCall setBOOLReturnValue:value];
    }];
}

- (void)setIntegerRetVal:(NSInteger)value forSel:(SEL)aSelector {
    [self forSel:aSelector setResponder:^(GDRSMockMethodCall *methodCall) {
        [methodCall setIntegerReturnValue:value];
    }];
}

- (void)setUIntegerRetVal:(NSUInteger)value forSel:(SEL)aSelector {
    [self forSel:aSelector setResponder:^(GDRSMockMethodCall *methodCall) {
        [methodCall setUIntegerReturnValue:value];
    }];
}

- (void)setFloatRetVal:(float)value forSel:(SEL)aSelector {
    [self forSel:aSelector setResponder:^(GDRSMockMethodCall *methodCall) {
        [methodCall setFloatReturnValue:value];
    }];

}

- (void)setDoubleRetVal:(double)value forSel:(SEL)aSelector {
    [self forSel:aSelector setResponder:^(GDRSMockMethodCall *methodCall) {
        [methodCall setDoubleReturnValue:value];
    }];
}

- (void)setObjectRetVal:(id)value forSel:(SEL)aSelector {
    [self forSel:aSelector setResponder:^(GDRSMockMethodCall *methodCall) {
        [methodCall setObjectReturnValue:value];
    }];

}

@end



#pragma mark -


@interface GDRSMock ()
@property (nonatomic) GDRSMockStub *gdrs_mock_stub;
@end

@implementation GDRSMock

- (id)initWithMockedObject:(id)mockedObject forwardMessages:(BOOL)forwardMessages setupBlock:(GDRSMockSetupBlock)setupBlock {
    _gdrs_mock_stub = [GDRSMockStub new];
    _gdrs_mock_stub.mokedObject = mockedObject;
    _gdrs_mock_stub.forwardMessages = forwardMessages;
    if (setupBlock) {
        setupBlock(self, _gdrs_mock_stub);
    }
    return self;
}

+ (id)mockWithMockedObject:(id)mockedObject forwardMessages:(BOOL)forwardMessages setupBlock:(GDRSMockSetupBlock)setupBlock {
    return [[self alloc] initWithMockedObject:mockedObject forwardMessages:forwardMessages setupBlock:setupBlock];
}

+ (id)mockWithMockedObject:(id)mockedObject setupBlock:(GDRSMockSetupBlock)setupBlock {
    return [self mockWithMockedObject:mockedObject forwardMessages:NO setupBlock:setupBlock];
}


#pragma mark NSProxy implementation

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.gdrs_mock_stub.mokedObject methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    SEL selector = [invocation selector];
    if ([self.gdrs_mock_stub.mokedObject respondsToSelector:selector]) {
        
        [self.gdrs_mock_stub respondToSelector:selector invocation:invocation];
        
    }
    else {
        
        NSAssert3(FALSE, @"Mock object for class %@ can not forward invocation %@ for selector %@", NSStringFromClass([self.gdrs_mock_stub.mokedObject class]), invocation, NSStringFromSelector(selector));
        
    }
    
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.gdrs_mock_stub.mokedObject respondsToSelector:aSelector];
}


#pragma mark Convenience methods

- (NSArray *)gdrs_mock_callLogForSelector:(SEL)aSelector {
    return [self.gdrs_mock_stub callLogForSelector:aSelector];
}


@end


