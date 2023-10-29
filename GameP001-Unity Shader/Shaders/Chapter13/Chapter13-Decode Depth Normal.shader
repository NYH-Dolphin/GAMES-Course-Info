Shader "Unity Shaders Book/Chapter 13/Decode Depth Normal"
{
    Properties {}
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _CameraDepthTexture;
            sampler2D _CameraDepthNormalsTexture;

            struct a2v
            {
                float4 vertex : POSITION;
                half2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv: TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                half2 uv = v.texcoord;
                o.uv = uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
                float linearDepth = Linear01Depth(depth);
                fixed3 normal = DecodeViewNormalStereo(tex2D(_CameraDepthNormalsTexture, i.uv));

                fixed4 depthTexture = fixed4(linearDepth, linearDepth, linearDepth,1.0);
                fixed4 normalTexture = fixed4(normal * 0.5 + 0.5, 1.0);
                return depthTexture;
            }
            ENDCG
        }
    }
    FallBack Off
}