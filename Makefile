#CC = gcc
LN = ln
AR = ar
INSTALL = install

CFLAGS_LOCAL = -g -coverage -std=c99
CFLAGS_LOCAL += $(CFLAGS)

INCLUDES =

prefix = /usr/local

DIR_BUILD = build

PPFLAGS = -MT $@ -MMD -MP -MF $(DIR_BUILD)/$*.d $(INCLUDES)

LIB_SOURCES = table.c

APP_SOURCE = sample.c

LIB_OBJECTS = $(addprefix $(DIR_BUILD)/, $(patsubst %.c, %.o, $(notdir $(LIB_SOURCES))))

OBJECTS = $(addprefix $(DIR_BUILD)/, $(patsubst %.c, %.o, $(notdir $(APP_SOURCE))))

TARGET = table_test

LIBVERSION = 0.0.1
LIBNAME = table

LIB_SO_TABLE = lib$(LIBNAME).so.$(LIBVERSION)
LIB_A_TABLE = lib$(LIBNAME).a.$(LIBVERSION)

DEPFILES = $(patsubst %.o, %.d, $(OBJECTS))

# set c sources search path
vpath %.c $(sort $(dir $(LIB_SOURCES)))

# set c headers search path
#vpath %.h $(sort $(dir $(INCLUDES)))

.PHONY : all clean install uninstall test
all : $(DIR_BUILD)/$(TARGET)

$(DIR_BUILD)/$(TARGET) : $(OBJECTS) $(DIR_BUILD)/$(LIB_SO_TABLE) Makefile
	$(CC) $(CFLAGS_LOCAL) -o $@ $< -L$(shell pwd)/$(DIR_BUILD) -l$(LIBNAME)

$(DIR_BUILD)/$(LIB_SO_TABLE) : $(LIB_OBJECTS) Makefile
	$(CC) $(CFLAGS_LOCAL) -shared -o $@ $(LIB_OBJECTS)
	$(LN) -sf $(shell pwd)/$(DIR_BUILD)/$(LIB_SO_TABLE) $(DIR_BUILD)/lib$(LIBNAME).so

$(DIR_BUILD)/$(OBJECTS) : $(APP_SOURCE) Makefile
	$(CC) $(PPFLAGS) $(CFLAGS_LOCAL) -c $< -o $@

$(DIR_BUILD)/%.o : %.c Makefile | $(DIR_BUILD)
	$(CC) $(PPFLAGS) $(CFLAGS_LOCAL) -fPIC -c $< -o $@

$(DIR_BUILD)/%.d : ;
.PRECIOUS : $(DIR_BUILD)/%.d

$(DIR_BUILD) : 
	mkdir -p $(DIR_BUILD)

install : all
	$(INSTALL) -d "${DESTDIR}${prefix}/lib"
	$(INSTALL) $(DIR_BUILD)/$(LIB_SO_TABLE) "${DESTDIR}${prefix}/lib"
	$(LN) -sf ${DESTDIR}${prefix}/lib/$(LIB_SO_TABLE) ${DESTDIR}${prefix}/lib/lib${LIBNAME}.so
	$(INSTALL) -d "${DESTDIR}${prefix}/bin"
	$(INSTALL) $(DIR_BUILD)/$(TARGET) "${DESTDIR}${prefix}/bin"
	
uninstall :
	rm -f "${DESTDIR}${prefix}/lib/$(LIB_SO_TABLE)"
	rm -f "${DESTDIR}${prefix}/lib/lib${LIBNAME}.so"
	rm -f "${DESTDIR}${prefix}/bin/$(TARGET)"

test :
	$(TARGET)

clean : 
	rm -rf $(DIR_BUILD)

-include $(DEPFILES)

