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
 Represents a message to a mock object. It encapsulates the 
 NSInvocation object resulting from the message and provides
 convenience methods for reading its arguments, and setting 
 the return value.
 */
@interface GDRSMockMethodCall : NSObject

/*!
 The mock object which is the receiver of the message represented by
 this object.
 */
@property (nonatomic) GDRSMock *mock;

/*!
 The real object mocked by up by the mock object.
 */
@property (nonatomic) id mockedObject;

/*!
 The invocation resulting from the message being sent to a
 object of this class.
 */
@property (nonatomic) NSInvocation *invocation;


#pragma mark Memory management

+ (id)methodCallWithInvocation:(NSInvocation *)invocation mock:(GDRSMock *)mock mockedObject:(id)mockedObject;


#pragma mark Return value

/*!
 Sets the return value of the invocation to the specified argument of 
 type NSInteger.
 @discussion  This is a convenience up method for setReturnValue: 
    of NSInvocation which it wraps.
 @param returnValue
    The return value to be set.
 */
- (void)setIntegerReturnValue:(NSInteger)returnValue;

/*!
 Sets the return value of the invocation to the specified argument of 
 type NSUInteger.
 @discussion This is a convenience up method for setReturnValue:
    of NSInvocation which it wraps.
 @param returnValue
    The return value to be set.
 */
- (void)setUIntegerReturnValue:(NSUInteger)returnValue;

/*!
 Sets the return value of the invocation to the specified argument of 
 type float.
 @discussion This is a convenience up method for setReturnValue:
    of NSInvocation which it wraps.
 @arg returnValue
    The return value to be set.
 */
- (void)setFloatReturnValue:(float)returnValue;

/*!
 Sets the return value of the invocation to the specified argument of 
 type double.
 @discussion This is a convenience up method for setReturnValue:
    of NSInvocation which it wraps.
 @arg returnValue
    The return value to be set.
 */
- (void)setDoubleReturnValue:(double)returnValue;

/*!
 Sets the return value of the invocation to the specified argument of 
 type id.
 @discussion This is a convenience up method for setReturnValue:
    of NSInvocation which it wraps.
 @arg returnValue
    The return value to be set.
 */
- (void)setObjectReturnValue:(id)returnValue;


#pragma mark Arguments

/*!
 Returns the argument of the invocation situated at the specified index
 as an NSInteger.
 @discussion This is a convenience up method for getArgument:atIndex:
    which it  wraps.
 @return
    The argument at the specified index.
 */
- (NSInteger)getIntegerArgumentAtIndex:(NSInteger)idx;

/*!
 Returns the argument of the invocation situated at the specified index
 as an NSUInteger.
 @discussion This is a convenience up method for getArgument:atIndex:
    of NSInvocation which it wraps.
 @return
    The argument at the specified index.
 */
- (NSUInteger)getUIntegerArgumentAtIndex:(NSInteger)idx;

/*!
 Returns the argument of the invocation situated at the specified index
 as an float.
 @discussion This is a convenience up method for getArgument:atIndex:
    of NSInvocation which it wraps.
 @return
    The argument at the specified index.
 */
- (float)getFloatArgumentAtIndex:(NSInteger)idx;

/*!
 Returns the argument of the invocation situated at the specified index
 as an double.
 @discussion This is a convenience up method for getArgument:atIndex:
    of NSInvocation which it wraps.
 @return
    The argument at the specified index.
 */
- (double)getDoubleArgumentAtIndex:(NSInteger)idx;

/*!
 Returns the argument of the invocation situated at the specified index
 as an Objective-C object.
 @discussion This is a convenience up method for getArgument:atIndex:
    of NSInvocation which it wraps.
 @return
    The argument at the specified index.
 */
- (id)getObjectArgumentAtIndex:(NSInteger)idx;

@end


