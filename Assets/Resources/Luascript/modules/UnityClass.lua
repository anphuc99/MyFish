---@class Unity
---@field require : function
Unity = {}
function Unity.DestroyObject(InstanceID)end
function Unity.DestroyComponent(InstanceIDGameObject, InstanceIDComponent)end
function Unity.SetEnableComponent(InstanceIDGameObject, InstanceIDComponent, enable)end
function Unity.SetObjectActive(InstanceIDGameObject, active)end
---@return Component
function Unity.AddComponent(InstanceIDGameObject, className)end
function Unity.TransformSetPosition(InsTransform, Vector3)end
function Unity.TransformMove(InsTransform, Vector3)end
function Unity.TransformStopMove(InsTransform)end
---@return Vector3
function Unity.TransformGetPosition(InsTransform)end
---@return Quaternion
function Unity.TransformGetRotation(InsTransform)end
function Unity.TransformSetRotation(InsTransform, Quaternion)end
function Unity.TransformSetSmootRote(InsTransform, Vector3)end
function Unity.TransformStopSmootRote(InsTransform)end


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