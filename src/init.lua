--!strict
local Package = script
local Packages = Package.Parent
local _RunService = game:GetService("RunService")
local _Maid = require(Packages.Maid)
local _Signal = require(Packages.Signal)

local NetworkUtil = {}
NetworkUtil.__index = NetworkUtil

local function getInstance(key: string, className: string, parent: Instance): any
	local cur = parent:FindFirstChild(key)
	if cur then
		if cur:IsA(className) then
			return cur
		else
			error(cur.ClassName .. " key [" .. key .. "] can't be reused as a " .. tostring(className))
		end
	else
		local newInst = Instance.new(className :: any)
		newInst.Name = key
		newInst.Parent = parent
		return newInst
	end
end

function NetworkUtil.getRemoteEvent(key: string, parent: Instance?): RemoteEvent
	parent = parent or script
	assert(parent ~= nil)
	if _RunService:IsServer() then
		return getInstance(key, "RemoteEvent", parent)
	else
		return parent:WaitForChild(key) :: any
	end
end

function NetworkUtil.getRemoteFunction(key: string, parent: Instance?): RemoteFunction
	parent = parent or script
	assert(parent ~= nil)
	if _RunService:IsServer() then
		return getInstance(key, "RemoteFunction", parent)
	else
		return parent:WaitForChild(key) :: any
	end
end

function NetworkUtil.getBindableEvent(key: string, parent: Instance?): BindableEvent
	parent = parent or script
	assert(parent ~= nil)
	return parent:FindFirstChild(key) or getInstance(key, "BindableEvent", parent)
end

function NetworkUtil.getBindableFunction(key: string, parent: Instance?): BindableFunction
	parent = parent or script
	assert(parent ~= nil)
	return parent:FindFirstChild(key) or getInstance(key, "BindableFunction", parent)
end


return NetworkUtil
