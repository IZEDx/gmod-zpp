local utils = import("libs/utils")
local test = import("libs/test")
local describe, it, expect = test.describe, test.it, test.expect

local function is(truthy, val, fname, ...)
	local args = {...}
	return function()
		local o = utils.Is(val)
	    expect(o[fname](o, unpack(args)))[truthy and "to" or "to_not"].be.truthy()
	end
end

local istrue = Z.compose(is, true)
local isfalse = Z.compose(is, false)

describe("utils", function()
	describe("Is", function()
		it("str_str", istrue("A string", "str"))
		it("str_nostr", isfalse(1234, "str"))

		it("num_num", istrue(1234, "num"))
		it("num_nonum", isfalse("A string", "num"))

		it("bool_bool", istrue(false, "bool"))
		it("bool_nobool", isfalse("A string", "bool"))

		it("fn_fn", istrue(function() end, "fn"))
		it("fn_nofn", isfalse("A string", "fn"))

		it("tbl_tbl", istrue({}, "tbl"))
		it("tbl_notbl", isfalse("A string", "tbl"))

		--it("ud_ud", istrue(, "ud"))
		it("ud_noud", isfalse("A string", "ud"))

		it("valid_nil", isfalse(nil, "valid"))
		it("valid_emptystr", isfalse("", "valid"))
		it("valid_negative", isfalse(-1, "valid"))
		it("valid_false", isfalse(false, "valid"))
		it("valid_str", istrue("A string", "valid"))
		it("valid_num", istrue(1234, "valid"))
		it("valid_bool", istrue(true, "valid"))

		it("int_notnum", isfalse("A string", "int"))
		it("int_float", isfalse(3.1415, "int"))
		it("int_int", istrue(50, "int"))
		it("int_negint", istrue(-50, "int"))
		it("int_zero", istrue(0, "int"))

		it("size_sizenonum", isfalse({}, "size", "A string"))
		it("size_wrongtype", isfalse(1234, "size", 1))
		it("size_falsetbl", isfalse({1,2,3}, "size", 2))
		it("size_truestr", istrue("123", "size", 3))
	end)
end)