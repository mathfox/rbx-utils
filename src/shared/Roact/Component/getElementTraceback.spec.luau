return function()
	local createReconciler = require(script.Parent.Parent.createReconciler)
	local NoopRenderer = require(script.Parent.Parent.NoopRenderer)

	local Component = require(script.Parent.Parent.Component)

	local noopReconciler = createReconciler(NoopRenderer)

	it("should return stack traces in initial renders", function()
		local awaitingCoroutine: thread? = nil
		local isUpdated = script.Parent.Parent.createElement.Source:find(":elementTracing:") ~= nil

		if not isUpdated then
			local connection = nil
			connection = script.Parent.Parent.createElement:GetPropertyChangedSignal("Source"):Connect(function()
				if script.Parent.Parent.createElement.Source:find(":elementTracing:") then
					connection:Disconnect()

					isUpdated = true

					if awaitingCoroutine then
						coroutine.resume(awaitingCoroutine)
					end
				end
			end)

			game.ServerStorage.IgnoreCodeBlocks.Roact:SetAttribute("elementTracing", false)

			awaitingCoroutine = coroutine.running()

			coroutine.yield()
		end

		local createElement = script.Parent.Parent.createElement:Clone()
		script.Parent.Parent.createElement:Destroy()
		createElement.Parent = script.Parent.Parent

		createElement = require(createElement)

		local TestComponent = Component:extend("TestComponent")

		local stackTrace
		function TestComponent:init()
			stackTrace = self:getElementTraceback()
		end

		function TestComponent:render()
			return nil
		end

		local element = createElement(TestComponent)
		local hostParent = nil
		local key = "Some key"

		noopReconciler.mountVirtualNode(element, hostParent, key)

		expect(stackTrace).to.be.a("string")
	end)

	itSKIP("it should return an updated stack trace after an update", function() end)

	it("should return nil when elementTracing is off", function()
		-- TODO: scoped function API from ignore code blocks
		-- IgnoreCodeBlocks.scoped(script.Parent.Parent.createElement, {
		-- 	Roact = {
		-- 		elementTracing = true,
		-- 	},
		-- }, function(module)
		-- 	local stackTrace = nil

		-- 	local createElement = require(module)

		-- 	local TestComponent = Component:extend("TestComponent")

		-- 	function TestComponent:init()
		-- 		stackTrace = self:getElementTraceback()
		-- 	end

		-- 	function TestComponent:render()
		-- 		return nil
		-- 	end

		-- 	local element = createElement(TestComponent)
		-- 	local hostParent = nil
		-- 	local key = "Some key"

		-- 	noopReconciler.mountVirtualNode(element, hostParent, key)

		-- 	expect(stackTrace).to.equal(nil)
		-- end)

		local stackTrace = nil

		local awaitingCoroutine: thread? = nil
		local isUpdated = not script.Parent.Parent.createElement.Source:find(":elementTracing:")

		if not isUpdated then
			local connection = nil
			connection = script.Parent.Parent.createElement:GetPropertyChangedSignal("Source"):Connect(function()
				if not script.Parent.Parent.createElement.Source:find(":elementTracing:") then
					connection:Disconnect()

					isUpdated = true

					if awaitingCoroutine then
						coroutine.resume(awaitingCoroutine)
					end
				end
			end)

			game.ServerStorage.IgnoreCodeBlocks.Roact:SetAttribute("elementTracing", true)

			awaitingCoroutine = coroutine.running()

			coroutine.yield()
		end

		local createElement = script.Parent.Parent.createElement:Clone()
		script.Parent.Parent.createElement:Destroy()
		createElement.Parent = script.Parent.Parent

		createElement = require(createElement)

		local TestComponent = Component:extend("TestComponent")

		function TestComponent:init()
			stackTrace = self:getElementTraceback()
		end

		function TestComponent:render()
			return nil
		end

		local element = createElement(TestComponent)
		local hostParent = nil
		local key = "Some key"

		noopReconciler.mountVirtualNode(element, hostParent, key)

		expect(stackTrace).to.equal(nil)
	end)
end
