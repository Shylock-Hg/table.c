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

	/*
	table_t * table = table_new(3,3);
	*(table->table+0) = "name";
	*(table->table+1) = "gender";
	*(table->table+2) = "age";
	*(table->table+3) = "shylock-hg";
	*(table->table+4) = "male";
	*(table->table+5) = "23";
	*(table->table+6) = "alic";
	*(table->table+7) = "female";
	*(table->table+8) = "19";


	table_print(table);

	table_release(table);
	*/
	table_t table = {
		.table = (char**)t,
		.raw = 3,
		.column = 3,
		.space = 2
	};
	table_print(&table);

	return 0;
}

