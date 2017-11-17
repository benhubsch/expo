/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#include <memory>

#import <JavaScriptCore/JavaScriptCore.h>

#import <cxxReactABI23_0_0/ABI23_0_0JSCExecutor.h>
#import <ABI23_0_0jschelpers/ABI23_0_0JavaScriptCore.h>

@class ABI23_0_0RCTBridge;
@class ABI23_0_0RCTModuleData;

namespace facebook {
namespace ReactABI23_0_0 {

class Instance;

std::vector<std::unique_ptr<NativeModule>> createNativeModules(NSArray<ABI23_0_0RCTModuleData *> *modules, ABI23_0_0RCTBridge *bridge, const std::shared_ptr<Instance> &instance);

JSContext *contextForGlobalContextRef(JSGlobalContextRef contextRef);

template<>
struct JSCValueEncoder<id> {
  static Value toJSCValue(JSGlobalContextRef ctx, id obj) {
    JSValue *value = [JSC_JSValue(ctx) valueWithObject:obj inContext:contextForGlobalContextRef(ctx)];
    return {ctx, [value JSValueRef]};
  }
};

NSError *tryAndReturnError(const std::function<void()>& func);
NSString *deriveSourceURL(NSURL *url);

} }