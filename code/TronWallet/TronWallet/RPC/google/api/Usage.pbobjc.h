// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: google/api/usage.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30001
#error This file was generated by a different version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class UsageRule;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum Usage_ServiceAccess

/// Service access types.
///
/// Access to restricted API features is always controlled by
/// [visibility][google.api.Visibility], independent of the ServiceAccess type.
typedef GPB_ENUM(Usage_ServiceAccess) {
  /// Value used if any message's field encounters a value that is not defined
  /// by this enum. The message will also have C functions to get/set the rawValue
  /// of the field.
  Usage_ServiceAccess_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /// The service can only be seen/used by users identified in the service's
  /// access control policy.
  ///
  /// If the service has not been whitelisted by your domain administrator
  /// for out-of-org publishing, then this mode will be treated like
  /// ORG_RESTRICTED.
  Usage_ServiceAccess_Restricted = 0,

  /// The service can be seen/used by anyone.
  ///
  /// If the service has not been whitelisted by your domain administrator
  /// for out-of-org publishing, then this mode will be treated like
  /// ORG_PUBLIC.
  ///
  /// The discovery document for the service will also be public and allow
  /// unregistered access.
  Usage_ServiceAccess_Public = 1,

  /// The service can be seen/used by users identified in the service's
  /// access control policy and they are within the organization that owns the
  /// service.
  ///
  /// Access is further constrained to the group
  /// controlled by the administrator of the project/org that owns the
  /// service.
  Usage_ServiceAccess_OrgRestricted = 2,

  /// The service can be seen/used by the group of users controlled by the
  /// administrator of the project/org that owns the service.
  Usage_ServiceAccess_OrgPublic = 3,
};

GPBEnumDescriptor *Usage_ServiceAccess_EnumDescriptor(void);

/// Checks to see if the given value is defined by the enum or was not known at
/// the time this source was generated.
BOOL Usage_ServiceAccess_IsValidValue(int32_t value);

#pragma mark - UsageRoot

/// Exposes the extension registry for this file.
///
/// The base class provides:
/// @code
///   + (GPBExtensionRegistry *)extensionRegistry;
/// @endcode
/// which is a @c GPBExtensionRegistry that includes all the extensions defined by
/// this file and all files that it depends on.
@interface UsageRoot : GPBRootObject
@end

#pragma mark - Usage

typedef GPB_ENUM(Usage_FieldNumber) {
  Usage_FieldNumber_RequirementsArray = 1,
  Usage_FieldNumber_DependsOnServicesArray = 2,
  Usage_FieldNumber_ActivationHooksArray = 3,
  Usage_FieldNumber_ServiceAccess = 4,
  Usage_FieldNumber_DeactivationHooksArray = 5,
  Usage_FieldNumber_RulesArray = 6,
};

/// Configuration controlling usage of a service.
@interface Usage : GPBMessage

/// Controls which users can see or activate the service.
@property(nonatomic, readwrite) Usage_ServiceAccess serviceAccess;

/// Requirements that must be satisfied before a consumer project can use the
/// service. Each requirement is of the form <service.name>/<requirement-id>;
/// for example 'serviceusage.googleapis.com/billing-enabled'.
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *requirementsArray;
/// The number of items in @c requirementsArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger requirementsArray_Count;

/// Services that must be activated in order for this service to be used.
/// The set of services activated as a result of these relations are all
/// activated in parallel with no guaranteed order of activation.
/// Each string is a service name, e.g. `calendar.googleapis.com`.
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *dependsOnServicesArray;
/// The number of items in @c dependsOnServicesArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger dependsOnServicesArray_Count;

/// Services that must be contacted before a consumer can begin using the
/// service. Each service will be contacted in sequence, and, if any activation
/// call fails, the entire activation will fail. Each hook is of the form
/// <service.name>/<hook-id>, where <hook-id> is optional; for example:
/// 'robotservice.googleapis.com/default'.
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *activationHooksArray;
/// The number of items in @c activationHooksArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger activationHooksArray_Count;

/// Services that must be contacted before a consumer can deactivate a
/// service. Each service will be contacted in sequence, and, if any
/// deactivation call fails, the entire deactivation will fail. Each hook is
/// of the form <service.name>/<hook-id>, where <hook-id> is optional; for
/// example:
/// 'compute.googleapis.com/'.
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *deactivationHooksArray;
/// The number of items in @c deactivationHooksArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger deactivationHooksArray_Count;

/// Individual rules for configuring usage on selected methods.
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<UsageRule*> *rulesArray;
/// The number of items in @c rulesArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger rulesArray_Count;

@end

/// Fetches the raw value of a @c Usage's @c serviceAccess property, even
/// if the value was not defined by the enum at the time the code was generated.
int32_t Usage_ServiceAccess_RawValue(Usage *message);
/// Sets the raw value of an @c Usage's @c serviceAccess property, allowing
/// it to be set to a value that was not defined by the enum at the time the code
/// was generated.
void SetUsage_ServiceAccess_RawValue(Usage *message, int32_t value);

#pragma mark - UsageRule

typedef GPB_ENUM(UsageRule_FieldNumber) {
  UsageRule_FieldNumber_Selector = 1,
  UsageRule_FieldNumber_AllowUnregisteredCalls = 2,
};

/// Usage configuration rules for the service.
///
/// NOTE: Under development.
///
///
/// Use this rule to configure unregistered calls for the service. Unregistered
/// calls are calls that do not contain consumer project identity.
/// (Example: calls that do not contain an API key).
/// By default, API methods do not allow unregistered calls, and each method call
/// must be identified by a consumer project identity. Use this rule to
/// allow/disallow unregistered calls.
///
/// Example of an API that wants to allow unregistered calls for entire service.
///
///     usage:
///       rules:
///       - selector: "*"
///         allow_unregistered_calls: true
///
/// Example of a method that wants to allow unregistered calls.
///
///     usage:
///       rules:
///       - selector: "google.example.library.v1.LibraryService.CreateBook"
///         allow_unregistered_calls: true
@interface UsageRule : GPBMessage

/// Selects the methods to which this rule applies. Use '*' to indicate all
/// methods in all APIs.
///
/// Refer to [selector][google.api.DocumentationRule.selector] for syntax details.
@property(nonatomic, readwrite, copy, null_resettable) NSString *selector;

/// True, if the method allows unregistered calls; false otherwise.
@property(nonatomic, readwrite) BOOL allowUnregisteredCalls;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
