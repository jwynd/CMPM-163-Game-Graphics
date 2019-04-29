// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/PhongTexture"
{
    Properties
    {
        _Speed ("Rotation Speed", Float) = 1.0
        _Color ("Color", Color) = (1,1,1,1)
        _SpecularColor ("SpecularColor", Color) = (1,1,1,1)
        _Shininess ("Shininess", Float) = 1.0
        _MainTex ("Main Tex", 2D) = "white" {}
        _SecondTex("Moon Tex", 2D) = "white" {}
        
    }
    SubShader
    {

        pass 
        {
            Tags { "LightMode" = "ForwardBase" } //Important! In Unity, point lights are calculated in the the ForwardAdd pass
            // Blend One One //Turn on additive blending if you have more than one point light 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            uniform float _Speed;
            uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform float4 _SpecularColor;
            uniform float _Shininess;
            uniform sampler2D _MainTex;
            uniform sampler2D _SecondTex;
            
            struct vertexShaderInput 
            {
                float4 position: POSITION;
                float3 normal: NORMAL; 
                float2 uv: TEXCOORD0;
            };
            
            struct vertexShaderOutput
            {
                float4 position: SV_POSITION;
                float3 normal: NORMAL;
                float3 vertInWorldCoords: TEXCOORD1;
                float2 uv: TEXCOORD0;
                float3 objectPosition : TEXCOORD2;
            };
            float3x3 getRotationMatrixX (float theta) {
                
                float s = -sin(theta);
                float c = cos(theta);
                return float3x3(1, 0, 0, 0, c, -s, 0, s, c);
            }
            
            float3x3 getRotationMatrixY (float theta) {
                
                float s = -sin(theta);
                float c = cos(theta);
                return float3x3(c, 0, s, 0, 1, 0, -s, 0, c) ;
            }
            
            float3x3 getRotationMatrixZ (float theta) {
                
                float s = -sin(theta);
                float c = cos(theta);
                return float3x3(c, -s, 0, s, c, 0, 0, 0, 1);
            }
            
            
            /*v2f vert (appdata v)
            {
                v2f o;
                
                const float PI = 3.14159;
                
                //float rad = sin(_Time.y * _Speed) * PI; //Rotate back and forth for one loop
                //float rad = sin(_Time.y * _Speed) * PI*8; //Rotate back and forth for two loops
               
                float rad = fmod(_Time.y * _Speed, PI*2.0); //Loop counterclockwise
                //float rad = fmod(_Time.y * -_Speed, PI*2.0); //Loop clockwise
                
                float3x3 rotationMatrix = getRotationMatrixX(rad);
                
                float3 rotatedVertex = mul(rotationMatrix, v.vertex.xyz);
                
                float4 xyz = float4( rotatedVertex, 1.0 );
               
                o.vertex = UnityObjectToClipPos(xyz);
                o.normal = v.normal;
               
                return o;
            }*/
            
            vertexShaderOutput vert(vertexShaderInput v)
            {
                vertexShaderOutput o;

                const float PI = 3.14159;
                
                //float rad = sin(_Time.y * _Speed) * PI; //Rotate back and forth for one loop
                //float rad = sin(_Time.y * _Speed) * PI*8; //Rotate back and forth for two loops
               
                float rad = fmod(_Time.y * _Speed, PI*2.0); //Loop counterclockwise
                //float rad = fmod(_Time.y * -_Speed, PI*2.0); //Loop clockwise
                
                float3x3 rotationMatrix = getRotationMatrixY(rad);
                
                float3 rotatedVertex = mul(rotationMatrix, v.position.xyz);
                
                float4 xyz = float4( rotatedVertex, 1.0 );

                o.objectPosition = v.position;
                o.vertInWorldCoords = mul(unity_ObjectToWorld, v.position);
                o.position = UnityObjectToClipPos(xyz);
                o.normal = UnityObjectToWorldNormal(v.normal);
                //o.normal = v.normal;
                o.uv = v.uv;
                return o;
            }
            
            float4 frag(vertexShaderOutput i):SV_Target
            {
                float3 Ka = float3(1, 1, 1);
                float3 globalAmbient = float3(0.1, 0.1, 0.1);
                float3 ambientComponent = Ka * globalAmbient;

                float3 P = i.vertInWorldCoords.xyz;
                float3 N = normalize(i.normal);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
                float3 Kd = _Color.rgb;
                float3 lightColor = _LightColor0.rgb;
                float3 diffuseComponent = Kd * lightColor * max(dot(N, L), 0);
                
                float3 Ks = _SpecularColor.rgb;
                float3 V = normalize(_WorldSpaceCameraPos - P);
                float3 H = normalize(L + V);
                float3 specularComponent = Ks * lightColor * pow(max(dot(N, H), 0), _Shininess);
                
                
                float3 finalColor = ambientComponent + diffuseComponent + specularComponent;
                finalColor *= 0.5;
                float4 texCol = i.objectPosition.x < 0 ? tex2D(_MainTex, i.uv) : tex2D(_SecondTex, i.uv);
                float4 rval = (0.9*float4(finalColor, 1.0)) + (0.1* texCol);
                return rval;
                /*return float4(finalColor, 1.0);
                return i.objectPosition.x < 0?
                tex2D(_MainTex, i.uv):tex2D(_SecondTex, i.uv);*/
            }
            
            ENDCG
        }
            Pass {
                Tags { "LightMode" = "ForwardAdd" } //Important! In Unity, point lights are calculated in the the ForwardAdd pass
                Blend One One //Turn on additive blending if you have more than one point light
            
                
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"
                
                uniform float _Speed;
                uniform float4 _LightColor0;
                uniform float4 _Color;
                uniform float4 _SpecularColor;
                uniform float _Shininess;
                uniform sampler2D _MainTex;
                uniform sampler2D _SecondTex;
            

                float3x3 getRotationMatrixX (float theta) {
                    
                    float s = -sin(theta);
                    float c = cos(theta);
                    return float3x3(1, 0, 0, 0, c, -s, 0, s, c);
                }
                
                float3x3 getRotationMatrixY (float theta) {
                    
                    float s = -sin(theta);
                    float c = cos(theta);
                    return float3x3(c, 0, s, 0, 1, 0, -s, 0, c) ;
                }
                
                float3x3 getRotationMatrixZ (float theta) {
                    
                    float s = -sin(theta);
                    float c = cos(theta);
                    return float3x3(c, -s, 0, s, c, 0, 0, 0, 1);
                }
                struct appdata 
                {
                    float4 position: POSITION;
                    float3 normal: NORMAL; 
                    float2 uv: TEXCOORD0;
                };
                
                struct v2f
                {
                    float4 position: SV_POSITION;
                    float3 normal: NORMAL;
                    float3 vertInWorldCoords: TEXCOORD1;
                    float2 uv: TEXCOORD0;
                    float3 objectPosition : TEXCOORD2;
                };

    
            v2f vert(appdata v)
            { 
                    v2f o;
                    const float PI = 3.14159;
                    
                    //float rad = sin(_Time.y * _Speed) * PI; //Rotate back and forth for one loop
                    //float rad = sin(_Time.y * _Speed) * PI*8; //Rotate back and forth for two loops
                
                    float rad = fmod(_Time.y * _Speed, PI*2.0); //Loop counterclockwise
                    //float rad = fmod(_Time.y * -_Speed, PI*2.0); //Loop clockwise
                    
                    float3x3 rotationMatrix = getRotationMatrixY(rad);
                    
                    float3 rotatedVertex = mul(rotationMatrix, v.position.xyz);
                    
                    float4 xyz = float4( rotatedVertex, 1.0 );
                    o.objectPosition = v.position;
                    o.vertInWorldCoords = mul(unity_ObjectToWorld, v.position);
                    o.position = UnityObjectToClipPos(xyz); 
                    o.normal = UnityObjectToWorldNormal(v.normal);
                    //o.normal = v.normal;
                    o.uv = v.uv;
                    return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                    
                    float3 Ka = float3(1, 1, 1);
                    float3 globalAmbient = float3(0.1, 0.1, 0.1);
                    float3 ambientComponent = Ka * globalAmbient;

                    float3 P = i.vertInWorldCoords.xyz;
                    float3 N = normalize(i.normal);
                    float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
                    float3 Kd = _Color.rgb;
                    float3 lightColor = _LightColor0.rgb;
                    float3 diffuseComponent = Kd * lightColor * max(dot(N, L), 0);
                    
                    float3 Ks = _SpecularColor.rgb;
                    float3 V = normalize(_WorldSpaceCameraPos - P);
                    float3 H = normalize(L + V);
                    float3 specularComponent = Ks * lightColor * pow(max(dot(N, H), 0), _Shininess);
                    
                    
                    float3 finalColor = ambientComponent + diffuseComponent + specularComponent;
                    finalColor *= 0.5;
                    float4 texCol = i.objectPosition.x < 0 ? tex2D(_MainTex, i.uv) : tex2D(_SecondTex, i.uv);
                    float4 rval = (0.9*float4(finalColor, 1.0)) + (0.1* texCol);
                    return rval;

                }
                
                ENDCG
    
                
            }
        
    }
    FallBack "Diffuse"
}
