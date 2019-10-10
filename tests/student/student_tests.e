note
	description: "Tests created by student"
	author: "You"
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS

inherit
	ES_TEST
--	redefine
--		setup, teardown
--	end

create
	make

feature -- Add tests

	make
		do

			add_boolean_case (agent test_setup)
			add_boolean_case(agent test_iterable_repository)
			add_boolean_case(agent test_iteration_cursor)
			add_boolean_case(agent test_another_cursor)
			add_boolean_case(agent test_matching_keys)
			add_boolean_case(agent test_check_out)

		end


feature -- Tests

	test_setup: BOOLEAN
		local
			repos: REPOSITORY[STRING, CHARACTER, INTEGER]
			tuples: LINKED_LIST[TUPLE[d1: CHARACTER; d2: INTEGER; k: STRING]]
		do
			comment ("test_setup: test the initial repository")
			create repos.make
			repos.check_in ('a', 1, "A")
			repos.check_in ('b', 2, "B")
			repos.check_in ('c', 3, "C")
			repos.check_in ('d', 4, "D")

			Result:=repos.keys.first~ "A" and repos.keys[2]~ "B" and repos.keys[3]~ "C" and repos.keys[4]~ "D"
			check Result end

		end

	test_iterable_repository: BOOLEAN
		local
			repos: REPOSITORY[STRING, CHARACTER, INTEGER]
			tuples: ARRAY[TUPLE[CHARACTER, INTEGER, STRING]]
		do
			comment ("test_iterable_repository: test iterating through repository")
			create tuples.make_empty
			create repos.make
			repos.check_in ('a', 1, "A")
			repos.check_in ('b', 2, "B")
			repos.check_in ('c', 3, "C")
			repos.check_in ('d', 4, "D")
			across
				repos is tuple
			loop
				tuples.force (tuple, tuples.count + 1)
			end
			Result :=
					 	repos.count = 4
				 and	 tuples.count = 4
				-- Note: Look at the type declaration of local variable 'tuples',
				-- where no names are given to 1st, 2nd, and 3rd elements.
				-- So we can only write 'item(1)', 'item(2)', and 'item(3)'.
				 and	tuples[1].item (1) = 'a' and tuples[1].item(2) = 1 and tuples[1].item(3) ~ "A"
				 and	tuples[2].item (1) = 'b' and tuples[2].item(2) = 2 and tuples[2].item(3) ~ "B"
				 and 	tuples[3].item (1) = 'c' and tuples[3].item(2) = 3 and tuples[3].item(3) ~ "C"
				 and tuples[4].item (1) = 'd' and tuples[4].item(2) = 4 and tuples[4].item(3) ~ "D"
		end

	test_iteration_cursor: BOOLEAN
		local
			repos: REPOSITORY[STRING, CHARACTER, INTEGER]
			tic: TUPLE_ITERATION_CURSOR[STRING, CHARACTER, INTEGER]
			tuples: ARRAY[TUPLE[CHARACTER, INTEGER, STRING]]
		do
			comment ("test_iteration_cursor: test the returned cursor from repository")
			create repos.make
			repos.check_in ('a', 1, "A")
			repos.check_in ('b', 2, "B")
			repos.check_in ('c', 3, "C")
			repos.check_in ('d', 4, "D")
			create tuples.make_empty
			-- Static type of repos.new_cursor is ITERATION_CURSOR, and given that
			-- its dynamic type is TUPLE_ITERATION_CURSOR, we can do a type cast.
			check  attached {TUPLE_ITERATION_CURSOR[STRING, CHARACTER, INTEGER]} repos.new_cursor as nc then
				tic := nc
			end
			from
				-- no need to say tic.start here!
			until
				tic.after
			loop
				tuples.force (tic.item, tuples.count + 1)
				tic.forth
			end
			Result :=
					 tuples.count = 4
				 and	tuples[1].item (1) = 'a' and tuples[1].item(2) = 1 and tuples[1].item(3) ~ "A"
				 and	tuples[2].item (1) = 'b' and tuples[2].item(2) = 2 and tuples[2].item(3) ~ "B"
				 and tuples[3].item (1) = 'c' and tuples[3].item(2) = 3 and tuples[3].item(3) ~ "C"
				 and tuples[4].item (1) = 'd' and tuples[4].item(2) = 4 and tuples[4].item(3) ~ "D"
		end

	test_another_cursor: BOOLEAN
		local
			repos: REPOSITORY[STRING, CHARACTER, INTEGER]
			ric: DATA_SET_ITERATION_CURSOR[CHARACTER, INTEGER, STRING]
			entries: ARRAY[DATA_SET[CHARACTER, INTEGER, STRING]]
		do
			comment ("test_another_cursor: test the alternative returned cursor from repository")
			create repos.make
			repos.check_in ('a', 1, "A")
			repos.check_in ('b', 2, "B")
			repos.check_in ('c', 3, "C")
			repos.check_in ('d', 4, "D")
			create entries.make_empty
			-- Static type of repos.another_cursor is ITERATION_CURSOR, and given that
			-- its dynamic type is DATA_SET_ITERATION_CURSOR, we can do a type cast.
			check attached {DATA_SET_ITERATION_CURSOR[CHARACTER, INTEGER, STRING]} repos.another_cursor as nc then
				ric := nc
			end
			from
			until
				ric.after
			loop
				entries.force (ric.item, entries.count + 1)
				ric.forth
			end
			Result :=
						entries.count = 4
						-- Note that the right-hand side of ~ are anonymous objects.
				 and	entries [1] ~ (create {DATA_SET[CHARACTER, INTEGER, STRING]}.make ('a', 1, "A"))
				 and	entries [2] ~ (create {DATA_SET[CHARACTER, INTEGER, STRING]}.make ('b', 2, "B"))
				 and	entries [3] ~ (create {DATA_SET[CHARACTER, INTEGER, STRING]}.make ('c', 3, "C"))
				 and	entries [4] ~ (create {DATA_SET[CHARACTER, INTEGER, STRING]}.make ('d', 4, "D"))
		end

	test_matching_keys: BOOLEAN
		local
			repos: REPOSITORY[STRING, CHARACTER, INTEGER]
			keys: ARRAY[STRING]
		do
			comment ("test_matching_keys: test iterable keys")

			create repos.make
			repos.check_in ('a', 1, "A")
			repos.check_in ('b', 2, "B")
			repos.check_in ('c', 3, "C")
			repos.check_in ('d', 4, "D")

			create keys.make_empty
			repos.check_in ('a', 1, "E")

			create keys.make_empty
			across
				repos.matching_keys ('a', 1) as k
			loop
				keys.force (k.item, keys.count + 1)
			end
			Result :=
						keys.count = 2
				 and	keys[1] ~ "A"
				 and 	keys[2] ~ "E"
			check Result end
		end

	test_check_out: BOOLEAN
		local
			repos: REPOSITORY[STRING, CHARACTER, INTEGER]
			tuples: LINKED_LIST[TUPLE[d1: CHARACTER; d2: INTEGER; k: STRING]]
		do
			comment ("test_check_out: test data set deletion")
			create repos.make
			repos.check_in ('a', 1, "A")
			repos.check_in ('b', 2, "B")
			repos.check_in ('c', 3, "C")
			repos.check_in ('d', 4, "D")
			repos.check_out ("B")
			create tuples.make
			across
				repos as tuple_cursor
			loop
				tuples.extend (tuple_cursor.item)
			end

			Result :=
						repos.count = 3
				and 	tuples.count = 3
				-- Note: Look at the type declaration of local variable 'tuples',
				-- where 1st element has name 'd1', 2nd element 'd2', and 3rd element 'k'.
				-- So we can use 'd1', 'd2', and 'k' to access tuple elements here,
				-- equivalent to writing 'item(1)', 'item(2)', and 'item(3)'.
				and	tuples[1].d1 ~ 'a' and tuples[1].d2 ~ 1 and tuples[1].k ~ "A"
				and	tuples[2].d1 ~ 'c' and tuples[2].d2 ~ 3 and tuples[2].k ~ "C"
				and	tuples[3].d1 ~ 'd' and tuples[3].d2 ~ 4 and tuples[3].k ~ "D"
		end

end
