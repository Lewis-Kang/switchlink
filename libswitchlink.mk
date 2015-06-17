# Copyright 2013-present Barefoot Networks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###############################################################################
#
# This file compiles switchlink.a
#
###############################################################################
THIS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifndef P4FACTORY
  $(error P4FACTORY not defined)
endif
MAKEFILES_DIR := $(P4FACTORY)/makefiles

ifndef SUBMODULE_SWITCHLINK
  SUBMODULE_SWITCHLINK := ${THIS_DIR}/../..
endif

# This variable is set to ${BUILD_DIR}/lib/switchlink.a when called
# from p4factory.
ifndef SWITCHLINK_LIB
  $(error Compiled archive filename not defined in SWITCHLINK_LIB)
endif

ifndef BUILD_DIR
  $(error Build directory not defined in BUILD_DIR)
endif

SWITCHLINK := $(SUBMODULE_SWITCHLINK)/src
SWITCHLINK_SOURCES_C := $(wildcard $(SWITCHLINK_SRC_DIR)/*.c)

SWITCHLINK_BUILD_DIR := $(BUILD_DIR)/switchlink
SWITCHLINK_OBJ_DIR := $(SWITCHLINK_BUILD_DIR)/obj

MAKE_DIR := $(SWITCHLINK_BUILD_DIR)
include $(MAKEFILES_DIR)/makedir.mk

MAKE_DIR := $(SWITCHLINK_OBJ_DIR)
include $(MAKEFILES_DIR)/makedir.mk

ifdef COVERAGE
COVERAGE_FLAGS := --coverage
endif

MODULE := switchlink
MODULE_LIB := $(SWITCHLINK_LIB)
$(MODULE_LIB) : MODULE_INFO := switchlink
switchlink_DIR := $(SUBMODULE_SWITCHLINK)
include $(MAKEFILES_DIR)/module.mk
$(MODULE_LIB) : MODULE_INCLUDES += $(shell pkg-config --cflags libnl-3.0)
