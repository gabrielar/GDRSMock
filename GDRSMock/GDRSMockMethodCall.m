//
//  GDRSMockMethodCall.m
//  GDRSMock
//
//  Created by Gabriel Radu on 03/11/2013.
//  Copyright (c) 2013 Gabriel Adrian Radu. See License file for details.
//

#import "GDRSMockMethodCall.h"

@implementation GDRSMockMethodCall

#pragma mark Memory management

+ (id)methodCallWithInvocation:(NSInvocation *)invocation mock:(GDRSMock *)mock mockedObject:(id)mockedObject {
    GDRSMockMethodCall *methodCall = [[self alloc] init];
    methodCall.invocation = invocation;
    methodCall.mock = mock;
    methodCall.mockedObject = mockedObject;
    return methodCall;
}


#pragma mark Retrun value

- (void)setIntegerReturnValue:(NSInteger)returnValue {
    [self.invocation setReturnValue:&returnValue];
}

- (void)setUIntegerReturnValue:(NSUInteger)returnValue {
    [self.invocation setReturnValue:&returnValue];
}

- (void)setFloatReturnValue:(float)returnValue {
    [self.invocation setReturnValue:&returnValue];
}

- (void)setDoubleReturnValue:(double)returnValue {
    [self.invocation setReturnValue:&returnValue];
}

- (void)setObjectReturnValue:(id)returnValue {
    [self.invocation setReturnValue:&returnValue];
}


#pragma mark Arguments

- (NSInteger)getIntegerArgumentAtIndex:(NSInteger)idx {
    NSInteger argument = 0;
    [self.invocation getArgument:&argument atIndex:idx+2];
    return argument;
}

- (NSUInteger)getUIntegerArgumentAtIndex:(NSInteger)idx {
    NSUInteger argument = 0;
    [self.invocation getArgument:&argument atIndex:idx+2];
    return argument;
}

- (float)getFloatArgumentAtIndex:(NSInteger)idx {
    float argument = 0;
    [self.invocation getArgument:&argument atIndex:idx+2];
    return argument;
}

- (double)getDoubleArgumentAtIndex:(NSInteger)idx {
    double argument = 0;
    [self.invocation getArgument:&argument atIndex:idx+2];
    return argument;
}

- (id)getObjectArgumentAtIndex:(NSInteger)idx {
    id argument = 0;
    [self.invocation getArgument:&argument atIndex:idx+2];
    return argument;
}


@end


