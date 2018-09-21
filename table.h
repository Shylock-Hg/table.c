/*! \brief simple library of table implement of pure c language
 *  \author Shylock Hg
 *  \date 2018-09-21
 *  \email tcath2s@gmail.com
 * */

#ifndef _TABLE_H_
#define _TABLE_H_

#ifdef __cplusplus
	extern "C" {
#endif

#include <stddef.h>

typedef struct table {
	char ** table;  //!< table[raw][column]
	size_t raw;
	size_t column;
	size_t space;
} table_t;


table_t * table_new(size_t raw, size_t column, size_t space);

void table_release(table_t * table);

void table_print(table_t * table);


#ifdef __cplusplus
	}
#endif

#endif  //!< _TABLE_H_

