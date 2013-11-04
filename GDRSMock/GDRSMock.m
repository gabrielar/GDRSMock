//
//  GDRSMock.m
//  GDRSMock
//
//  Created by Gabriel Radu on 03/11/2013.
//  Copyright (c) 2013 GADRS Consulting Ltd. All rights reserved.
//

#import "GDRSMock.h"



@interface GDRSMockCallLog ()
@property (nonatomic) NSMutableArray *internalInvocationList;
@end

@implementation GDRSMockCallLog

- (id)init {
    self = [super init];
    if (self) {
        _internalInvocationList = [NSMutableArray new];
    }
    return self;
}

- (NSArray *)calls {
    return self.internalInvocationList;
}

@end



#pragma mark -


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

- (GDRSMockCallLog *)callLogForSelector:(SEL)selector {
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


@interface GDRSMock ()
@property (nonatomic) id gdrs_mock_mokedObject;
@property (nonatomic) BOOL gdrs_mock_forwardCalls;
@property (nonatomic) NSMutableDictionary *gdrs_mock_selectorBlocks;
@property (nonatomic) GDRSMockCallLogMap *gdrs_mock_callLogMap;
@end

@implementation GDRSMock

- (id)initWithMockedObject:(id)mockedObject forwardCalls:(BOOL)forwardCalls setupBlock:(void(^)(GDRSMock *mock))setupBlock
{
    _gdrs_mock_mokedObject = mockedObject;
    _gdrs_mock_forwardCalls = forwardCalls;
    _gdrs_mock_selectorBlocks = [NSMutableDictionary new];
    _gdrs_mock_callLogMap = [GDRSMockCallLogMap new];
    if (setupBlock) {
        setupBlock(self);
    }
    return self;
}

+ (id)mockWithMockedObject:(id)mockedObject forwardCalls:(BOOL)forwardCalls setupBlock:(void(^)(GDRSMock *mock))setupBlock {
    return [[self alloc] initWithMockedObject:mockedObject forwardCalls:forwardCalls setupBlock:setupBlock];
}


#pragma mark NSProxy implementation

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.gdrs_mock_mokedObject methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    SEL selector = [invocation selector];
    if ([self.gdrs_mock_mokedObject respondsToSelector:selector]) {
        
        [self gdrs_mock_respondToSelector:selector invocation:invocation];
        
    }
    else {
        
        [super forwardInvocation:invocation];
        
    }
    
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.gdrs_mock_mokedObject respondsToSelector:aSelector];
}


#pragma mark Selector handling

- (void)gdrs_mock_setResponderForSelector:(SEL)aSelector block:(GDRSMockSelectorResponderBlock)responderBlock {
    
    NSString *selectorName = NSStringFromSelector(aSelector);
    self.gdrs_mock_selectorBlocks[selectorName] = responderBlock;
    
}

- (void)gdrs_mock_respondToSelector:(SEL)selector invocation:(NSInvocation *)invocation {
    
    NSString *selectorName = NSStringFromSelector(selector);
    GDRSMockSelectorResponderBlock responderBlock = self.gdrs_mock_selectorBlocks[selectorName];
    if (responderBlock) {
        
        GDRSMockMethodCall *methodCall = [GDRSMockMethodCall methodCallWithInvocation:invocation mock:self mockedObject:self.gdrs_mock_mokedObject];
        [self.gdrs_mock_callLogMap logCallWithInvocation:methodCall];
        responderBlock(methodCall);
        
    }
    else {
        
        if (self.gdrs_mock_forwardCalls) {
            [self.gdrs_mock_callLogMap logCallWithInvocation:[GDRSMockMethodCall methodCallWithInvocation:invocation mock:self mockedObject:self.gdrs_mock_mokedObject]];
            [invocation invokeWithTarget:self.gdrs_mock_mokedObject];
        }
        else {
            [super forwardInvocation:invocation];
        }
        
    }
    

}


#pragma mark Call log

- (GDRSMockCallLog *)gdrs_mock_callLogForSelector:(SEL)aSelector {
    return [self.gdrs_mock_callLogMap callLogForSelector:aSelector];
}

@end



