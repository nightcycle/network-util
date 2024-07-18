--!strict
--!native
local _Package = script
local _Packages = _Package.Parent
-- Services
local RunService = game:GetService("RunService")
-- stylua: ignore start
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
-- Modules
-- stylua: ignore end
-- Types
type Maid = Maid.Maid
-- Constants
-- Variables
-- References
-- Private Functions
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

-- Interface
local NetworkUtil = {}
NetworkUtil.__index = NetworkUtil

function NetworkUtil.getRemoteEvent(key: string, parent: Instance?): RemoteEvent
	parent = parent or script
	assert(parent ~= nil)
	if RunService:IsServer() then
		return getInstance(key, "RemoteEvent", parent)
	else
		local inst = parent:WaitForChild(key)
		assert(inst:IsA("RemoteEvent"))
		return inst
	end
end

function NetworkUtil.getUnreliableRemoteEvent(key: string, parent: Instance?): UnreliableRemoteEvent
	parent = parent or script
	assert(parent ~= nil)
	if RunService:IsServer() then
		return getInstance(key, "UnreliableRemoteEvent", parent)
	else
		local inst = parent:WaitForChild(key)
		assert(inst:IsA("UnreliableRemoteEvent"))
		return inst
	end
end

function NetworkUtil.getRemoteFunction(key: string, parent: Instance?): RemoteFunction
	parent = parent or script
	assert(parent ~= nil)
	if RunService:IsServer() then
		return getInstance(key, "RemoteFunction", parent)
	else
		local inst = parent:WaitForChild(key)
		assert(inst:IsA("RemoteFunction"))
		return inst
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

function NetworkUtil.onClientEventAt(key: string, parent: Instance, func: (...unknown?) -> ()): () -> ()
	assert(RunService:IsClient())
	local maid = Maid.new()
	local remEv = NetworkUtil.getRemoteEvent(key, parent)
	maid:GiveTask(remEv.OnClientEvent:Connect(func))

	return function()
		maid:Destroy()
	end
end

function NetworkUtil.onUnreliableClientEventAt(
	key: string,
	parent: Instance,
	func: (...unknown?) -> ()
): () -> ()
	assert(RunService:IsClient())
	local maid = Maid.new()
	local remEv = NetworkUtil.getUnreliableRemoteEvent(key, parent)
	maid:GiveTask(remEv.OnClientEvent:Connect(func))

	return function()
		maid:Destroy()
	end
end

function NetworkUtil.onClientEvent(key: string, func: (...unknown?) -> ()): () -> ()
	return NetworkUtil.onClientEventAt(key, script, func)
end

function NetworkUtil.onUnreliableClientEvent(key: string, func: (...unknown?) -> ()): () -> ()
	return NetworkUtil.onUnreliableClientEventAt(key, script, func)
end

function NetworkUtil.onServerEventAt(
	key: string,
	parent: Instance,
	func: (player: Player, ...unknown?) -> ()
): () -> ()
	assert(RunService:IsServer())
	local maid = Maid.new()
	local remEv = NetworkUtil.getRemoteEvent(key, parent)
	maid:GiveTask(remEv.OnServerEvent:Connect(func))

	return function()
		maid:Destroy()
	end
end

function NetworkUtil.onUnreliableServerEventAt(
	key: string,
	parent: Instance,
	func: (player: Player, ...unknown?) -> ()
): () -> ()
	assert(RunService:IsServer())
	local maid = Maid.new()
	local remEv = NetworkUtil.getUnreliableRemoteEvent(key, parent)
	maid:GiveTask(remEv.OnServerEvent:Connect(func))

	return function()
		maid:Destroy()
	end
end

function NetworkUtil.onServerEvent(key: string, func: (player: Player, ...unknown?) -> ()): () -> ()
	return NetworkUtil.onServerEventAt(key, script, func)
end

function NetworkUtil.onUnreliableServerEvent(key: string, func: (player: Player, ...unknown?) -> ()): () -> ()
	return NetworkUtil.onUnreliableServerEventAt(key, script, func)
end

function NetworkUtil.fireServerAt(key: string, parent: Instance, ...: unknown?): ()
	assert(RunService:IsClient())
	local remEv = NetworkUtil.getRemoteEvent(key, parent)
	remEv:FireServer(...)
end

function NetworkUtil.fireServer(key: string, ...: unknown?): ()
	return NetworkUtil.fireServerAt(key, script, ...)
end

function NetworkUtil.fireUnreliableServerAt(key: string, parent: Instance, ...: unknown?): ()
	assert(RunService:IsClient())
	local remEv = NetworkUtil.getUnreliableRemoteEvent(key, parent)
	remEv:FireServer(...)
end

function NetworkUtil.fireUnreliableServer(key: string, ...: unknown?): ()
	return NetworkUtil.fireUnreliableServerAt(key, script, ...)
end

function NetworkUtil.fireClientAt(key: string, parent: Instance, player: Player, ...: unknown?): ()
	assert(RunService:IsServer())
	local remEv = NetworkUtil.getRemoteEvent(key, parent)
	remEv:FireClient(player, ...)
end

function NetworkUtil.fireClient(key: string, player: Player, ...: unknown?): ()
	return NetworkUtil.fireClientAt(key, script, player, ...)
end

function NetworkUtil.fireUnreliableClientAt(key: string, parent: Instance, player: Player, ...: unknown?): ()
	assert(RunService:IsServer())
	local remEv = NetworkUtil.getUnreliableRemoteEvent(key, parent)
	remEv:FireClient(player, ...)
end

function NetworkUtil.fireUnreliableClient(key: string, player: Player, ...: unknown?): ()
	return NetworkUtil.fireUnreliableClientAt(key, script, player, ...)
end

function NetworkUtil.fireAllClientsAt(key: string, parent: Instance, ...: unknown?): ()
	assert(RunService:IsServer())
	local remEv = NetworkUtil.getRemoteEvent(key, parent)
	remEv:FireAllClients(...)
end

function NetworkUtil.fireAllClients(key: string, ...: unknown?): ()
	return NetworkUtil.fireAllClientsAt(key, script, ...)
end

function NetworkUtil.fireAllUnreliableClientsAt(key: string, parent: Instance, ...: unknown?): ()
	assert(RunService:IsServer())
	local remEv = NetworkUtil.getUnreliableRemoteEvent(key, parent)
	remEv:FireAllClients(...)
end

function NetworkUtil.fireAllUnreliableClients(key: string, ...: unknown?): ()
	return NetworkUtil.fireAllUnreliableClientsAt(key, script, ...)
end

function NetworkUtil.invokeServerAt<V>(key: string, parent: Instance, ...: unknown?): V
	assert(RunService:IsClient())
	local remFun = NetworkUtil.getRemoteFunction(key, parent)
	return remFun:InvokeServer(...)
end

function NetworkUtil.invokeServer<V>(key: string, ...: unknown?): V
	return NetworkUtil.invokeServerAt(key, script, ...)
end

function NetworkUtil.invokeClientAt<V>(key: string, parent: Instance, player: Player, ...: unknown?): V
	assert(RunService:IsServer())
	local remFun = NetworkUtil.getRemoteFunction(key, parent)
	return remFun:InvokeClient(player, ...)
end

function NetworkUtil.invokeClient<V>(key: string, player: Player, ...: unknown?): V
	return NetworkUtil.invokeClientAt(key, script, player, ...)
end

function NetworkUtil.onClientInvokeAt<V>(key: string, parent: Instance, func: (...unknown?) -> V): ()
	assert(RunService:IsClient())
	local remFun = NetworkUtil.getRemoteFunction(key, parent)
	remFun.OnClientInvoke = func
end

function NetworkUtil.onClientInvoke<V>(key: string, func: (...unknown?) -> V): ()
	return NetworkUtil.onClientInvokeAt(key, script, func)
end

function NetworkUtil.onServerInvokeAt<V>(
	key: string,
	parent: Instance,
	func: (player: Player, ...unknown?) -> V
): ()
	assert(RunService:IsServer())
	local remFun = NetworkUtil.getRemoteFunction(key, parent)
	remFun.OnServerInvoke = func
end

function NetworkUtil.onServerInvoke<V>(key: string, func: (player: Player, ...unknown?) -> V): ()
	return NetworkUtil.onServerInvokeAt(key, script, func)
end

return NetworkUtil
