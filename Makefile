#CC = gcc
#RM = rm
#AR = ar
LN = ln
INSTALL = install
MKDIR = mkdir

DIR_BUILD = .build
prefix = /usr/local

PPFLAGS = -MT $@ -MMD -MP -MF $(patsubst %.o, %.d, $@) -D_POSIX_C_SOURCE=200809L

CFLAGS_LOCAL = -Wall -g -std=c99 -coverage
CFLAGS_LOCAL += $(CFLAGS)

VALGRIND = valgrind --leak-check=full --show-leak-kinds=all

APP_SOURCE = sample.c
APP_OBJECT = sample.o
APP = table

LIB_INCLUDES = table.h

LIB_SOURCES = table.c
LIB_OBJECTS = $(patsubst %.c, %.o, $(LIB_SOURCES))
LIB_VERSION = 0.0.1
LIB_NAME = table
LIB_SO = lib$(LIB_NAME).so.$(LIB_VERSION)
LIB_A = lib$(LIB_NAME).a.$(LIB_VERSION)

DEPFILES = $(patsubst %.o, %.d, $(addprefix $(DIR_BUILD)/, $(LIB_OBJECTS)) $(DIR_BUILD)/$(APP_OBJECT))

.PHONY : all clean install uninstall test

all : $(DIR_BUILD) $(DIR_BUILD)/$(APP)

$(DIR_BUILD)/$(APP) : $(DIR_BUILD)/$(APP_OBJECT) $(DIR_BUILD)/$(LIB_SO) $(DIR_BUILD)/$(LIB_A) Makefile | $(DIR_BUILD)
	$(CC) $(CFLAGS_LOCAL) -o $@ $< -L$(PWD)/$(DIR_BUILD) -l$(LIB_NAME)

$(DIR_BUILD)/$(LIB_SO) : $(addprefix $(DIR_BUILD)/, $(LIB_OBJECTS)) Makefile | $(DIR_BUILD)
	$(CC) $(CFLAGS_LOCAL) -shared -o $@ $(filter %.o, $^)
	$(LN) -sf $(PWD)/$@ $(DIR_BUILD)/lib$(LIB_NAME).so

$(DIR_BUILD)/$(LIB_A) : $(addprefix $(DIR_BUILD)/, $(LIB_OBJECTS)) Makefile | $(DIR_BUILD)
	$(AR) $(ARFLAGS) $@ $(filter %.o, $^)
	$(LN) -sf $(PWD)/$@ $(DIR_BUILD)/lib$(LIB_NAME).a

$(addprefix $(DIR_BUILD)/, $(APP_OBJECT)) : $(DIR_BUILD)/%.o : %.c Makefile | $(DIR_BUILD)
	$(MKDIR) -p $(@D)
	$(CC) $(PPFLAGS) $(CFLAGS_LOCAL) -c $< -o $@

$(addprefix $(DIR_BUILD)/, $(LIB_OBJECTS)) : $(DIR_BUILD)/%.o : %.c Makefile | $(DIR_BUILD)
	$(MKDIR) -p $(@D)
	$(CC) $(PPFLAGS) $(CFLAGS_LOCAL) -fPIC -c $< -o $@

$(DIR_BUILD)/%.d : ;
.PRECIOUS : $(DIR_BUILD)/%.d

$(DIR_BUILD) : 
	$(MKDIR) -p $@

install : all
	$(INSTALL) -d "$(prefix)/lib"
	$(INSTALL) "$(DIR_BUILD)/$(LIB_SO)" "$(prefix)/lib"
	$(LN) -sf "$(prefix)/lib/$(LIB_SO)" "$(prefix)/lib/lib$(LIB_NAME).so"
	$(INSTALL) "$(DIR_BUILD)/$(LIB_A)" "$(prefix)/lib"
	$(LN) -sf "$(prefix)/lib/$(LIB_A)" "$(prefix)/lib/lib$(LIB_NAME).a"
	$(INSTALL) -d "$(prefix)/bin"
	$(INSTALL) "$(DIR_BUILD)/$(APP)" "$(prefix)/bin"
	$(INSTALL) -d "$(prefix)/include"
	$(MKDIR) -p "$(prefix)/include/$(LIB_NAME)"
	for header in $(LIB_INCLUDES); do $(INSTALL) -m 444  "$${header}" "$(prefix)/include/$(LIB_NAME)"; done

uninstall :
	$(RM) -f  "$(prefix)/lib/$(LIB_SO)"
	$(RM) -f  "$(prefix)/lib/lib$(LIB_NAME).so"
	$(RM) -f  "$(prefix)/lib/$(LIB_A)"
	$(RM) -f  "$(prefix)/lib/lib$(LIB_NAME).a"
	$(RM) -f  "$(prefix)/bin/$(APP)"
	$(RM) -rf "$(prefix)/include/$(LIB_NAME)"

test :
	$(VALGRIND) $(APP)

clean :
	$(RM) -rf $(DIR_BUILD)

include $(DEPFILES)
