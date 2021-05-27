## # Auto Make Application

# 自动构建 CPP 程序的通用 makefile

# `##` 开头的注释是 markdown 标题。

## ### History
# author: Johan Chane

## #### version: 1.0
# date: 2020-10-31

## ### 使用说明
# SRC_DIR 放置源文件，OUT_DIR 放置编译生成的文件。

## ### Variables

APP := app
CXX := g++

# SRC_DIR, OUT_DIR 不要用 `.`
SRC_DIR := src
OUT_DIR := out

# 源代码文件的后缀
SRC_SUFFIX := .cpp
OBJ_SUFFIX := .o

# 编译参数
CXXINCS = -I$(SRC_DIR)
# CXXFLAGS += -O1 -g -std=c++11 $(CXXINCS)
CXXFLAGS += -g -std=c++11 $(CXXINCS)

# 加载库
LDLIBS =
LDFLAGS = -L$(SRC_DIR)

## ### 分析项目
# find 不要用绝对路径
APP := $(OUT_DIR)/$(APP)
SRC_FILES := $(shell find $(SRC_DIR) -type f -name '*$(SRC_SUFFIX)')
OBJ_FILES := $(patsubst $(SRC_DIR)/%,$(OUT_DIR)/%,$(subst $(SRC_SUFFIX),$(OBJ_SUFFIX),$(SRC_FILES)))
DEP_FILES := $(subst $(OBJ_SUFFIX),.d,$(OBJ_FILES))

## ### Rules

.PHONY: all build rebuild install clean cleantarget run help debug

all: cleantarget build install run

run:
	./$(APP)

build: $(APP)

rebuild: clean
	$(MAKE) -f $(firstword $(MAKEFILE_LIST)) build

install: $(APP)
	# install --mode=a+x $(APP) $(APP)
	chmod a+x ./$(APP)

$(APP): $(OBJ_FILES)
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) $(LDLIBS) -o $@

cleantarget:
	rm -rf $(APP) 2> /dev/null

clean:
	rm -rf $(OUT_DIR) 2> /dev/null

debug: cleantarget build install $(APP)
	gdb ./$(APP)

objdump: $(APP)
	objdump -S ./$(APP) | c++filt | less

## #### Include dependence。
# include <files> 会转到与 files 相关的目标。
# make clean 就不必产生依赖文件了。
# 放在 all 目标之后即可。
ifneq ($(MAKECMDGOALS),clean)
-include $(DEP_FILES)
endif

## #### Generate dependence, including rules to generate object files
# 为每个 target 产生一个 dep file。-MM 不包含系统头文件。

# ##### 例如: out/mytest/mytest.d
# out/mytest/mytest.o: src/mytest/mytest.c src/mytest/mytest.h
# 	gcc -c $(CXXFLAGS) out/mytest/mytest.o
# out/mytest/mytest.d: out/mytest/mytest.c

$(OUT_DIR)/%.d:
	@echo Generate $@ ...

    # 为生成目标文件添加命令
	@$(CXX) -MM $(CXXFLAGS) $(SRC_DIR)/$*$(SRC_SUFFIX) | install -D /dev/stdin $@.$$$$; \
	sed 's,.*:,$(subst .d,$(OBJ_SUFFIX),$@):,g' < $@.$$$$ > $@; \
	echo '	$(CXX) -c $$(CXXFLAGS) $(SRC_DIR)/$*$(SRC_SUFFIX) -o $(subst .d,$(OBJ_SUFFIX),$@)' >> $@; \
	echo '$@: $(subst .d,$(SRC_SUFFIX),$@)' >> $@;\
	rm -f $@.$$$$

help:
	@echo 'make [LDLIBS=<LDLIBS> ][<target>]'

makeDebug:
	@echo $(SRC_FILES)
	@echo $(OBJ_FILES)
	@echo $(DEP_FILES)
