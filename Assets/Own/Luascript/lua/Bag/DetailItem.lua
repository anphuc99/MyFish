---@class DetailItem : MonoBehaviour
---@field title TextMeshProGUI
---@field holder GameObject
---@field thumbnail Image
---@field description TextMeshProGUI
---@field button Button
local DetailItem = class("DetailItem", MonoBehaviour)
DetailItem.__path = __path

-- Các UID item không được sử dụng
DetailItem.prohibitUID = {
    143000
}

function DetailItem:SetValue(name, sprite, UID, description)
    self.title:SetText(name)
    self.thumbnail:SetSprite(sprite)
    self.description:SetText(description)
    self.button:onClickRemoveAll()
    self.button:onClickAddListener(
        function ()
            AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
            BagSocket:UseItem(UID)
        end
    )
    self:ShowDetail(true)
end

function DetailItem:ShowDetail(bool)
	self.title.gameObject:SetActive(bool)
	self.holder:SetActive(bool)
	self.description.gameObject:SetActive(bool)
	self.button.gameObject:SetActive(bool)
	self.button.gameObject:SetActive(bool)
end

function DetailItem:BlockUse()
    if self.button.gameObject:GetActive() == true then
        self.button.gameObject:SetActive(false)
    end
end

_G.DetailItem = DetailItem