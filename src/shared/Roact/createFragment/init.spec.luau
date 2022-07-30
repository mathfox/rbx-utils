return function()
	local ElementKind = require(script.Parent.Parent.ElementKind)
	local Type = require(script.Parent.Parent.Type)

	local createFragment = require(script.Parent)

	it("should expose a function", function()
		expect(createFragment).to.be.a("function")
	end)

	it("should throw an error on attempt to modify the fragment", function()
		local fragment = createFragment({})

		expect(function()
			fragment._ = {}
		end).to.throw()

		expect(function()
			setmetatable(fragment, {})
		end).to.throw()
	end)

	it("should create new primitive elements", function()
		local fragment = createFragment({})

		expect(fragment).to.be.ok()
		expect(Type.of(fragment)).to.equal(Type.Element)
		expect(ElementKind.of(fragment)).to.equal(ElementKind.Fragment)
	end)

	it("should accept children", function()
		local subFragment = createFragment({})
		local fragment = createFragment({ key = subFragment })

		expect(fragment.elements.key).to.equal(subFragment)
	end)
end
