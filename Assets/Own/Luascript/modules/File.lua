File = {}

function File:ReadAllBytes(path)
    return APIFile:ReadAllBytes(path)
end

function File:ReadAllText(path)
    return APIFile:ReadAllText(path)
end

function File:WriteAllBytes(path, base64)
    APIFile:WriteAllBytes(path, base64)
end

function File:WriteAllText(path, contents)
    APIFile:WriteAllText(path, contents)
end

function File:AppendAllText(path, contents)
    APIFile:AppendAllText(path, contents)
end

---@param callBack function
function File:OpenPanel(callBack,directory, extensions, multiselect)
    directory = directory or ""    
    -- {
    --     filterName = "Image Files",
    --     filterExtensions = {"png", "jpg", "jpeg"}
    -- }
    multiselect = multiselect or false
    APIFile:OpenPanel(callBack,directory, extensions, multiselect)
end