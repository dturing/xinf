
PROJECT:=cptr

NDLL:=../bin/linux/$(PROJECT).ndll

SRC_PATHS:=../src ../src/linux
SRCS:=$(foreach PATH,$(SRC_PATHS), $(wildcard $(PATH)/*.c))
HEADERS:=$(foreach PATH,$(SRC_PATHS), $(wildcard $(PATH)/*.h))
PROJECT_FLAGS:=$(foreach PATH,$(SRC_PATHS), -I$(PATH))

CC:=gcc -I../src
NEKO_FLAGS:=-fPIC -shared -L/usr/lib -lneko -lz  -ldl

ALL_FLAGS=$(PROJECT_FLAGS) $(NEKO_FLAGS)

$(NDLL): $(SRCS) $(HEADERS)
	$(CC) $(ALL_FLAGS) -o $@ $(SRCS)
