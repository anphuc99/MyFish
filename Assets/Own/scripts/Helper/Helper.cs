using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEngine;
using Kvp = System.Collections.Generic.KeyValuePair<string, object>;

public static class Helper
{
    public static bool Compare<T>(this T This,T other)
    {
        // Kiểm tra null và kiểu của other
        if (other == null || This.GetType() != other.GetType())
        {
            return false;
        }

        // Kiểm tra tất cả các trường public của đối tượng
        FieldInfo[] fields = This.GetType().GetFields();

        foreach (FieldInfo field in fields)
        {
            object valueThis = field.GetValue(This);
            object valueOther = field.GetValue(other);

            // Nếu giá trị của một trường không bằng giá trị tương ứng của trường khác
            if (!object.Equals(valueThis, valueOther))
            {
                return false;
            }
        }

        return true;
    }

    public static Kvp PairWith(this string key, object value) => new Kvp(key, value);
    public static T GetValue<T>(this IEnumerable<Kvp> kvp, string key)
    {
        foreach (Kvp kv in kvp)
        {
            if(kv.Key == key)
            {
                return (T)kv.Value;
            }
        }
        return default;
    }

    public static DynValue CallFunction(this Closure closure, params object[] args)
    {
        try
        {
            return closure.Call(args);
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
            throw ex;
        }
    }
}
