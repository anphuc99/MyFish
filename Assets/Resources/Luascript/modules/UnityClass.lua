---@class Unity
---@field require : function
Unity = {}
function Unity.DestroyObject(InstanceID)end
function Unity.DestroyComponent(InstanceIDGameObject, InstanceIDComponent)end
function Unity.SetEnableComponent(InstanceIDGameObject, InstanceIDComponent, enable)end


---@class UnityEvent
UnityEvent = {}
---@param InstanceID number
---@param eventNamem string
---@param func function
function UnityEvent.RegiterEvent(InstanceID, eventNamem, func)end

---@class Json
Json = {}
---@return string
function Json.encode(table)end
---@return table
function Json.decode(json)end