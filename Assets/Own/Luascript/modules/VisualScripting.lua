VisualScripting = {}

---@param gameObject GameObject
---@param event string
function VisualScripting:Trigger(gameObject, event, ...)
    local t = {...}
    local param = {}
    for index, value in ipairs(t) do
        if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
            table.insert(param, {
                value = value
            })
        elseif type(value) == "table" then
            if value.__cname then
                if value.__cname == "GameObject" or value.__cname == "Transform" or value.__cname == "Sprite" or value.__cname == "AudioClip" then
                    local p = {
                        type = value.__cname,
                        value = value:GetInstanceID()
                    }
                    table.insert( param, {
                        value = p
                    })
                elseif value.__cname == "Vector3" or value.__cname == "Vector2" or value.__cname == "Quaternion" or value.__cname == "Color" then
                    local p = {
                        type = value.__cname,
                        value = value:toTable()
                    }
                    table.insert( param, {
                        value = p
                    })
                elseif Lib.CheckTypeClass("Component", value) then
                    local p = {
                        type = "Component",
                        value = {
                            GameObject = value.gameObject:GetInstanceID(),
                            Component = value:GetInstanceID()
                        }
                    }
                    table.insert(param, {
                        value = p
                    })
                else
                    assert(false, "param không hợp lệ")    
                end
            else
                assert(false, "param không hợp lệ")
            end
        else
            assert(false, "param không hợp lệ")
        end
    end
    APIVisualScripting.Trigger(gameObject:GetInstanceID(), event, param)
end