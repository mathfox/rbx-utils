return function()
	local StarterGuiUtils = require(script.Parent)

	it("should be a table", function()
		expect(StarterGuiUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(StarterGuiUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			StarterGuiUtils.newField = {}
		end).to.throw()

		expect(function()
			setmetatable(StarterGuiUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			setAllCoreGuisEnabledIgnore = "function",
			setCoreGuisEnabled = "function",
		}

		expect(function()
			for key, value in StarterGuiUtils do
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
