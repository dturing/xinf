
PROJECT:=opengl
GL_FLAGS:=-lGL -lGLU -lglut -lX11 -lXext

NDLL:=../bin/linux/$(PROJECT).ndll
BIND_MODULE:=../bin/$(PROJECT).n

SRC_PATHS:=../src ../src/linux
SRCS:=$(foreach PATH,$(SRC_PATHS), $(wildcard $(PATH)/*.c))
HEADERS:=$(foreach PATH,$(SRC_PATHS), $(wildcard $(PATH)/*.h))
PROJECT_FLAGS:=$(foreach PATH,$(SRC_PATHS), -I$(PATH))

CC:=gcc -I../src
NEKO_FLAGS:=-fPIC -shared -L/usr/lib -lneko -lz  -ldl

ALL_FLAGS=$(PROJECT_FLAGS) $(NEKO_FLAGS) $(GL_FLAGS) -Werror


BIND_PATH:=../api
BIND_CLASSES:= GL GLU GLUT Tesselator
BIND_C_SRCS:=$(foreach CLASS, $(BIND_CLASSES), bind_$(CLASS).c)
BIND_N_SRCS:=$(foreach CLASS, $(BIND_CLASSES), $(CLASS)__impl.hx)

default: all

all: $(NDLL) $(BIND_MODULE)

$(PROJECT).xml : $(wildcard $(BIND_PATH)/$(PROJECT)/*.hx)
	haxe -neko $(PROJECT-tmp).n -xml $@ -cp $(BIND_PATH) $(foreach CLASS, $(BIND_CLASSES), $(PROJECT).$(CLASS))

bind_%.c : $(BIND_PATH)/$(PROJECT)/%.hx $(PROJECT).xml
	nekobind -c $(PROJECT).xml $(PROJECT).$* > $@

%__impl.hx : $(BIND_PATH)/$(PROJECT)/%.hx $(PROJECT).xml
	nekobind -i $(PROJECT).xml $(PROJECT).$* > $@


$(BIND_MODULE): $(BIND_N_SRCS)
	haxe -neko $@ $(BIND_N_SRCS)

$(NDLL): $(SRCS) $(HEADERS) $(BIND_C_SRCS)
	$(CC) $(ALL_FLAGS) -o $@ $(SRCS) $(BIND_C_SRCS)

clean:
	-@rm $(BIND_C_SRCS) $(BIND_N_SRCS) $(PROJECT).xml
	
install: $(NDLL) $(BIND_MODULE)
	cd ..; ./make_haxelib && haxelib test opengl.zip

test: install
	cd ../samples/1-test; haxe compile.hxml && neko app.n