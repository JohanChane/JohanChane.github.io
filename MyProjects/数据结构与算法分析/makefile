## # Auto Make Application

# 自动构建 C 程序的通用 makefile

# `##` 开头的注释是 markdown 标题。

## ### 使用说明
# SRC_DIR 放置源文件，OUT_DIR 放置编译生成的文件。

## ### Variables

AppName := app
CC := gcc

# SRC_DIR, OUT_DIR 不要用 `.`
SRC_DIR := src
OUT_DIR := out

# 源代码文件的后缀
SRC_SUFFIX := .c
OBJ_SUFFIX := .o

# 编译参数
CINCS = -I$(SRC_DIR)
CFLAGS += -std=c11 -g -O1 $(CINCS)

# 加载库
LDLIBS =
LDFLAGS = -L$(SRC_DIR)

## ### 分析项目
# find 不要用绝对路径
APP := $(OUT_DIR)/$(AppName)
SRC_FILES := $(shell find $(SRC_DIR) -type f -name '*$(SRC_SUFFIX)')
OBJ_FILES := $(patsubst $(SRC_DIR)/%,$(OUT_DIR)/%,$(subst $(SRC_SUFFIX),$(OBJ_SUFFIX),$(SRC_FILES)))
DEP_FILES := $(subst $(OBJ_SUFFIX),.d,$(OBJ_FILES))

## ### Rules

.PHONY: all build install rebuild clean cleantarget run debug help makeDebug

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
	$(CC) $(CFLAGS) $^ $(LDFLAGS) $(LDLIBS) -o $@

cleantarget:
	rm -rf $(APP) 2> /dev/null

clean:
	rm -rf $(OUT_DIR) 2> /dev/null

debug: cleantarget build install
	gdb ./$(APP)

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
#	gcc -c $(CFLAGS) out/mytest/mytest.o
# out/mytest/mytest.d: out/mytest/mytest.c

$(OUT_DIR)/%.d:
	@echo Generate $@ ...

    # 为生成目标文件添加命令
	@$(CC) -MM $(CFLAGS) $(SRC_DIR)/$*$(SRC_SUFFIX) | install -D /dev/stdin $@.$$$$; \
	sed 's,.*:,$(subst .d,$(OBJ_SUFFIX),$@):,g' < $@.$$$$ > $@; \
	echo '	$(CC) $$(CFLAGS) -c $(SRC_DIR)/$*$(SRC_SUFFIX) -o $(subst .d,$(OBJ_SUFFIX),$@)' >> $@; \
	echo '$@: $(subst .d,$(SRC_SUFFIX),$@)' >> $@;\
	rm -f $@.$$$$

help:
	@echo 'make [LDLIBS=<LDLIBS> ][<target>]'

makeDebug:
	@echo $(SRC_FILES)
	@echo $(OBJ_FILES)
	@echo $(DEP_FILES)
