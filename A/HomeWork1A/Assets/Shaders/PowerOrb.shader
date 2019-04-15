// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/PowerOrb"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Float) = 10
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Spike ("Growth", Float) = 1.0
        _Speed ("Speed", Float) = 1.0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform float4 _Color;
            uniform float _Shininess;
            uniform float4 _SpecColor;
            uniform float _Spike;
            uniform float _Speed;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;  
                float3 normal : NORMAL;
                float3 vertexInWorld : TEXCOORD1;
                
            };

            v2f vert (appdata v)
            {
                // Not sure if we can make it spiky like I want
                v2f o;

                float3 norm = normalize(v.normal);

                float3 s = normalize(v.vertex.xyz);

                //v.vertex.xyz += norm * (_Spike * (sin(_Time.y * _Speed) + 1)) *fmod(s.x, 2)*fmod(s.y, 2)*fmod(s.z, 2);
                v.vertex.xyz += norm * (_Spike * (sin(_Time.y * _Speed)+1));
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.normal = v.normal;

                o.vertexInWorld = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            float4 normalToColor (float3 n) {
                return float4( (normalize(n) + 1.0) / 2.0, 1.0) ;
            }
           

            fixed4 frag (v2f i) : SV_Target
            {
                return normalToColor(i.normal);
            }

            ENDCG
        }
    }

}
