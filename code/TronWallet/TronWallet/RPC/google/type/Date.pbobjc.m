// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: google/type/date.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "google/type/Date.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - GTPDateRoot

@implementation GTPDateRoot

@end

#pragma mark - GTPDateRoot_FileDescriptor

static GPBFileDescriptor *GTPDateRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPBDebugCheckRuntimeVersion();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"google.type"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - GTPDate

@implementation GTPDate

@dynamic year;
@dynamic month;
@dynamic day;

typedef struct GTPDate__storage_ {
  uint32_t _has_storage_[1];
  int32_t year;
  int32_t month;
  int32_t day;
} GTPDate__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "year",
        .dataTypeSpecific.className = NULL,
        .number = GTPDate_FieldNumber_Year,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GTPDate__storage_, year),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "month",
        .dataTypeSpecific.className = NULL,
        .number = GTPDate_FieldNumber_Month,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(GTPDate__storage_, month),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "day",
        .dataTypeSpecific.className = NULL,
        .number = GTPDate_FieldNumber_Day,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(GTPDate__storage_, day),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GTPDate class]
                                     rootClass:[GTPDateRoot class]
                                          file:GTPDateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GTPDate__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
