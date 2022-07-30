return function()
	local Binding = require(script.Parent.Parent.Binding)
	local Type = require(script.Parent.Parent.Type)

	local createRef = require(script.Parent)

	it("should only expose a function", function()
		expect(createRef).to.be.a("function")
		expect(select("#", require(script.Parent))).to.equal(1)
	end)

	it("should create refs, which are specialized bindings", function()
		local ref = createRef()

		expect(Type.of(ref)).to.equal(Type.Binding)
		expect(ref.current).to.equal(nil)
	end)

	it("should have a 'current' field that is the same as the internal binding's value", function()
		local ref = createRef()

		expect(ref.current).to.equal(nil)

		Binding.update(ref, 10)
		expect(ref.current).to.equal(10)
	end)

	it("should support tostring on refs", function()
		local ref = createRef()

		expect(ref.current).to.equal(nil)
		expect(tostring(ref)).to.equal("RoactRef(nil)")

		Binding.update(ref, 10)
		expect(tostring(ref)).to.equal("RoactRef(10)")
	end)

	it("should not allow assignments to the 'current' field", function()
		local ref = createRef()

		expect(ref.current).to.equal(nil)

		Binding.update(ref, 99)
		expect(ref.current).to.equal(99)

		expect(function()
			ref.current = 77
		end).to.throw()

		expect(ref.current).to.equal(99)
	end)

	it("should return the same thing from getValue as its current field", function()
		local ref = createRef()
		Binding.update(ref, 10)

		expect(ref:getValue()).to.equal(10)
		expect(ref:getValue()).to.equal(ref.current)
	end)

	it("should throw an error on attempt to modify the ref", function()
		local ref = createRef()

		expect(function()
			ref._ = {}
		end).to.throw()

		expect(function()
			setmetatable(ref, {})
		end).to.throw()
	end)

	it("should throw an error on attempt to modify the metatable of ref", function()
		local meta = getmetatable(createRef())

		expect(function()
			meta._ = {}
		end).to.throw()

		expect(function()
			setmetatable(meta, {})
		end).to.throw()
	end)

	it("should return an empty table", function()
		local ref = createRef()

		expect(next(ref)).to.equal(nil)
		expect(#ref).to.equal(nil)
	end)

	it("should return table with known metatable", function()
		local meta = getmetatable(createRef())

		expect(function()
			for key, value in meta do
				assert(key == "__index" or key == "__newindex" or key == "__tostring")
				assert(type(value) == "function")
			end
		end).never.throw()
	end)
end
