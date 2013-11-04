//
//  GDRSMockMethodCall.h
//  GDRSMock
//
//  Created by Gabriel Radu on 03/11/2013.
//  Copyright (c) 2013 Gabriel Adrian Radu. See License file for details.
//

#import <Foundation/Foundation.h>

@class GDRSMock;


/*!
 Represents a call to a mock object, and provides convenience methods
 for reading  its arguments, and setting the return value.
 */
@interface GDRSMockMethodCall : NSObject

/*!
 The mock object
 */
@property (nonatomic) GDRSMock *mock;

/*!
 The real object mocked by up by the mock object.
 */
@property (nonatomic) id mockedObject;

/*!
 The invocation resorting from the method call.
 */
@property (nonatomic) NSInvocation *invocation;


#pragma mark Memory management

+ (id)methodCallWithInvocation:(NSInvocation *)invocation mock:(GDRSMock *)mock mockedObject:(id)mockedObject;


#pragma mark Retrun value

/*!
 Sets the return value to the specified argument of type NSInteger.
 @discussion  This is a convenience up method for setReturnValue: 
    of NSInvocation which it wraps.
 @param retrunValue
    The return value to be set.
 */
- (void)setIntegerRetrunValue:(NSInteger)retrunValue;

/*!
 Sets the return value to the specified argument of type NSUInteger.
 @discussion This is a convenience up method for setReturnValue:
    of NSInvocation which it wraps.
 @param retrunValue
    The return value to be set.
 */
- (void)setUIntegerRetrunValue:(NSUInteger)retrunValue;

/*!
 Sets the return value to the specified argument of type float.
 @discussion This is a convenience up method for setReturnValue:
    of NSInvocation which it wraps.
 @arg retrunValue
    The return value to be set.
 */
- (void)setFloatRetrunValue:(float)retrunValue;

/*!
 Sets the return value to the specified argument of type double.
 @discussion This is a convenience up method for setReturnValue:
    of NSInvocation which it wraps.
 @arg retrunValue
    The return value to be set.
 */
- (void)setDoubleRetrunValue:(double)retrunValue;

/*!
 Sets the return value to the specified argument of type id.
 @discussion This is a convenience up method for setReturnValue:
    of NSInvocation which it wraps.
 @arg retrunValue
    The return value to be set.
 */
- (void)setObjectRetrunValue:(id)retrunValue;


#pragma mark Arguments

/*!
 Returns the argument at the specified index as an NSInteger.
 @discussion This is a convenience up method for getArgument:atIndex:
    which it  wraps.
 @return
    The argument at the specified index.
 */
- (NSInteger)getIntegerArgumentAtIndex:(NSInteger)idx;

/*!
 Returns the argument at the specified index as an NSInteger.
 @discussion This is a convenience up method for getArgument:atIndex:
    of NSInvocation which it wraps.
 @return
    The argument at the specified index.
 */
- (NSUInteger)getUIntegerArgumentAtIndex:(NSInteger)idx;

/*!
 Returns the argument at the specified index as an NSUInteger.
 @discussion This is a convenience up method for getArgument:atIndex:
    of NSInvocation which it wraps.
 @return
    The argument at the specified index.
 */
- (float)getFloatArgumentAtIndex:(NSInteger)idx;

/*!
 Returns the argument at the specified index as an float.
 @discussion This is a convenience up method for getArgument:atIndex:
    of NSInvocation which it wraps.
 @return
    The argument at the specified index.
 */
- (double)getDoubleArgumentAtIndex:(NSInteger)idx;

/*!
 Returns the argument at the specified index as an double.
 @discussion This is a convenience up method for getArgument:atIndex:
    of NSInvocation which it wraps.
 @return
    The argument at the specified index.
 */
- (id)getObjectArgumentAtIndex:(NSInteger)idx;

@end
