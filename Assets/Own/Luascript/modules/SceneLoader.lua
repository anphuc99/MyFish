SceneLoader = {}

function SceneLoader:Load(scene)
    self.curScene = scene
    APISceneLoader.Load(scene)
end

function SceneLoader:LoadCurScene()
    if self.curScene then
        APISceneLoader.Load(self.curScene)
    end
end

function SceneLoader:LoadData()
    APISceneLoader.LoadData()    
end

function SceneLoader:SetValue(value)
    APISceneLoader.SetValue(value)        
end