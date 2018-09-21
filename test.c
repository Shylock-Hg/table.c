/*! \brief test demonstration of table 
 *  \author Shylock Hg
 *  \date 2018-09-21
 *  \email tcath2s@gmail.com
 * */

#include "table.h"

int main(int argc, char * argv[]){

	char * t[3][3] = {
		{
			"name", "gender", "age"  //!< header raw 0
		},
		{
			"shylock-hg", "male", "23"  //!< content raw 1
		},
		{
			"alice", "female", "19"  //!< content raw 2
		}
	};

	//!<  usage by dynamic alloc
	table_t * table = table_new(3, 3, 2, (char**)t);

	table_print(table);

	table_release(table);

	//!< usage by static alloc
	/*
	table_t table = {
		.table = (char**)t,
		.raw = 3,
		.column = 3,
		.space = 2
	};
	table_print(&table);
	*/

	return 0;
}

