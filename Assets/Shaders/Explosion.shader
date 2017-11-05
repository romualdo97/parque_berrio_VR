// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Experiments/Explosion" {
	Properties {
		[NoScaleOffset] _RampTex ("Color Ramp", 2D) = "white" {}
		[NoScaleOffset] _NoiseTex("Noise texturee", 2D) = "gray" {}

		_RampOffset("Ramp offset", Range(-0.5, 0.5)) = 0
		_Period ("Period", Range(0, 1)) = 0.5

		_Amount ("Amount", Range(0, 1)) = 0.1
		_ClipRange ("Clip range", Range(0, 1)) = 1

		_Radius ("Expansion speed", Float) = 1

		_Correction ("Color correction", Vector) = (1,1,1,1)
	}
	SubShader {
		
		Tags{ "RenderType" = "Opaque" }
		LOD 200
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _RampTex;
			half _RampOffset;
			sampler2D _NoiseTex;
			float _Period;
			float _Radius;

			half _Amount;
			half _ClipRange;

			float4 _Correction;

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 normal : NORMAL;
			};

			v2f vert(appdata v)
			{
				v2f o;
				float3 displacement = tex2Dlod(_NoiseTex, float4(v.uv.xy, 0, 0));
				float time = sin(_Time[3] * _Period + displacement.r * 10);
				o.uv = v.uv.xy;
				o.vertex = v.vertex;
				o.vertex += v.normal * displacement.r * _Amount * time + v.normal * _RampOffset * _Radius;
				o.vertex = UnityObjectToClipPos(o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 noise = tex2D(_NoiseTex, i.uv);
				float n = saturate(noise.r + _RampOffset);
				clip(_ClipRange - n);
				half4 c = tex2D(_RampTex, float2(n, 0.5));
				return c * _Correction;
			}

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
