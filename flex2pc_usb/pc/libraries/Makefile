# Modified by chris
# SCICOS FLEX USB MAKEFILE

OBJ_DIR = obj
SRC_DIR = src
INC_DIR = inc

LIB_NAME = libflexusb.a
DLL_NAME = lib_usbdll.dll
TEST_EXE = test
CFLAGS = -g -I $(INC_DIR)

OBJS = 	$(OBJ_DIR)/udp_comms.o 
OBJS +=	$(OBJ_DIR)/flex_usb.o 
OBJS += $(OBJ_DIR)/flex_bus.o 
OBJS += $(OBJ_DIR)/flex_usbscicos.o 
#OBJS += 	$(OBJ_DIR)/scicos_flex_usb.o 



.PHONY: all clear


all: $(LIB_NAME) $(TEST_EXE) test2 test3 test4 test5


$(LIB_NAME): $(OBJS)
	@echo AR $@
	@ar -r $@ $^
	@echo

$(OBJ_DIR)/udp_comms.o: $(SRC_DIR)/udp_comms.c
	@echo CC $@ 
	@$(CC) -c $(CFLAGS) $< -o $@

$(OBJ_DIR)/flex_usb.o: $(SRC_DIR)/flex_usb.c
	@echo CC $@ 
	@$(CC) -c $(CFLAGS) $< -o $@

$(OBJ_DIR)/flex_bus.o: $(SRC_DIR)/flex_bus.c
	@echo CC $@ 
	@$(CC) -c $(CFLAGS) $< -o $@

$(OBJ_DIR)/flex_usbscicos.o: $(SRC_DIR)/flex_usbscicos.c
	@echo CC $@ 
	@$(CC) -c $(CFLAGS) $< -o $@

$(OBJ_DIR)/$(TEST_EXE).o: $(SRC_DIR)/$(TEST_EXE).c
	@echo CC $@ 
	@$(CC) -c $(CFLAGS) $< -o $@

$(OBJ_DIR)/test2.o: $(SRC_DIR)/test2.c
	@echo CC $@ 
	@$(CC) -c $(CFLAGS) $< -o $@

$(OBJ_DIR)/test3.o: $(SRC_DIR)/test3.c
	@echo CC $@ 
	@$(CC) -c $(CFLAGS) $< -o $@

$(OBJ_DIR)/test4.o: $(SRC_DIR)/test4.c
	@echo CC $@ 
	@$(CC) -c $(CFLAGS) $< -o $@

$(OBJ_DIR)/test5.o: $(SRC_DIR)/test5.c
	@echo CC $@ 
	@$(CC) -c $(CFLAGS) $< -o $@

$(TEST_EXE): $(OBJ_DIR)/$(TEST_EXE).o libflexusb.a 
	@echo BUILD TEST $@
	@$(CC)  -g -o $@ $< -lpthread -L. -lflexusb -lusb
	@echo

test2: $(OBJ_DIR)/test2.o libflexusb.a 
	@echo BUILD TEST $@
	@$(CC)  -g -o $@ $< -lpthread -L. -lflexusb -lusb
	@echo

test3: $(OBJ_DIR)/test3.o libflexusb.a 
	@echo BUILD TEST $@
	@$(CC)  -g -o $@ $< -lpthread -L. -lflexusb -lusb
	@echo

test4: $(OBJ_DIR)/test4.o libflexusb.a 
	@echo BUILD TEST $@
	@$(CC)  -g -o $@ $< -lpthread -L. -lflexusb -lusb
	@echo

test5: $(OBJ_DIR)/test5.o libflexusb.a 
	@echo BUILD TEST $@
	@$(CC)  -g -o $@ $< -lpthread -L. -lflexusb -lusb
	@echo

clean:
	@rm -rf $(OBJ_DIR)/* $(LIB_NAME) $(TEST_EXE).exe $(TEST_EXE) test2.exe test2 test3.exe test3 test4.exe test4 test5.exe test5
	@echo CLEAN COMPLETE
	@echo
