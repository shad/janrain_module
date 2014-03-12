/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JRCaptureObject.h"
#import "JRCaptureTypes.h"
#import "JRNSDate+ISO8601_CaptureDateTimeString.h"
#import "JRBasicPluralElement.h"
#import "JRBasicObject.h"
#import "JRObjectTestRequired.h"
#import "JRPluralTestUniqueElement.h"
#import "JRObjectTestRequiredUnique.h"
#import "JRPluralTestAlphabeticElement.h"
#import "JRPinapL1PluralElement.h"
#import "JRPinoL1Object.h"
#import "JROnipL1PluralElement.h"
#import "JROinoL1Object.h"
#import "JRPinapinapL1PluralElement.h"
#import "JRPinonipL1PluralElement.h"
#import "JRPinapinoL1Object.h"
#import "JRPinoinoL1Object.h"
#import "JROnipinapL1PluralElement.h"
#import "JROinonipL1PluralElement.h"
#import "JROnipinoL1Object.h"
#import "JROinoinoL1Object.h"

/**
 * @brief A JRCaptureUser object
 **/
@interface JRCaptureUser : JRCaptureObject
@property (nonatomic, readonly) JRUuid *uuid; /**< Globally unique indentifier for this entity @note A ::JRUuid property is a property of type \ref typesTable "uuid" and a typedef of \e NSString */ 
@property (nonatomic, readonly) JRDateTime *created; /**< When this entity was created @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, readonly) JRDateTime *lastUpdated; /**< When this entity was last updated @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *email; /**< The object's \e email property */ 
@property (nonatomic, copy)     JRBoolean *basicBoolean; /**< Basic boolean property for testing getting/setting with NSNumbers and primitives, updating, and replacing @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     NSString *basicString; /**< Basic string property for testing getting/setting, updating, and replacing */ 
@property (nonatomic, copy)     JRInteger *basicInteger; /**< Basic integer property for testing getting/setting with NSNumbers and primitives, updating, and replacing @note A ::JRInteger property is a property of type \ref typesTable "integer" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:<em>myInteger</em>]</code>, <code>[NSNumber numberWithInt:<em>myInt</em>]</code>, or <code>nil</code> */ 
@property (nonatomic, copy)     JRDecimal *basicDecimal; /**< Basic decimal property for testing getting/setting with various NSNumbers, updating, and replacing @note A ::JRDecimal property is a property of type \ref typesTable "decimal" and a typedef of \e NSNumber. Accepted values can be, for example, <code>[NSNumber numberWithNumber:<em>myDecimal</em>]</code>, <code>nil</code>, etc. */ 
@property (nonatomic, copy)     JRDate *basicDate; /**< Basic date property for testing getting/setting with various formats, updating, and replacing @note A ::JRDate property is a property of type \ref typesTable "date" and a typedef of \e NSDate. The accepted format should be an ISO 8601 date string (e.g., <code>yyyy-MM-dd</code>) */ 
@property (nonatomic, copy)     JRDateTime *basicDateTime; /**< Basic dateTime property for testing getting/setting with various formats, updating, and replacing @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRIpAddress *basicIpAddress; /**< Basic ipAddress property for testing getting/setting with various formats, updating, and replacing @note A ::JRIpAddress property is a property of type \ref typesTable "ipAddress" and a typedef of \e NSString. */ 
@property (nonatomic, copy)     JRPassword *basicPassword; /**< Property used to test password strings, getting/setting with various formats, updating, and replacing @note A ::JRPassword property is a property of type \ref typesTable "password", which can be either an \e NSString or \e NSDictionary, and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     JRJsonObject *jsonNumber; /**< Property used to test json numbers, getting/setting with various formats, updating, and replacing @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     JRJsonObject *jsonString; /**< Property used to test json strings, getting/setting with various formats, updating, and replacing @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     JRJsonObject *jsonArray; /**< Property used to test json arrays, getting/setting with various formats, updating, and replacing @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     JRJsonObject *jsonDictionary; /**< Property used to test json dictionaries, getting/setting with various formats, updating, and replacing @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *stringTestJson; /**< Property used to test getting/setting, updating, and replacing strings that contain valid json objects, json characters, etc. */ 
@property (nonatomic, copy)     NSString *stringTestEmpty; /**< Property used to test getting/setting, updating, and replacing empty strings */ 
@property (nonatomic, copy)     NSString *stringTestNull; /**< Property used to test getting/setting, updating, and replacing null strings */ 
@property (nonatomic, copy)     NSString *stringTestInvalid; /**< Property used to test getting/setting, updating, and replacing strings that contain special or dangerous characters */ 
@property (nonatomic, copy)     NSString *stringTestNSNull; /**< Property used to test getting/setting, updating, and replacing [NSNull null] strings */ 
@property (nonatomic, copy)     NSString *stringTestAlphanumeric; /**< Property used to test getting/setting, updating, and replacing strings that have the 'alphanumeric' constraint */ 
@property (nonatomic, copy)     NSString *stringTestUnicodeLetters; /**< Property used to test getting/setting, updating, and replacing strings that have the 'unicode-letters' constraint */ 
@property (nonatomic, copy)     NSString *stringTestUnicodePrintable; /**< Property used to test getting/setting, updating, and replacing strings that have the 'unicode-printable' constraint */ 
@property (nonatomic, copy)     NSString *stringTestEmailAddress; /**< Property used to test getting/setting, updating, and replacing strings that have the 'email-address' constraint */ 
@property (nonatomic, copy)     NSString *stringTestLength; /**< Property used to test getting/setting, updating, and replacing strings that have the length attribute defined */ 
@property (nonatomic, copy)     NSString *stringTestCaseSensitive; /**< Property used to test getting/setting, updating, and replacing strings that have the case-sensitive attribute defined */ 
@property (nonatomic, copy)     NSString *stringTestFeatures; /**< Property used to test getting/setting, updating, and replacing strings that have the features attribute defined */ 
@property (nonatomic, copy)     NSArray *basicPlural; /**< Basic plural property for testing getting/setting, updating, and replacing @note This is an array of JRBasicPluralElement objects */ 
@property (nonatomic, retain)   JRBasicObject *basicObject; /**< Basic object property for testing getting/setting, updating, and replacing */ 
@property (nonatomic, retain)   JRObjectTestRequired *objectTestRequired; /**< Object for testing getting/setting, updating, and replacing properties when one property has the constraint of being required */ 
@property (nonatomic, copy)     NSArray *pluralTestUnique; /**< Plural for testing getting/setting, updating, and replacing elements when one element property has the constraint of being unique @note This is an array of JRPluralTestUniqueElement objects */ 
@property (nonatomic, retain)   JRObjectTestRequiredUnique *objectTestRequiredUnique; /**< Object for testing getting/setting, updating, and replacing properties when the properties have the constraints of being required and unique */ 
@property (nonatomic, copy)     NSArray *pluralTestAlphabetic; /**< Plural for testing getting/setting, updating, and replacing elements when one element property has the constraint of being alphabetic @note This is an array of JRPluralTestAlphabeticElement objects */ 
@property (nonatomic, copy)     JRStringArray *simpleStringPluralOne; /**< Plural property for testing getting/setting, updating, and replacing lists of strings/JRStringPluralElements @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c simpleTypeOne */ 
@property (nonatomic, copy)     JRStringArray *simpleStringPluralTwo; /**< Another plural property for testing getting/setting, updating, and replacing lists of strings/JRStringPluralElements @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c simpleTypeTwo */ 
@property (nonatomic, copy)     NSArray *pinapL1Plural; /**< Plural in a plural (element in a plural in an element in a plural) @note This is an array of JRPinapL1PluralElement objects */ 
@property (nonatomic, retain)   JRPinoL1Object *pinoL1Object; /**< Plural in an object (element in a plural in an object) */ 
@property (nonatomic, copy)     NSArray *onipL1Plural; /**< Object in a plural (object in an element in a plural) @note This is an array of JROnipL1PluralElement objects */ 
@property (nonatomic, retain)   JROinoL1Object *oinoL1Object; /**< Object in a object */ 
@property (nonatomic, copy)     NSArray *pinapinapL1Plural; /**< Plural in a plural in a plural (element in a plural in an element in a plural in an element in a plural) @note This is an array of JRPinapinapL1PluralElement objects */ 
@property (nonatomic, copy)     NSArray *pinonipL1Plural; /**< Plural in an object in a plural (element in a plural in an object in an element in a plural) @note This is an array of JRPinonipL1PluralElement objects */ 
@property (nonatomic, retain)   JRPinapinoL1Object *pinapinoL1Object; /**< Plural in a plural in an object (element in a plural in an element in a plural in an object) */ 
@property (nonatomic, retain)   JRPinoinoL1Object *pinoinoL1Object; /**< Plural in an object in a object (element in a plural in an object in an object) */ 
@property (nonatomic, copy)     NSArray *onipinapL1Plural; /**< Object in a plural in a plural (object in an element in a plural in an element in a plural) @note This is an array of JROnipinapL1PluralElement objects */ 
@property (nonatomic, copy)     NSArray *oinonipL1Plural; /**< Object in an object in a plural (object in an object in an element in a plural) @note This is an array of JROinonipL1PluralElement objects */ 
@property (nonatomic, retain)   JROnipinoL1Object *onipinoL1Object; /**< Object in a plural in an object (object in an element in a plural in an object) */ 
@property (nonatomic, retain)   JROinoinoL1Object *oinoinoL1Object; /**< Object in an object in a object */ 
@property (nonatomic, readonly) JRObjectId *captureUserId; /**< Simple identifier for this entity @note The \e id of the object should not be set. */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
+ (id)captureUser;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * Use this method to replace the JRCaptureUser#basicPlural array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#basicPlural property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#basicPlural property, and the name of the replaced array: \c "basicPlural".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#basicPlural property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRBasicPluralElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#basicPlural or JRBasicPluralElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRBasicPluralElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRBasicPluralElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRBasicPluralElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#basicPlural array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRBasicPluralElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#basicPlural array, but
 * you have locally updated the properties of a JRBasicPluralElement, you can just call
 * JRBasicPluralElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRBasicPluralElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceBasicPluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#pluralTestUnique array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#pluralTestUnique property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#pluralTestUnique property, and the name of the replaced array: \c "pluralTestUnique".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#pluralTestUnique property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPluralTestUniqueElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#pluralTestUnique or JRPluralTestUniqueElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPluralTestUniqueElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPluralTestUniqueElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPluralTestUniqueElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#pluralTestUnique array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPluralTestUniqueElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#pluralTestUnique array, but
 * you have locally updated the properties of a JRPluralTestUniqueElement, you can just call
 * JRPluralTestUniqueElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPluralTestUniqueElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePluralTestUniqueArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#pluralTestAlphabetic array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#pluralTestAlphabetic property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#pluralTestAlphabetic property, and the name of the replaced array: \c "pluralTestAlphabetic".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#pluralTestAlphabetic property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPluralTestAlphabeticElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#pluralTestAlphabetic or JRPluralTestAlphabeticElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPluralTestAlphabeticElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPluralTestAlphabeticElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPluralTestAlphabeticElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#pluralTestAlphabetic array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPluralTestAlphabeticElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#pluralTestAlphabetic array, but
 * you have locally updated the properties of a JRPluralTestAlphabeticElement, you can just call
 * JRPluralTestAlphabeticElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPluralTestAlphabeticElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePluralTestAlphabeticArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#simpleStringPluralOne array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#simpleStringPluralOne property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#simpleStringPluralOne property, and the name of the replaced array: \c "simpleStringPluralOne".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#simpleStringPluralOne property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRSimpleStringPluralOneElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#simpleStringPluralOne or JRSimpleStringPluralOneElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRSimpleStringPluralOneElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRSimpleStringPluralOneElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRSimpleStringPluralOneElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#simpleStringPluralOne array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRSimpleStringPluralOneElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#simpleStringPluralOne array, but
 * you have locally updated the properties of a JRSimpleStringPluralOneElement, you can just call
 * JRSimpleStringPluralOneElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRSimpleStringPluralOneElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceSimpleStringPluralOneArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#simpleStringPluralTwo array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#simpleStringPluralTwo property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#simpleStringPluralTwo property, and the name of the replaced array: \c "simpleStringPluralTwo".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#simpleStringPluralTwo property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRSimpleStringPluralTwoElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#simpleStringPluralTwo or JRSimpleStringPluralTwoElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRSimpleStringPluralTwoElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRSimpleStringPluralTwoElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRSimpleStringPluralTwoElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#simpleStringPluralTwo array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRSimpleStringPluralTwoElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#simpleStringPluralTwo array, but
 * you have locally updated the properties of a JRSimpleStringPluralTwoElement, you can just call
 * JRSimpleStringPluralTwoElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRSimpleStringPluralTwoElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceSimpleStringPluralTwoArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#pinapL1Plural array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#pinapL1Plural property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#pinapL1Plural property, and the name of the replaced array: \c "pinapL1Plural".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#pinapL1Plural property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPinapL1PluralElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#pinapL1Plural or JRPinapL1PluralElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPinapL1PluralElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPinapL1PluralElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPinapL1PluralElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#pinapL1Plural array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPinapL1PluralElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#pinapL1Plural array, but
 * you have locally updated the properties of a JRPinapL1PluralElement, you can just call
 * JRPinapL1PluralElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPinapL1PluralElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#onipL1Plural array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#onipL1Plural property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#onipL1Plural property, and the name of the replaced array: \c "onipL1Plural".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#onipL1Plural property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JROnipL1PluralElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#onipL1Plural or JROnipL1PluralElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JROnipL1PluralElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JROnipL1PluralElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JROnipL1PluralElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#onipL1Plural array on Capture. Replacing the array will also
 * update any local changes to the properties of a JROnipL1PluralElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#onipL1Plural array, but
 * you have locally updated the properties of a JROnipL1PluralElement, you can just call
 * JROnipL1PluralElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JROnipL1PluralElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceOnipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#pinapinapL1Plural array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#pinapinapL1Plural property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#pinapinapL1Plural property, and the name of the replaced array: \c "pinapinapL1Plural".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#pinapinapL1Plural property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPinapinapL1PluralElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#pinapinapL1Plural or JRPinapinapL1PluralElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPinapinapL1PluralElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPinapinapL1PluralElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPinapinapL1PluralElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#pinapinapL1Plural array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPinapinapL1PluralElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#pinapinapL1Plural array, but
 * you have locally updated the properties of a JRPinapinapL1PluralElement, you can just call
 * JRPinapinapL1PluralElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPinapinapL1PluralElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePinapinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#pinonipL1Plural array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#pinonipL1Plural property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#pinonipL1Plural property, and the name of the replaced array: \c "pinonipL1Plural".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#pinonipL1Plural property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPinonipL1PluralElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#pinonipL1Plural or JRPinonipL1PluralElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPinonipL1PluralElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPinonipL1PluralElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPinonipL1PluralElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#pinonipL1Plural array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPinonipL1PluralElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#pinonipL1Plural array, but
 * you have locally updated the properties of a JRPinonipL1PluralElement, you can just call
 * JRPinonipL1PluralElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPinonipL1PluralElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#onipinapL1Plural array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#onipinapL1Plural property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#onipinapL1Plural property, and the name of the replaced array: \c "onipinapL1Plural".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#onipinapL1Plural property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JROnipinapL1PluralElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#onipinapL1Plural or JROnipinapL1PluralElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JROnipinapL1PluralElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JROnipinapL1PluralElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JROnipinapL1PluralElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#onipinapL1Plural array on Capture. Replacing the array will also
 * update any local changes to the properties of a JROnipinapL1PluralElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#onipinapL1Plural array, but
 * you have locally updated the properties of a JROnipinapL1PluralElement, you can just call
 * JROnipinapL1PluralElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JROnipinapL1PluralElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceOnipinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#oinonipL1Plural array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#oinonipL1Plural property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#oinonipL1Plural property, and the name of the replaced array: \c "oinonipL1Plural".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#oinonipL1Plural property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JROinonipL1PluralElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#oinonipL1Plural or JROinonipL1PluralElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JROinonipL1PluralElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JROinonipL1PluralElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JROinonipL1PluralElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#oinonipL1Plural array on Capture. Replacing the array will also
 * update any local changes to the properties of a JROinonipL1PluralElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#oinonipL1Plural array, but
 * you have locally updated the properties of a JROinonipL1PluralElement, you can just call
 * JROinonipL1PluralElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JROinonipL1PluralElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceOinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to determine if the object or element needs to be updated remotely.
 * That is, if there are local changes to any of the object/elements's properties or 
 * sub-objects, then this object will need to be updated on Capture. You can update
 * an object on Capture by using the method updateOnCaptureForDelegate:context:().
 *
 * @return
 * \c YES if this object or any of it's sub-objects have any properties that have changed
 * locally. This does not include properties that are arrays, if any, or the elements contained 
 * within the arrays. \c NO if no non-array properties or sub-objects have changed locally.
 *
 * @note
 * This method recursively checks all of the sub-objects of JRCaptureUser:
 *   - JRCaptureUser#basicObject
 *   - JRCaptureUser#objectTestRequired
 *   - JRCaptureUser#objectTestRequiredUnique
 *   - JRCaptureUser#pinoL1Object
 *   - JRCaptureUser#oinoL1Object
 *   - JRCaptureUser#pinapinoL1Object
 *   - JRCaptureUser#pinoinoL1Object
 *   - JRCaptureUser#onipinoL1Object
 *   - JRCaptureUser#oinoinoL1Object
 * .
 * @par
 * If any of these objects are new, or if they need to be updated, this method returns \c YES.
 *
 * @warning
 * This method recursively checks all of the sub-objects of JRCaptureUser
 * but does not check any of the arrays of the JRCaptureUser or the arrays' elements:
 *   - JRCaptureUser#basicPlural, JRBasicPluralElement
 *   - JRCaptureUser#pluralTestUnique, JRPluralTestUniqueElement
 *   - JRCaptureUser#pluralTestAlphabetic, JRPluralTestAlphabeticElement
 *   - JRCaptureUser#simpleStringPluralOne, JRSimpleStringPluralOneElement
 *   - JRCaptureUser#simpleStringPluralTwo, JRSimpleStringPluralTwoElement
 *   - JRCaptureUser#pinapL1Plural, JRPinapL1PluralElement
 *   - JRCaptureUser#onipL1Plural, JROnipL1PluralElement
 *   - JRCaptureUser#pinapinapL1Plural, JRPinapinapL1PluralElement
 *   - JRCaptureUser#pinonipL1Plural, JRPinonipL1PluralElement
 *   - JRCaptureUser#onipinapL1Plural, JROnipinapL1PluralElement
 *   - JRCaptureUser#oinonipL1Plural, JROinonipL1PluralElement
 * .
 * @par
 * If you have added or removed any elements from the arrays, you must call the following methods
 * to update the array on Capture: replaceBasicPluralArrayOnCaptureForDelegate:context:(),
 *   replacePluralTestUniqueArrayOnCaptureForDelegate:context:(),
 *   replacePluralTestAlphabeticArrayOnCaptureForDelegate:context:(),
 *   replaceSimpleStringPluralOneArrayOnCaptureForDelegate:context:(),
 *   replaceSimpleStringPluralTwoArrayOnCaptureForDelegate:context:(),
 *   replacePinapL1PluralArrayOnCaptureForDelegate:context:(),
 *   replaceOnipL1PluralArrayOnCaptureForDelegate:context:(),
 *   replacePinapinapL1PluralArrayOnCaptureForDelegate:context:(),
 *   replacePinonipL1PluralArrayOnCaptureForDelegate:context:(),
 *   replaceOnipinapL1PluralArrayOnCaptureForDelegate:context:(),
 *   replaceOinonipL1PluralArrayOnCaptureForDelegate:context:()
 *
 * @par
 * Otherwise, if the array elements' JRCaptureObject#canBeUpdatedOnCapture and JRCaptureObject#needsUpdate returns \c YES, you can update
 * the elements by calling updateOnCaptureForDelegate:context:().
 **/
- (BOOL)needsUpdate;

/**
 * TODO: Doxygen doc
 **/
- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;
/*@}*/

/**
 * @name Primitive Getters/Setters 
 **/
/*@{*/
/**
 * Returns the primitive boolean value stored in the basicBoolean property. Will return \c NO if the
 * basicBoolean is  nil. **/
- (BOOL)getBasicBooleanBoolValue;

/**
 * Sets the basicBoolean property to a the primitive boolean value.
 **/
- (void)setBasicBooleanWithBool:(BOOL)boolVal;

/**
 * Returns the primitive integer value stored in the basicInteger property. Will return \c 0 if the
 * basicInteger is  nil. **/
- (NSInteger)getBasicIntegerIntegerValue;

/**
 * Sets the basicInteger property to a the primitive integer value.
 **/
- (void)setBasicIntegerWithInteger:(NSInteger)integerVal;
/*@}*/

@end
