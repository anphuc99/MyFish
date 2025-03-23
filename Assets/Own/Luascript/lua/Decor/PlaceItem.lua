---@class PlaceItem : MonoBehaviour
---@field thumbnail Image
---@field id number
---@field UID number   
---@field removeButton Button
local PlaceItem = class("PlaceItem", MonoBehaviour)
PlaceItem.__path = __path

function PlaceItem:OnDestroy()
    self.removeButton:onClickRemoveAll()
end

function PlaceItem:SetEnableDrag()
    CsEvent:Emit("OnEnableDrag" .. self.gameObject:GetInstanceID())
end

function PlaceItem:SetDisableDrag()
    CsEvent:Emit("OnDisableDrag" .. self.gameObject:GetInstanceID())
end

_G.PlaceItem = PlaceItem