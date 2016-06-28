CC = gcc -m64
AR = ar
LD = ld
WAY = execute
CC_FLAG = -g #-fPIC
 
INC = 
LIB = 

SRC = $(wildcard $(shell pwd)/*.c)
PC_SRC = $(wildcard $(shell pwd)/*.pc)
OBJ = $(patsubst %.c,%.o,$(SRC))
PC_OBJ = $(patsubst %.pc,%.o,$(PC_SRC))

TARGETPATH = 
TARGET = 

#多目标编译方式
#TARGETPATH = 
#TARGET = $(patsubst %.c, %, $(SRC))
 
ifeq ($(WAY),staticlibrary)
all:$(OBJ) $(PC_OBJ)
	${AR} rv $(TARGETPATH)/${TARGET} $?
endif

ifeq ($(WAY),dynamiclibrary)
all:$(OBJ) $(PC_OBJ)
	$(CC) $? -shared -o $(TARGETPATH)/$(TARGET)
endif

ifeq ($(WAY),execute)
all:$(OBJ) $(PC_OBJ)
	$(CC) $(LIB) $? -o $(TARGETPATH)/$(TARGET)
endif

ifeq ($(WAY),multipletarget)
all:$(TARGET)
$(TARGET):%:%.o
	$(CC) $< $(LIB) -o $@
	mv $@ $(TARGETPATH)
endif

$(OBJ):%.o:%.c
	$(CC) $(CC_FLAG) $(INC) -c $< -o $@

$(PC_OBJ):%.o:%.pc
	proc $(CCOMPSWITCH) include=$(TOPDIR)/include iname=$< oname=$(patsubst %.pc,%.c,$<) code=ANSI_C USERID=$(DBUSER)/$(DBPASSWD) DYNAMIC=ANSI
	$(CC) $(CC_FLAG) $(INC) -c $(patsubst %.pc,%.c,$<) -o $@
	rm $(patsubst %.pc,%.lis,$<) $(patsubst %.pc,%.c,$<)

.PRONY:clean
clean:
	@echo "Removing linked and compiled files......"
	rm -f $(OBJ) $(PC_OBJ) $(TARGETPATH)/$(TARGET)
