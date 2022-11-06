Shader "Custom/CompactPBR"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MRATex("MRA Map", 2D) = "black" {}
        _RoughnessPower("Roughness Power", Range(0.0, 1.0)) = 1.0
        _AOPower("AO Power", Range(0.0, 5.0)) = 1.0
        _NormalTex("Normal", 2D) = "black" {}
        _EmissiveTex("Emission", 2D) = "black" {}
        _EmissiveStrength("Emission Strength", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MRATex;
        sampler2D _NormalTex;
        sampler2D _EmissiveTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        float _RoughnessPower;
        float _AOPower;
        float _EmissiveStrength;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            float2 uv = IN.uv_MainTex;
            fixed4 c = tex2D (_MainTex, uv) * _Color;
            float3 mra = tex2D(_MRATex, uv).xyz;
            half4 normal = tex2D(_NormalTex, uv);
            float4 emission = tex2D(_EmissiveTex, uv);
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = mra.x;
            o.Smoothness = 1.0 - pow(mra.y, _RoughnessPower);
            o.Normal = UnpackNormal(normal);
            o.Occlusion = pow(mra.z, _AOPower);
            o.Emission = emission.xyz * _EmissiveStrength;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
