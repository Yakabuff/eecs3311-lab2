note
	description: "Summary description for {TUPLE_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_ITERATION_CURSOR[KEY->HASHABLE,DATA1,DATA2]
inherit
	ITERATION_CURSOR[TUPLE[DATA1,DATA2,KEY]]

create
	make

feature
	make( d1:ARRAY[DATA1]; d2:HASH_TABLE[DATA2,KEY];k:LINKED_LIST[KEY])
	do
		keys:= k
		data1:= d1
		data2:=d2
		cursor_pos := 1
	end
feature {NONE} --underlying arrays
	keys:LINKED_LIST[KEY]
	data1:ARRAY[DATA1]
	data2:HASH_TABLE[DATA2,KEY]
	cursor_pos:INTEGER
feature
	after:BOOLEAN
		do
			Result:= (cursor_pos > keys.count)
		end

	item: TUPLE[DATA1,DATA2,KEY]
		local
			key:KEY
			d1:DATA1
			d2:DATA2

		do
			key := keys[cursor_pos]
			d1 := data1[cursor_pos]
			d2 := data2[key]
			create Result
			check attached data2[key] as d2_safe then d2 := d2_safe end
			Result := [d1,d2,key]

		end

	forth
	--MOve cursor position 1 to the right
		do
			cursor_pos := cursor_pos+1
		end

invariant
	consistent_arrays:

end
