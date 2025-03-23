---@class Unity
---@field require : function
Unity = {}

Unity.IsEditor = false;
Unity.IsAndroid = false;
Unity.IsPC = false

function Unity.DestroyObject(InstanceID)end
function Unity.DestroyComponent(InstanceIDGameObject, InstanceIDComponent)end
function Unity.SetEnableComponent(InstanceIDGameObject, InstanceIDComponent, enable)end
function Unity.SetObjectActive(InstanceIDGameObject, active)end
function Unity.InstantiateLuaObject(InstanceIDGameObject)end
---@return Component
function Unity.AddComponent(InstanceIDGameObject, className)end
function Unity.TransformSetPosition(InsTransform, Vector3)end
function Unity.TransformMove(InsTransform, Vector3)end
function Unity.TransformStopMove(InsTransform)end
---@return Vector3
function Unity.TransformGetPosition(InsTransform)end
---@return Vector3
function Unity.RectTransformGetAnchoredPosition(InsTransform)end
function Unity.RectTransformSetAnchoredPosition(InsTransform, vector3)end
function Unity.RectTransformGetRect(InsTransform)end
---@return Quaternion
function Unity.TransformGetRotation(InsTransform)end
function Unity.TransformSetRotation(InsTransform, Quaternion)end
function Unity.TransformSetSmootRote(InsTransform, Vector3)end
function Unity.TransformStopSmootRote(InsTransform)end
---@return number
function Unity.TransformGetChildCount(InsTransform)end
---@return table
function Unity.TransformGetChild(InsTransform, index)end
---@return table
function Unity.TransformGetAllChild(InsTransform)end
---@return table
function Unity.TransformGetParent(InsTransform)end
function Unity.TransformSetParent(InsTransform, InsTransformParent, worldPositionStays)end
---@return Vector3
function Unity.TransformGetLocalPosition(InsTransform)end
function Unity.TransformSetLocalPosition(InsTransform, Vector3)end
function Unity.TransformLockAt(InsTransform, Vector3)end
function Unity.UISetImage(spriteID, InstanceIDGameObject, InstanceIDComponent)end
function Unity.SpriteRendererSetSprite(spriteID, InstanceIDGameObject, InstanceIDComponent)end
function Unity.SpriteRendererSetFilpX(InstanceIDGameObject, InstanceIDComponent, bol)end
function Unity.SpriteRendererSetFilpY(InstanceIDGameObject, InstanceIDComponent, bol)end
function Unity.SpriteRendererGetFilpX(InstanceIDGameObject, InstanceIDComponent)end
function Unity.SpriteRendererGetFilpY(InstanceIDGameObject, InstanceIDComponent)end
function Unity.UISetText(text, InstanceIDGameObject, InstanceIDComponent)end
function Unity.UIInputFieldSetText(text, InstanceIDGameObject, InstanceIDComponent)end
---@return string
function Unity.UIInputFieldGetText(InstanceIDGameObject, InstanceIDComponent)end
function Unity.UISetTextMeshPro(text, InstanceIDGameObject, InstanceIDComponent)end
function Unity.SetTextMeshProColor(color, InstanceIDGameObject, InstanceIDComponent)end
function Unity.UISetSliderValue(value, InstanceIDGameObject, InstanceIDComponent)end
function Unity.UISetMinSliderValue(value, InstanceIDGameObject, InstanceIDComponent)end
function Unity.UISetMaxSliderValue(value, InstanceIDGameObject, InstanceIDComponent)end
function Unity.UISmootSliderValue(InstanceIDGameObject, InstanceIDComponent, toValue, time, leanTweenType, callback)end
function Unity.UIScrollBarSetValue(value, InstanceIDGameObject, InstanceIDComponent)end
function Unity.UIButtonSetInteractable(interactable, InstanceIDGameObject, InstanceIDComponent)end
function Unity.UIButtonGetInteractable(InstanceIDGameObject, InstanceIDComponent)end
function Unity.UISmootScrollBaValue(InstanceIDGameObject, InstanceIDComponent, toValue, time, leanTweenType, callback)end
function Unity.LeanTweenMove(InsGameObject, v3To, time)end
function Unity.LeanTweenLocalMove(InsGameObject, v3To, time)end
function Unity.LeanTweenScale(InsGameObject, v3To, time)end
function Unity.LeanTweenRotate(InsGameObject, v3To, time)end
function Unity.LeanTweenMoveX(InsGameObject, v3X, time)end
function Unity.LeanTweenMoveY(InsGameObject, v3Y, time)end
function Unity.LeanTweenMoveZ(InsGameObject, v3Z, time)end
function Unity.LeanTweenLocalMoveX(InsGameObject, v3X, time)end
function Unity.LeanTweenLocalMoveY(InsGameObject, v3Y, time)end
function Unity.LeanTweenLocalMoveZ(InsGameObject, v3Z, time)end
function Unity.LeanTweenScaleX(InsGameObject, v3X, time)end
function Unity.LeanTweenScaleY(InsGameObject, v3Y, time)end
function Unity.LeanTweenScaleZ(InsGameObject, v3Z, time)end
function Unity.LeanTweenRotateX(InsGameObject, v3X, time)end
function Unity.LeanTweenRotateY(InsGameObject, v3Y, time)end
function Unity.LeanTweenRotateZ(InsGameObject, v3Z, time)end
function Unity.LeanTweenColor(InsGameObject, color, time)end
function Unity.LeanTweenValue(from, to, time, func)end
function Unity.LeanTweenCancel(InsGameObject)end
function Unity.ExecuteFunctionLTDescr(tweenID, functionName, value)end
function Unity.SocketIOOn(event, func)end
function Unity.SocketIOOff(event)end
function Unity.SocketIOSendMessage(event, message, callback)end
function Unity.SocketIOHttp(url, message, callback, callbackError)end
function Unity.SceneLoaderLoadScene(scene)end


---@class UnityEvent
UnityEvent = {}
---@param InstanceID number
---@param eventNamem string
---@param func function
function UnityEvent.RegiterEvent(InstanceID, eventNamem, func)end
function UnityEvent.UnRegiterEvent(InstanceID, eventNamem, func)end