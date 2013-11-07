//
//  GDRSMock.h
//  GDRSMock
//
//  Created by Gabriel Radu on 03/11/2013.
//  Copyright (c) 2013 Gabriel Adrian Radu. See License file for details.
//

#import <Foundation/Foundation.h>
#import "GDRSMockMethodCall.h"

@class GDRSMock, GDRSMockStub;

typedef void(^GDRSMockSelectorResponderBlock)(GDRSMockMethodCall *methodCall);
typedef void(^GDRSMockSetupBlock)(GDRSMock *mock, GDRSMockStub *stub);



@interface GDRSMockStub : NSObject

/*!
 Registers a block with the mock object stub. This block is then executed when 
 a message for the specified selector is send to the mock object.
 @param aSelector
    The selector for which the block is registered.
 @param responderBlock
    The block which is executed when the a message corresponding to aSelector 
    is sent.
 */
- (void)forSel:(SEL)aSelector setResponder:(GDRSMockSelectorResponderBlock)responderBlock;

- (void)setForwardSel:(SEL)aSelector;

/*!
 Returns an array of GDRSMethodCall objects. These objects represent the 
 messages send to the mock object related to this stub for the specified 
 selector. Ordering is chronological.
 @param aSelector
    The GDRSMethodCall objects represent messages sent for this selector only.
 @return
    An array of GDRSMethodCall objects.
 */
- (NSArray *)callLogForSelector:(SEL)aSelector;

- (void)setBOOLRetVal:(BOOL)value forSel:(SEL)aSelector;
- (void)setIntegerRetVal:(NSInteger)value forSel:(SEL)aSelector;
- (void)setUIntegerRetVal:(NSUInteger)value forSel:(SEL)aSelector;
- (void)setFloatRetVal:(float)value forSel:(SEL)aSelector;
- (void)setDoubleRetVal:(double)value forSel:(SEL)aSelector;
- (void)setObjectRetVal:(id)value forSel:(SEL)aSelector;

@end




/*!
 Protocol implemented by all mock objects. Contains methods for customisation 
 and inspection of the call log off a mock object.
 @discussion Normally the variable pointing to a mock object should have the 
 same type as the real object, however it is recommended that the variable 
 type should also include this protocol. Eg. if the real object is of type 
 SomeRealObject a variable pointing to a mock standing in for a object of 
 SomeRealObject class should be of type SomeRealObject<GDRSMock>. This way 
 the mock object will accept messages for the real object, as well as for 
 the mock object, without generating any compiler warnings or errors. Also 
 the code completion will work for both cases.
 */
@protocol GDRSMock<NSObject>

@property (nonatomic, readonly) GDRSMockStub *gdrs_mock_stub;

/*!
 Returns an array of GDRSMethodCall objects. These objects represent the messages
 send to the mock object for the specified selector. Ordering is chronological.
 @param aSelector
 The GDRSMethodCall objects represent messages sent for this selector only.
 @return
 An array of GDRSMethodCall objects.
 */
- (NSArray *)gdrs_mock_callLogForSelector:(SEL)aSelector;

@end



/*!
 Mimics the interface up of a real object, however it is possible to alter
 the mock object behaviour compared to the real object. This aids unit testing.
 @discussion Normally the variable pointing to a mock object should have the
 same type as the real object, however it is recommended that the variable
 type should also include this protocol. Eg. if the real object is of type
 SomeRealObject a variable pointing to a mock standing in for a object of
 SomeRealObject class should be of type SomeRealObject<GDRSMock>. This way
 the mock object will accept messages for the real object, as well as for
 the mock object, without generating any compiler warnings or errors. Also
 the code completion will work for both cases.
 */
@interface GDRSMock : NSProxy<GDRSMock>

/*!
 Initialises a mock object with the specified real object and setup block.
 The mock object will not forward the messages not handled by it self to
 the mocked (real) object.
 @param mockedObject
 The real object for which this mocked object stands in.
 @param setupBlock
 This block is called after the initialisation of the mock object. In here
 the mock can be initialised further, by for example setting responders for
 selectors with gdrs_mock_setResponderForSelector:block:.
 */
+ (id)mockWithMockedObject:(id)mockedObject setupBlock:(GDRSMockSetupBlock)setupBlock;

/*!
 Initialises a mock object with the specified real object and setup block. The 
 caller can also specify whether the mock object forwards the messages not 
 handled by it self to the mocked (real) object.
 @param mockedObject
    The real object for which this mocked object stands in.
 @param forwardMessages
    If true the mock object will forward the messages not handled by it self
    to the real object (mocked object).
 @param setupBlock
    This block is called after the initialisation of the mock object. In here
    the mock can be initialised further, by for example setting responders for
    selectors with gdrs_mock_setResponderForSelector:block:.
 */
+ (id)mockWithMockedObject:(id)mockedObject forwardMessages:(BOOL)forwardMessages setupBlock:(GDRSMockSetupBlock)setupBlock;

@end


