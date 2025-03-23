using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class TabInputFields : MonoBehaviour
{
    public TMP_InputField[] inputFields;

    void Start()
    {
        // Gán sự kiện cho từng InputField
        foreach (TMP_InputField inputField in inputFields)
        {
            inputField.onEndEdit.AddListener(delegate { OnEndEdit(inputField); });
        }
    }

    void OnEndEdit(TMP_InputField currentInputField)
    {
        // Kiểm tra xem Tab có được nhấn không
        if (Input.GetKey(KeyCode.Tab))
        {
            // Tìm vị trí của InputField hiện tại trong danh sách
            int currentIndex = System.Array.IndexOf(inputFields, currentInputField);

            // Chuyển sang InputField tiếp theo (vòng tròn nếu đang ở cuối danh sách)
            int nextIndex = (currentIndex + 1) % inputFields.Length;

            // Chọn InputField tiếp theo
            inputFields[nextIndex].Select();
        }
    }
}
