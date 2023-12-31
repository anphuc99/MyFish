using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

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
}
