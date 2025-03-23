#if UNITY_EDITOR
using UnityEngine;
using System.Net;
using System.Net.Sockets;
using System.Text;

public class CustomLogger
{
    private static UdpClient udpClient;
    private static string serverIP = "127.0.0.1";
    private static int serverPort = 12345;

    // Khởi tạo UDP client nếu chưa có và tái sử dụng nó cho mỗi ghi chú
    private static UdpClient UdpClientInstance
    {
        get
        {
            if (udpClient == null)
            {
                udpClient = new UdpClient();
            }
            return udpClient;
        }
    }

    public static void Log(string message, int type)
    {
        if (type == 1)
        {
            Debug.Log(message);
        }
        else if (type == 2)
        {
            Debug.LogError(message);
        }

        // Gửi log thông qua kết nối UDP đã được khởi tạo hoặc tái sử dụng
        SendDataToServer(message);
    }

    private static void SendDataToServer(string message)
    {
        byte[] data = Encoding.ASCII.GetBytes(message);

        try
        {
            UdpClientInstance.Send(data, data.Length, serverIP, serverPort);
        }
        catch (SocketException e)
        {
            Debug.LogError("Error sending log: " + e.Message);
        }
    }
}
#endif