using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using System.Threading.Tasks;
using MoonSharp.Interpreter;
using System;

[MoonSharpUserData]
public class APISprite
{
    private static Dictionary<string, int> cacheURLSprite = new Dictionary<string, int>();
    public static async void CreateSpriteFromURL(string url, DynValue callback, DynValue callbackError)
    {
        if (cacheURLSprite.ContainsKey(url))
        {
            Sprite spr = LuaCore.Instance.luaSprite[cacheURLSprite[url]];
            LuaSerializable luaSerializable = new LuaSerializable();
            luaSerializable.sprite = spr;
            luaSerializable.param = "param";
            luaSerializable.type = LuaType.Sprite;
            Table table = LuaScript.ConvertLuaParamToLua(new List<LuaSerializable> { luaSerializable });
            callback.Function.CallFunction(table.Get("param"));
            return;
        }
        await DownloadImageAsync(url, (spr) =>
        {
            if (callback.Type == DataType.Function)
            {
                cacheURLSprite[url] = spr.GetInstanceID();
                LuaSerializable luaSerializable = new LuaSerializable();
                luaSerializable.sprite = spr;
                luaSerializable.param = "param";
                luaSerializable.type = LuaType.Sprite;
                Table table = LuaScript.ConvertLuaParamToLua(new List<LuaSerializable> { luaSerializable});
                callback.Function.CallFunction(table.Get("param"));
            }
        }, () =>
        {
            if(callback.Type == DataType.Function)
            {
                callbackError.Function.CallFunction();
            }
        });
    }

    public static DynValue LoadImage(string fileDataBase64)
    {
        byte[] data = Convert.FromBase64String(fileDataBase64);
        Texture2D texture = LoadTexture(data);

        if (texture != null)
        {
            Sprite newSprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), new Vector2(0.5f, 0.5f));
            LuaSerializable luaSerializable = new LuaSerializable();
            luaSerializable.sprite = newSprite;
            luaSerializable.param = "param";
            luaSerializable.type = LuaType.Sprite;
            Table table = LuaScript.ConvertLuaParamToLua(new List<LuaSerializable> { luaSerializable });
            return table.Get("param");
        }
        else
        {
            Debug.LogError("Failed to load texture.");
            return DynValue.Nil;
        }
    }

    private static Texture2D LoadTexture(byte[] fileData)
    {
        Texture2D texture = new Texture2D(2, 2);

        if (texture.LoadImage(fileData))
        {
            return texture;
        }
        return null;
    }

    async static Task DownloadImageAsync(string url, Action<Sprite> callback, Action callBackError)
    {
        using (UnityWebRequest uwr = UnityWebRequestTexture.GetTexture(url))
        {
            // Gửi yêu cầu tải ảnh và đợi phản hồi
            var operation = uwr.SendWebRequest();

            while (!operation.isDone)
            {
                await Task.Yield();
            }

            if (uwr.result != UnityWebRequest.Result.Success)
            {
                Debug.LogError("Error: " + uwr.error);
                callBackError();
            }
            else
            {                
                Texture2D texture = DownloadHandlerTexture.GetContent(uwr);                
                Sprite sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), new Vector2(0.5f, 0.5f));
                callback(sprite);
            }
        }
    }
}
