note
	description: "Summary description for {DATA_SET_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATA_SET_ITERATION_CURSOR[V1,V2,K->HASHABLE]
inherit
	ITERATION_CURSOR[DATA_SET[V1, V2, K]]

create
	make
feature{NONE}
	data_items_1:ARRAY[V1]
	data_items_2:HASH_TABLE[V2,K]
	keys: LINKED_LIST[K]
	cursor_pos:INTEGER



feature
	make(k:LINKED_LIST[K];d1:ARRAY[V1]; d2:HASH_TABLE[V2,K])
		do
			data_items_1 := d1
			data_items_2 := d2
			keys:=k
			keys.start

			cursor_pos := 1
		end

feature
	after:BOOLEAN
	do
		Result:= (cursor_pos > keys.count)
	end

    item: DATA_SET[V1, V2, K]
        local
            data_item_1: V1
            data_item_2: V2
            key: K
        do
            data_item_1 := data_items_1[cursor_pos]
            key := keys.item
            check attached data_items_2[keys.item] as data_item_2_safe then data_item_2 := data_item_2_safe end

            create {DATA_SET[V1, V2, K]} Result.make (data_item_1, data_item_2, key)
        end


	forth
	do
		cursor_pos := cursor_pos+1
		keys.forth
	end
end
