## # Auto Make Application

# 自动构建 Java 程序的通用 makefile

# `##` 开头的注释是 markdown 标题。

## ### 使用说明
# SRC_DIR 放置源文件，BIN_DIR 放置编译好的 class files。
# ENTRY_POINT 只能有一个（即项目只能有一个 main 函数）。会自动查找 ENTRY_POINT。查找规则是：`^\s*public\s+static\s+[_A-Za-z]+\s+main\s*\(`。缺点不会过虑多行注释，如果注释中有这样规则的字符串则有可能会误判。

## ### Preparations

.SUFFIXES: .class .java

# 检测系统平台
UNAME_S := $(shell uname -s)

# 根据不同的系统平台，用不同的方式运行（只是为了学习）
ifeq ($(OS),Windows_NT)
CP_DELIMITER := ;
else ifeq ($(UNAME_S),Linux)
CP_DELIMITER := :
endif

## ### Variables

JC = javac
JVM= java

SRC_DIR := src
BIN_DIR := bin

# 源代码文件的后缀
SRC_SUFFIX := .java
OBJ_SUFFIX := .class
JAR_SUFFIX := .jar
JFLAGS := -encoding UTF-8

## ### 分析项目
SRC_FILES := $(shell find $(SRC_DIR) -name "*$(SRC_SUFFIX)")

## #### Find ENTRY_POINT。查找包含 `^\s*public\s+static\s+[_A-Za-z]+\s+main\s*\(` 的文件，并生成 ENTRY_POINT。
GET_MAIN_SCR_FILE_CMD := grep -E -l -e '^\s*public\s+static\s+[_A-Za-z]+\s+main\(' $(SRC_FILES)
MAIN_SCR_FILE := $(subst $(SRC_DIR)/,,$(shell $(GET_MAIN_SCR_FILE_CMD)))
ENTRY_POINT := $(subst /,.,$(basename $(MAIN_SCR_FILE)))

## #### 根据 ENTRY_POINT 生成 BINARY
# 替换 ENTRY_POINT 的 `.` 为 `/`，并分别加上前缀 $(BIN_DIR)，后缀 $(OBJ_SUFFIX)
BINARY := $(addsuffix $(OBJ_SUFFIX),$(addprefix $(BIN_DIR)/,$(subst .,/,$(ENTRY_POINT))))

## #### 根据 ENTRY_POINT 生成 JAR_PKG
JAR_PKG := $(addprefix $(BIN_DIR)/,$(addsuffix $(JAR_SUFFIX),$(ENTRY_POINT)))
## #### Others
OBJ_FILES := $(subst $(SRC_SUFFIX),$(OBJ_SUFFIX),$(subst src/,bin/,$(SRC_FILES)))
PACKAGE_PATH := $(filter-out $(BIN_DIR),$(shell dirname $(OBJ_FILES)))

## ### Rules

.PHONY: all run runjar build rebuild buildjar clean cleantarget cleanpkg help debugMake

all: cleantarget build run

run: $(ENTRY_POINT)

runjar: $(JAR_PKG)
	$(JVM) -cp $(BIN_DIR) -jar $(JAR_PKG)

build: $(BINARY)

rebuild: clean build

buildjar: $(BINARY)
	jar cvfe $(JAR_PKG) $(ENTRY_POINT) -C bin .

clean:
	rm -rf $(BIN_DIR)

cleantarget:
	rm -f $(BINARY)

# 清除包
cleanpkg:
	rm -f $(OBJ_FILES)

# 删除空的包
# 使目录层次最深包排前面
	for i in `echo '$(PACKAGE_PATH)' | xargs -n 1 | sort -r | xargs`; do\
		rmdir --ignore-fail-on-non-empty $$i;\
	done

$(ENTRY_POINT): $(BINARY)
	$(JVM) -cp $(BIN_DIR) $@

$(BIN_DIR)/%$(OBJ_SUFFIX): $(SRC_DIR)/%$(SRC_SUFFIX)
# 包含 `$(SRC_DIR)` 的原因是，当类之间相互调用时，classpath 要包含项目的 BASE_DIR（即 `.\src`）。
	$(JC) -d $(BIN_DIR) -cp '$(BIN_DIR)$(CP_DELIMITER)$(SRC_DIR)' $(JFLAGS) $<

help:
	@echo 'make [ENTRY_POINT=<entryPoint>] [<targets>]'

debugMake:
	@echo $(ENTRY_POINT)
	@echo $(BINARY)
	@echo $(SRC_FILES)
	@echo $(OBJ_FILES)
	@echo $(PACKAGE_PATH)
	@echo $(JAR_PKG)
	@echo '$(CP_DELIMITER)'
