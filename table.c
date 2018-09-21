#include <assert.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "table.h"

//typedef char** table_t;
typedef struct length_array {
	size_t * value;
	size_t length;
} length_array_t;


table_t * table_new(size_t raw, size_t column, size_t space){
	assert(raw);
	assert(column);

	table_t * table = malloc(sizeof(table_t));
	assert(table);

	table->table = calloc(sizeof(char*), raw*column);
	assert(table->table);

	table->raw = raw;
	table->column = column;
	table->space =space;

	return table;
}

void table_release(table_t * table){
	assert(table);

	free(table->table);
	free(table);
}


length_array_t * length_array_new(size_t length){
	assert(length);

	length_array_t * lr = malloc(sizeof(length_array_t));
	assert(lr);

	lr->value = calloc(sizeof(size_t), length);
	assert(lr->value);

	lr->length = length;

	return lr;
}

void length_array_release(length_array_t * lr){
	assert(lr);

	free(lr->value);
	free(lr);
}

uintptr_t _table_max_of_array(size_t * array, size_t length){
	assert(array);

	size_t max = 0;

	for(int i=0; i<length; i++){
		if(max < array[i]){
			max = array[i];
		}
	}

	return max;
}

length_array_t * table_column_width(table_t * table){
	assert(table);
	assert(table->table);

	length_array_t * lr = length_array_new(table->column);
	assert(lr);
	for(size_t i=0; i<table->column; i++){
		for(size_t j=0; j<table->raw; j++){
			if(lr->value[i] < strlen(*(table->table+(j*table->raw)+i))){
				lr->value[i] = strlen(*(table->table+(j*table->raw)+i));
			}
		}
	}

	return lr;
}

void table_print(table_t * table){
	char format[1024] = {0};

	assert(table);

	length_array_t * lr = table_column_width(table);

	for(size_t i=0; i<table->raw; i++){
		for(size_t j=0; j<table->column; j++){
			snprintf(format, sizeof(format), "%%%lus", lr->value[j]+table->space);
			//printf("Fomat is `%s`\n", format);
			printf(format, *(table->table+i*table->raw+j));
		}
		putchar('\n');
	}

	length_array_release(lr);
}


