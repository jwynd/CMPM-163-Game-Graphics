Shader "Custom/OutputTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color0 ("Color0", Color) = (1, 1, 1, 1)
        _Color1 ("Color1", Color) = (1, 1, 1, 1)
        _Color2 ("Color2", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float4 _Color0;
            uniform float4 _Color1;
            uniform float4 _Color2;

            struct appdata{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f{
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v){
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag(v2f i) : SV_TARGET{
                //return float4(1.0,0.0,0.0,1.0);
                float4 tc = tex2D(_MainTex, i.uv);
                if(tc.r > 0.5) return _Color0;
                else if(tc.g > 0.5) return _Color1;
                else if(tc.b > 0.5) return _Color2;
                else return tc;
                //return (fixed4)(tex2D(_MainTex,i.uv));
            }


            ENDCG
        }
        
    }
    FallBack "Diffuse"
}
