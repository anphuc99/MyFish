using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[MoonSharpUserData]
public class APILeanTween
{
    public static int move(int InsGameObject, Table v3To, float time)
    {
        Vector3 vector3 = LuaCore.Instance.ConvertTableToVector3(v3To);
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.move(gameObject, vector3, time);
        return tween.uniqueId;
    }


    public static int scale(int InsGameObject, Table v3To, float time)
    {
        Vector3 vector3 = LuaCore.Instance.ConvertTableToVector3(v3To);
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.scale(gameObject, vector3, time);
        return tween.uniqueId;
    }

    public static int moveLocal(int InsGameObject, Table v3To, float time)
    {
        Vector3 vector3 = LuaCore.Instance.ConvertTableToVector3(v3To);
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveLocal(gameObject, vector3, time);
        return tween.uniqueId;
    }

    public static int rotate(int InsGameObject, Table v3To, float time)
    {
        Vector3 vector3 = LuaCore.Instance.ConvertTableToVector3(v3To);
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.rotate(gameObject, vector3, time);
        return tween.uniqueId;
    }

    public static int moveX(int InsGameObject, float v3X, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveX(gameObject, v3X, time);
        return tween.uniqueId;
    }

    public static int moveY(int InsGameObject, float v3Y, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveY(gameObject, v3Y, time);
        return tween.uniqueId;
    }

    public static int moveZ(int InsGameObject, float v3Z, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveZ(gameObject, v3Z, time);
        return tween.uniqueId;
    }

    public static int moveLocalX(int InsGameObject, float v3X, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveLocalX(gameObject, v3X, time);
        return tween.uniqueId;
    }

    public static int moveLocalY(int InsGameObject, float v3Y, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveLocalY(gameObject, v3Y, time);
        return tween.uniqueId;
    }

    public static int moveLocalZ(int InsGameObject, float v3Z, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveLocalZ(gameObject, v3Z, time);
        return tween.uniqueId;
    }

    public static int scaleX(int InsGameObject, float v3X, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.scaleX(gameObject, v3X, time);
        return tween.uniqueId;
    }

    public static int scaleY(int InsGameObject, float v3Y, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.scaleY(gameObject, v3Y, time);
        return tween.uniqueId;
    }

    public static int scaleZ(int InsGameObject, float v3Z, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.scaleZ(gameObject, v3Z, time);
        return tween.uniqueId;
    }

    public static int rotateX(int InsGameObject, float v3X, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.rotateX(gameObject, v3X, time);
        return tween.uniqueId;
    }

    public static int rotateY(int InsGameObject, float v3Y, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.rotateY(gameObject, v3Y, time);
        return tween.uniqueId;
    }

    public static int rotateZ(int InsGameObject, float v3Z, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.rotateZ(gameObject, v3Z, time);
        return tween.uniqueId;
    }

    public static int color(int InsGameObject, Table toColor, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        Color color = LuaCore.Instance.ConverTableToColor(toColor);
        var tween = LeanTween.color(gameObject, color, time);
        return tween.uniqueId;
    }

    public static void cancel(int InsGameObject)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        LeanTween.cancel(gameObject);
    }

    public static int value(float from, float to, float time, DynValue func)
    {
        if (func != null && func.Type == DataType.Function)
        {
            var tween = LeanTween.value(from, to, time).setOnUpdate((float value) =>
            {
                func.Function.CallFunction(value);
            });
            return tween.uniqueId;
        }
        return -1;
    }

    public static int moveAnchore(int InsGameObject, Table to, float time)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        RectTransform rectTransform = gameObject.transform as RectTransform;
        Vector2 v3To = LuaCore.Instance.ConvertTableToVector2(to);
        var tween = LeanTween.value(gameObject, rectTransform.anchoredPosition, v3To, time).setOnUpdate((Vector2 v2) =>
        {
            rectTransform.anchoredPosition = v2;
        });
        return tween.uniqueId;
    }

    public static int delayCall(int InsGameObject, float delayTime, DynValue callBack)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InsGameObject].gameObject;
        var tween = LeanTween.delayedCall(gameObject, delayTime, () =>
        {
            if (callBack != null && callBack.Type == DataType.Function)
            {
                callBack.Function.CallFunction();
            }
        });
        return tween.uniqueId;
    }
}

[MoonSharpUserData]
public class APILTDescr
{
    public static void setOnComplete(int tweenID, Closure value)
    {
        var tween = LeanTween.get(tweenID);
        tween.setOnComplete(() =>
        {
            value.CallFunction();
        });
    }

    public static void setEase(int tweenID, int type)
    {
        var tween = LeanTween.get(tweenID);
        tween.setEase((LeanTweenType)type);
    }

    public static void cancel(int tweenID)
    {
        var tween = LeanTween.get(tweenID);
        if (tween != null)
        {
            tween.cancel();
        }
    }

    public static void pause(int tweenID)
    {
        var tween = LeanTween.get(tweenID); 
        tween.pause();
    }

    public static void resume(int tweenID)
    {
        var tween = LeanTween.get(tweenID);
        tween.resume();
    }
}