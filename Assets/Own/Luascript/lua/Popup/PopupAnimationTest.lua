
---@class PopupAnimationTest : MonoBehaviour
local PopupAnimationTest = class("PopupAnimationTest", MonoBehaviour)
PopupAnimationTest.__path = __path

function PopupAnimationTest:OnShow(view,onComplete)
    view.transform:SetLocalPosition(Vector3.new(0,1000,0))
    LeanTween:moveLocal(view.gameObject, Vector3.zero, 0.5):setOnComplete(function ()
        onComplete()
    end)
end

function PopupAnimationTest:OnHide(view,onComplete)
    LeanTween:moveLocal(view.gameObject, Vector3.new(0,1000,0), 0.5):setOnComplete(function ()
        onComplete()
    end)
end

_G.PopupAnimationTest = PopupAnimationTest
