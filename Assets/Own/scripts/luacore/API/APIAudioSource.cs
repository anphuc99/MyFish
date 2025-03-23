using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[MoonSharpUserData]
public class APIAudioSource
{
    public static void Play(int InstanceIDGameObject, int InstanceIDComponent)
    {
        AudioSource audio = (AudioSource)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        audio.Play();
    }

    public static void Stop(int InstanceIDGameObject, int InstanceIDComponent)
    {
        AudioSource audio = (AudioSource)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        audio.Stop();
    }

    public static void SetVolume(int InstanceIDGameObject, int InstanceIDComponent, float volume)
    {
        AudioSource audio = (AudioSource)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        audio.volume = volume;
    }

    public static float GetVolume(int InstanceIDGameObject, int InstanceIDComponent)
    {
        AudioSource audio = (AudioSource)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return audio.volume;
    }

    public static void SetAudioClip(int InstanceIDGameObject, int InstanceIDComponent, int InstanceAudioClip)
    {
        AudioSource audio = (AudioSource)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        audio.clip = LuaCore.Instance.luaAudioClip[InstanceAudioClip];
    }

    public static int GetAudioClip(int InstanceIDGameObject, int InstanceIDComponent)
    {
        AudioSource audio = (AudioSource)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        LuaCore.Instance.AddLuaAudioClip(audio.clip);
        return audio.clip.GetInstanceID();
    }
}
