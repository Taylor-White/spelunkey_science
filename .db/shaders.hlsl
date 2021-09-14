
#pragma warning(disable : 3571 3578)

#define ASPECT_RATIO (16.f / 9.f)
#define SILHOUETTE_THRESHOLD .9f
#define GAMMA_CORRECTION 2.233333333f

cbuffer FrameCBufferType : register(b0) {
	matrix projectionMatrix;
	matrix viewProjectionMatrix;
	matrix invViewProjectionMatrix;
	float4 previousCameraPos;
	float2 invScreenSize;
	float brightness;
	int frameCounter;
	float LUTInterpolation;
	float LUTPower;
};

struct VertexInputType {
	float4 position : POSITION;
	float2 tex : TEXCOORD0;
	float4 color : COLOR0;
};

struct PixelInputType {
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
	float4 color : COLOR0;
};

struct VertexLightInputType {
	float4 position : POSITION;
	float2 tex : TEXCOORD0;
	float4 color : COLOR0;
};

struct PixelLightingInput {
	float4 position : SV_POSITION;
	float2 screenSpacePos : POSITION1;
	float2 tex : TEXCOORD0;
	float4 color : COLOR0;
};

float4 GetWorldPosition(float2 screenTexCoord) {
	float2 screenCoord = screenTexCoord * 2.f - 1.f;
	float4 nearVertex = mul(float4(screenCoord.x, -screenCoord.y, 0.f, 1.f), invViewProjectionMatrix);
	float4 farVertex = mul(float4(screenCoord.x, -screenCoord.y, 1.f, 1.f), invViewProjectionMatrix);

	nearVertex /= nearVertex.w;
	farVertex /= farVertex.w;

	float4 viewDirection = farVertex - nearVertex;

	float viewAlpha = -nearVertex.z / viewDirection.z;
	float4 worldPosition = nearVertex + viewDirection * viewAlpha;

	return worldPosition;
}

float GetLuma(float3 color) {
	return color.r * .2126f + color.g * .7152f + color.b * .0722f;
}

// Blur function
#define BLUR_SAMPLES 4

static const float blurWeights[BLUR_SAMPLES] = { .1945945946f, .1216216216f, .0540540541f, .0162162162f };

float4 BlurValue(Texture2D source, SamplerState samplerState, float2 texCoord, float2 texelSizes) {
	float4 sampled = source.Sample(samplerState, texCoord) * .2270270270f;

	float4 neighboringSamples = 0.f;
	for (int sampleN = 0; sampleN < BLUR_SAMPLES; ++sampleN) {
		neighboringSamples += source.Sample(samplerState, texCoord - float2(texelSizes.x * (sampleN + 1), texelSizes.y * (sampleN + 1))) * blurWeights[sampleN];
		neighboringSamples += source.Sample(samplerState, texCoord + float2(texelSizes.x * (sampleN + 1), texelSizes.y * (sampleN + 1))) * blurWeights[sampleN];
	}

	return sampled + neighboringSamples;
}

PixelInputType mainv_WorldColor_VS(VertexInputType input) {
	PixelInputType output;

	output.position = mul(float4(input.position.x, input.position.y, 0.f, 1.f), viewProjectionMatrix);
	output.color = input.color;

	return output;
}

PixelInputType mainv_WorldTexture_VS(VertexInputType input) {
	PixelInputType output;

	output.position = mul(float4(input.position.x, input.position.y, 0.f, 1.f), viewProjectionMatrix);
	output.tex = input.tex;

	return output;
}

PixelInputType mainv_WorldTextureColors_VS(VertexInputType input) {
	PixelInputType output;

	output.position = mul(float4(input.position.x, input.position.y, 0.f, 1.f), viewProjectionMatrix);
	output.tex = input.tex;
	output.color = input.color;

	return output;
}

PixelInputType mainv_ScreenColors_VS(VertexInputType input) {
	PixelInputType output;

	output.position = input.position;
	output.color = input.color;

	return output;
}

PixelInputType mainv_ScreenTexture_VS(VertexInputType input) {
	PixelInputType output;

	output.position = input.position;
	output.tex = input.tex;

	return output;
}

PixelInputType mainv_ScreenTextureColor_VS(VertexInputType input) {
	PixelInputType output;

	output.position = input.position;
	output.tex = input.tex;
	output.color = input.color;

	return output;
}

PixelInputType mainv_ScreenPixelColors_VS(VertexInputType input) {
	PixelInputType output;

	output.position = float4(input.position.x * invScreenSize.x * 2.0f - 1.0f, input.position.y * invScreenSize.y * 2.0f - 1.0f, input.position.z, input.position.w);
	output.color = input.color;

	return output;
}

PixelInputType mainv_ScreenPixelColorsTexture_VS(VertexInputType input) {
	PixelInputType output;

	output.position = float4(input.position.x * invScreenSize.x * 2.0f - 1.0f, input.position.y * invScreenSize.y * 2.0f - 1.0f, input.position.z, input.position.w);
	output.tex = input.tex;
	output.color = input.color;

	return output;
}

Texture2D texture0 : register(t0);
Texture2D texture1 : register(t1);
Texture2D texture2 : register(t2);
Texture2D texture3 : register(t3);
Texture2D texture4 : register(t4);
Texture2D texture5 : register(t5);
Texture2D texture6 : register(t6);
Texture2D texture7 : register(t7);
Texture2D texture8 : register(t8);

SamplerState smoothWrappingSamplerState : register(s0);
SamplerState smoothMirrorSamplerState : register(s1);
SamplerState smoothClampingSamplerState : register(s2);
SamplerState sharpClampingSamplerState : register(s3);
SamplerState sharpWrappingSamplerState : register(s4);
SamplerState smoothBorderSamplerState : register(s5);

float4 mainp_Colors_PS(PixelInputType input) : SV_TARGET0 {
	return float4(input.color.rgb * input.color.a, input.color.a);
}

float4 mainp_Texture_PS(PixelInputType input) : SV_TARGET0 {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);

	return float4(textureSample.rgb, textureSample.a);
}

float4 mainp_TextureColors_PS(PixelInputType input) : SV_TARGET0 {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);

	return float4(input.color.rgb * input.color.a * textureSample.rgb, input.color.a * textureSample.a);
}

float4 mainp_TextureAlphaColors_PS(PixelInputType input) : SV_TARGET0 {
	float textureAlpha = texture0.Sample(smoothWrappingSamplerState, input.tex).r;

	return float4(input.color.rgb * input.color.a * textureAlpha, input.color.a * textureAlpha);
}

float4 mainp_TextureBrightness_PS(PixelInputType input) : SV_TARGET0 {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	textureSample.rgb *= brightness;

	return float4(textureSample.rgb, textureSample.a);
}

float4 mainp_CircleOccluder_PS(PixelInputType input) : SV_TARGET0 {
	float threshold = 1.f - input.color.a;
	float alpha = smoothstep(threshold, threshold + .025f, length(input.tex) / sqrt(2.f));
	return float4(0.f, 0.f, 0.f, alpha);
}

float4 mainp_TextureColorsWarp_PS(PixelInputType input) : SV_TARGET0 {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);

	return float4(pow(textureSample.rgb, 1.f / GAMMA_CORRECTION), textureSample.a) * input.color.a;
}

float4 mainp_Unfocuser_PS(PixelInputType input) : SV_TARGET0 {
	float4 textureSample = BlurValue(texture0, smoothClampingSamplerState, input.tex, float2(input.color.r, input.color.g * ASPECT_RATIO) * .0015f);

	return float4(input.color.a * textureSample.rgb, input.color.a);
}

// Effect processing (deferred rendering)
struct PixelProcessInput {
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
	float4 color : COLOR0;
	float depth : DEPTH0;
};

struct PixelProcessFlatColorInput {
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
	nointerpolation float4 color : COLOR0;
	float depth : DEPTH0;
};

struct PixelProcessOutput {
	float4 diffuse : SV_TARGET0;
	float4 emissive : SV_TARGET1;
	float4 transparency : SV_TARGET2;
	float4 depth : SV_TARGET3;
};

struct LowPPixelProcessOutput {
	float4 diffuse : SV_TARGET0;
	float4 emissive : SV_TARGET1;
};

PixelProcessInput mainv_Process_DeferredTextureColor_VS(VertexInputType input) {
	PixelProcessInput output;

	output.position = mul(float4(input.position.x, input.position.y, 0.f, 1.f), viewProjectionMatrix);
	output.tex = input.tex;
	output.color = pow(float4(input.color.rgb * input.color.a, input.color.a), GAMMA_CORRECTION); // This is actually wrong, alpha should not be corrected
	output.depth = input.position.z;

	return output;
}

PixelProcessFlatColorInput mainv_Process_DeferredTextureFlatColor_VS(VertexInputType input) {
	PixelProcessFlatColorInput output;

	output.position = mul(float4(input.position.x, input.position.y, 0.f, 1.f), viewProjectionMatrix);
	output.tex = input.tex;
	output.color = pow(float4(input.color.rgb * input.color.a, input.color.a), GAMMA_CORRECTION); // This is actually wrong, alpha should not be corrected
	output.depth = input.position.z;

	return output;
}

PixelProcessOutput mainp_Process_DeferredColorTransparent_PS(PixelProcessInput input) {
	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, input.color.a);
	pixelProcessOutput.transparency = input.color;

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredColorTransparent_PS(PixelProcessInput input) {
	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = input.color;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, input.color.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_PS(PixelProcessInput input) {
	PixelProcessOutput pixelProcessOutput;

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float silhouette = input.color.a * textureSample.a > SILHOUETTE_THRESHOLD;

	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * input.color.a * textureSample.a);
	pixelProcessOutput.transparency = float4(silhouette, silhouette, silhouette, silhouette);
	pixelProcessOutput.depth = float4(input.depth, 0.f, 0.f, silhouette);

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_PS(PixelProcessInput input) {
	LowPPixelProcessOutput pixelProcessOutput;

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float silhouette = input.color.a * textureSample.a > SILHOUETTE_THRESHOLD;

	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * input.color.a * textureSample.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_Poisoned_PS(PixelProcessInput input) {
	PixelProcessOutput pixelProcessOutput;

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float silhouette = input.color.a * textureSample.a > SILHOUETTE_THRESHOLD;

	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * input.color.a * textureSample.a);
	pixelProcessOutput.transparency = float4(silhouette, silhouette, silhouette, silhouette);
	pixelProcessOutput.depth = float4(input.depth, 0.f, 0.f, silhouette);

	// Apply poison effect
	float luma = GetLuma(pixelProcessOutput.diffuse.rgb);
	pixelProcessOutput.diffuse.rgb = lerp(pixelProcessOutput.diffuse.rgb, float3(.2f, 1.f, .2f), .5f * min(luma, .7f) * silhouette);

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_Poisoned_PS(PixelProcessInput input) {
	LowPPixelProcessOutput pixelProcessOutput;

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float silhouette = input.color.a * textureSample.a > SILHOUETTE_THRESHOLD;

	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * input.color.a * textureSample.a);

	// Apply poison effect
	float luma = GetLuma(pixelProcessOutput.diffuse.rgb);
	pixelProcessOutput.diffuse.rgb = lerp(pixelProcessOutput.diffuse.rgb, float3(.2f, 1.f, .2f), .5f * min(luma, .7f) * silhouette);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_Cursed_PS(PixelProcessInput input) {
	PixelProcessOutput pixelProcessOutput = mainp_Process_DeferredTextureColor_PS(input);

	float luma = GetLuma(pixelProcessOutput.diffuse.rgb) * .4f;
	pixelProcessOutput.diffuse = float4(luma, luma, luma, pixelProcessOutput.diffuse.a);

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_Cursed_PS(PixelProcessInput input) {
	LowPPixelProcessOutput pixelProcessOutput = mainp_lowP_Process_DeferredTextureColor_PS(input);

	float luma = GetLuma(pixelProcessOutput.diffuse.rgb) * .4f;
	pixelProcessOutput.diffuse = float4(luma, luma, luma, pixelProcessOutput.diffuse.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_PoisonedCursed_PS(PixelProcessInput input) {
	PixelProcessOutput pixelProcessOutput;

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float silhouette = input.color.a * textureSample.a > SILHOUETTE_THRESHOLD;

	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * input.color.a * textureSample.a);
	pixelProcessOutput.transparency = float4(silhouette, silhouette, silhouette, silhouette);
	pixelProcessOutput.depth = float4(input.depth, 0.f, 0.f, silhouette);

	// Apply poison+curse effect
	float luma = GetLuma(pixelProcessOutput.diffuse.rgb) * .4f;
	pixelProcessOutput.diffuse.rgb = lerp(float3(luma, luma, luma), float3(.2f, 1.f, .2f), min(luma, .7f) * silhouette);

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_PoisonedCursed_PS(PixelProcessInput input) {
	LowPPixelProcessOutput pixelProcessOutput;

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float silhouette = input.color.a * textureSample.a > SILHOUETTE_THRESHOLD;

	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * input.color.a * textureSample.a);

	// Apply poison+curse effect
	float luma = GetLuma(pixelProcessOutput.diffuse.rgb) * .4f;
	pixelProcessOutput.diffuse.rgb = lerp(float3(luma, luma, luma), float3(.2f, 1.f, .2f), min(luma, .7f) * silhouette);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_Transparent_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, outputColor.a);
	pixelProcessOutput.transparency = outputColor;

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_Transparent_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = outputColor;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, outputColor.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_TransparentCorrected_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * pow(textureSample.a, 1.f / GAMMA_CORRECTION));

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, outputColor.a);
	pixelProcessOutput.transparency = outputColor;

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_TransparentCorrected_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * pow(textureSample.a, 1.f / GAMMA_CORRECTION));

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = outputColor;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, outputColor.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_Emissive_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}
		
	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, outputColor.a);
	pixelProcessOutput.transparency = outputColor;

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_Emissive_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = outputColor;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, outputColor.a);

	return pixelProcessOutput;
}

#define EMISSIVE_STR_MULTIPLIER 3.f

PixelProcessOutput DoGlow(PixelProcessInput input, float emissiveMultiplier) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	
	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(outputColor.rgb * emissiveMultiplier, outputColor.a);
	pixelProcessOutput.transparency = outputColor;

	return pixelProcessOutput;
}

LowPPixelProcessOutput lowP_DoGlow(PixelProcessInput input, float emissiveMultiplier) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);

	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = outputColor;
	pixelProcessOutput.emissive = float4(outputColor.rgb * emissiveMultiplier, outputColor.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_EmissiveGlow_PS(PixelProcessInput input) {
	return DoGlow(input, 1.f / EMISSIVE_STR_MULTIPLIER);
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_EmissiveGlow_PS(PixelProcessInput input) {
	return lowP_DoGlow(input, 1.f / EMISSIVE_STR_MULTIPLIER);
}

PixelProcessOutput mainp_Process_DeferredTextureColor_EmissiveGlowHeavy_PS(PixelProcessInput input) {
	return DoGlow(input, .65f);
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_EmissiveGlowHeavy_PS(PixelProcessInput input) {
	return lowP_DoGlow(input, .65f);
}

PixelProcessOutput mainp_Process_DeferredTextureColor_EmissiveGlowBrightness_PS(PixelProcessInput input) {
	PixelProcessOutput pixelProcessOutput = DoGlow(input, 1.f);
	pixelProcessOutput.emissive *= max(pixelProcessOutput.emissive.r, max(pixelProcessOutput.emissive.g, pixelProcessOutput.emissive.b));

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_EmissiveGlowBrightness_PS(PixelProcessInput input) {
	LowPPixelProcessOutput pixelProcessOutput = lowP_DoGlow(input, 1.f);
	pixelProcessOutput.emissive *= max(pixelProcessOutput.emissive.r, max(pixelProcessOutput.emissive.g, pixelProcessOutput.emissive.b));

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_EmissiveColorizedGlow_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = float4(textureSample.rgb * input.color.a, input.color.a * textureSample.a);

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(input.color.rgb * textureSample.a, input.color.a * textureSample.a);
	pixelProcessOutput.transparency = outputColor;

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_EmissiveColorizedGlow_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = float4(textureSample.rgb * input.color.a, input.color.a * textureSample.a);

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = outputColor;
	pixelProcessOutput.emissive = float4(input.color.rgb * textureSample.a, input.color.a * textureSample.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_EmissiveColorizedGlow_DynamicGlow_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = textureSample;

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(input.color.rgb * textureSample.a, input.color.a * textureSample.a);
	pixelProcessOutput.transparency = outputColor;

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_EmissiveColorizedGlow_DynamicGlow_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = textureSample;

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = outputColor;
	pixelProcessOutput.emissive = float4(input.color.rgb * textureSample.a, input.color.a * textureSample.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_EmissiveColorizedGlow_Saturation_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = textureSample;

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(input.color.rgb * textureSample.a, input.color.a * textureSample.a);
	pixelProcessOutput.transparency = lerp(outputColor, float4(input.color.rgb, 1.f) * outputColor.a, input.color.a);

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_EmissiveColorizedGlow_Saturation_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	if (textureSample.a == 0.f) {
		discard;
	}

	float4 outputColor = textureSample;

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = lerp(outputColor, float4(input.color.rgb, 1.f) * outputColor.a, input.color.a);
	pixelProcessOutput.emissive = float4(input.color.rgb * textureSample.a, input.color.a * textureSample.a);

	return pixelProcessOutput;
}

#define REFLECTION_MAP_MIN .5f
#define REFLECTION_MAP_MAX 1.1f
#define REFLECTION_DISPLACEMENT .013f

struct PixelProcessReflectInput {
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
	float4 color : COLOR0;
	float depth : DEPTH0;
	float2 centerWorldPosition : WORLD0;
};

PixelProcessReflectInput mainv_Process_DeferredTextureColor_Reflect_VS(VertexInputType input) {
	PixelProcessReflectInput output;

	output.position = mul(float4(input.position.x, input.position.y, 0.f, 1.f), viewProjectionMatrix);
	output.tex = input.tex;
	output.color = pow(float4(input.color.rgb * input.color.a, input.color.a), GAMMA_CORRECTION); // This is actually wrong, alpha should not be corrected
	output.depth = input.position.z;
	output.centerWorldPosition = GetWorldPosition(float2(.5f, .5f)).xy;

	return output;
}

PixelProcessOutput mainp_Process_DeferredTextureColor_Reflect_PS(PixelProcessReflectInput input) {
	float4 normalSample = normalize(texture1.Sample(smoothWrappingSamplerState, input.tex) * 2.f - 1.f);
		
	float reflection = texture2.Sample(smoothWrappingSamplerState, input.position.xy * invScreenSize * .375f + normalSample.xy * .12f + input.centerWorldPosition.xy * float2(REFLECTION_DISPLACEMENT * ASPECT_RATIO, -REFLECTION_DISPLACEMENT)).r;
	reflection = pow(reflection * (REFLECTION_MAP_MIN - REFLECTION_MAP_MAX) + REFLECTION_MAP_MAX, 4.f);

	PixelProcessOutput pixelProcessOutput;

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.rgb * reflection, input.color.a * textureSample.a);

	float silhouette = input.color.a * textureSample.a > SILHOUETTE_THRESHOLD;

	pixelProcessOutput.depth = float4(input.depth, 0.f, 0.f, silhouette);
	pixelProcessOutput.transparency = float4(silhouette, silhouette, silhouette, silhouette);

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTextureColor_Reflect_PS(PixelProcessReflectInput input) {
	float4 normalSample = normalize(texture1.Sample(smoothWrappingSamplerState, input.tex) * 2.f - 1.f);

	float reflection = texture2.Sample(smoothWrappingSamplerState, input.position.xy * invScreenSize * .375f + normalSample.xy * .12f + input.centerWorldPosition.xy * float2(REFLECTION_DISPLACEMENT * ASPECT_RATIO, -REFLECTION_DISPLACEMENT)).r;
	reflection = pow(reflection * (REFLECTION_MAP_MIN - REFLECTION_MAP_MAX) + REFLECTION_MAP_MAX, 4.f);

	LowPPixelProcessOutput pixelProcessOutput;

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.rgb * reflection, input.color.a * textureSample.a);

	return pixelProcessOutput;
}

PixelProcessReflectInput mainv_Process_DeferredTexture_Ice_VS(VertexLightInputType input) {
	PixelProcessReflectInput output;

	output.position = mul(float4(input.position.x, input.position.y, 0.f, 1.f), viewProjectionMatrix);
	output.tex = input.tex;
	output.color = input.color;
	output.depth = input.position.z;
	output.centerWorldPosition = GetWorldPosition(float2(.5f, .5f)).xy;

	return output;
}

PixelProcessOutput ProcessIce(PixelProcessReflectInput input, bool transparent) {
	float4 normalSample = normalize(texture0.Sample(sharpWrappingSamplerState, input.tex + input.color.rg) * 2.f - 1.f);

	float reflection = texture1.Sample(smoothWrappingSamplerState, input.position.xy * invScreenSize * 2.f + (normalSample.xy * 1.4f + input.centerWorldPosition.xy * .02f) * float2(ASPECT_RATIO, -1.f)).r;
	reflection = pow(reflection, 2.f);

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	float luma = GetLuma(textureSample.rgb);

	float silhouette = textureSample.a > SILHOUETTE_THRESHOLD;

	float4 color = float4(lerp(textureSample.rgb, lerp(float3(0.f, .15f, .3f), float3(1.f, 1.f, 1.f), step(.3f, luma)) * textureSample.a, reflection), textureSample.a);
	PixelProcessOutput pixelProcessOutput;
	if (!transparent) {
		pixelProcessOutput.diffuse = color;
		pixelProcessOutput.depth = float4(input.depth, 0.f, 0.f, silhouette);
		pixelProcessOutput.transparency = float4(silhouette, silhouette, silhouette, silhouette);
	} else {
		pixelProcessOutput.transparency = color;
	}
	pixelProcessOutput.emissive = float4(float3(reflection, reflection, reflection) * input.color.b * textureSample.a, textureSample.a);

	return pixelProcessOutput;
}

LowPPixelProcessOutput lowP_ProcessIce(PixelProcessReflectInput input) {
	float4 normalSample = normalize(texture0.Sample(sharpWrappingSamplerState, input.tex + input.color.rg) * 2.f - 1.f);

	float reflection = texture1.Sample(smoothWrappingSamplerState, input.position.xy * invScreenSize * 2.f + (normalSample.xy * 1.4f + input.centerWorldPosition.xy * .02f) * float2(ASPECT_RATIO, -1.f)).r;
	reflection = pow(reflection, 2.f);

	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	float luma = GetLuma(textureSample.rgb);

	float4 color = float4(lerp(textureSample.rgb, lerp(float3(0.f, .15f, .3f), float3(1.f, 1.f, 1.f), step(.3f, luma)) * textureSample.a, reflection), textureSample.a);
	
	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = color;
	pixelProcessOutput.emissive = float4(float3(reflection, reflection, reflection) * input.color.b * textureSample.a, textureSample.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredTexture_Ice_PS(PixelProcessReflectInput input) {
	return ProcessIce(input, false);
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTexture_Ice_PS(PixelProcessReflectInput input) {
	return lowP_ProcessIce(input);
}

PixelProcessOutput mainp_Process_DeferredTexture_IceTransparent_PS(PixelProcessReflectInput input) {
	return ProcessIce(input, true);
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTexture_IceTransparent_PS(PixelProcessReflectInput input) {
	return lowP_ProcessIce(input);
}

static const float NOISE_WEIGHT = .8f;
static const float NOISE_MARGIN = .03f;
static const float NOISE_OUTLINE = .025f;
static const float NOISE_OUTLINE_THRESHOLD = .015f;

PixelProcessOutput mainp_Process_DeferredTexture_Stone_PS(PixelProcessFlatColorInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	float luma = GetLuma(textureSample.rgb);

	float2 worldPosition = GetWorldPosition(input.position.xy * invScreenSize).xy;
	float noise = lerp(texture1.Sample(smoothWrappingSamplerState, worldPosition / float2(5.5f, 5.5f)).r, texture2.Sample(smoothWrappingSamplerState, worldPosition / float2(3.f, 3.f)).r, NOISE_WEIGHT);
	noise = NOISE_MARGIN + noise * (1.f - NOISE_MARGIN);

	float stoneNoise = (texture2.Sample(smoothWrappingSamplerState, worldPosition / float2(1.3f, 1.3f)).r * .6f + .4f);
	float3 finalColor = float3(.31f, .43f, .36f) * luma * stoneNoise;
	if (input.color.r != 0.f) {
		finalColor = lerp(finalColor, textureSample.rgb, step(noise, input.color.r));
	}

	if (luma > NOISE_OUTLINE_THRESHOLD && input.color.r > 0.f && input.color.r < noise && input.color.r > noise - NOISE_OUTLINE) {
		finalColor = float3(.33f, .47f, .40f);
	}

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = float4(finalColor, textureSample.a);

	float silhouette = textureSample.a > SILHOUETTE_THRESHOLD;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * textureSample.a);
	pixelProcessOutput.transparency = float4(silhouette, silhouette, silhouette, silhouette);
	pixelProcessOutput.depth = float4(input.depth, 0.f, 0.f, silhouette);

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredTexture_Stone_PS(PixelProcessFlatColorInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);
	float luma = GetLuma(textureSample.rgb);

	float2 worldPosition = GetWorldPosition(input.position.xy * invScreenSize).xy;
	float noise = lerp(texture1.Sample(smoothWrappingSamplerState, worldPosition / float2(5.5f, 5.5f)).r, texture2.Sample(smoothWrappingSamplerState, worldPosition / float2(3.f, 3.f)).r, NOISE_WEIGHT);
	noise = NOISE_MARGIN + noise * (1.f - NOISE_MARGIN);

	float stoneNoise = (texture2.Sample(smoothWrappingSamplerState, worldPosition / float2(1.3f, 1.3f)).r * .6f + .4f);
	float3 finalColor = float3(.31f, .43f, .36f) * luma * stoneNoise;
	if (input.color.r != 0.f) {
		finalColor = lerp(finalColor, textureSample.rgb, step(noise, input.color.r));
	}

	if (luma > NOISE_OUTLINE_THRESHOLD && input.color.r > 0.f && input.color.r < noise && input.color.r > noise - NOISE_OUTLINE) {
		finalColor = float3(.33f, .47f, .40f);
	}

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = float4(finalColor, textureSample.a);

	float silhouette = textureSample.a > SILHOUETTE_THRESHOLD;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * textureSample.a);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_DeferredSilhouette_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);

	float silhouette = input.color.a * textureSample.a > SILHOUETTE_THRESHOLD;

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.a, input.color.a * textureSample.a);
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * input.color.a * textureSample.a);
	pixelProcessOutput.transparency = float4(silhouette, silhouette, silhouette, silhouette);
	pixelProcessOutput.depth = float4(input.depth, 0.f, 0.f, silhouette);

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_DeferredSilhouette_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, input.tex);

	float silhouette = input.color.a * textureSample.a > SILHOUETTE_THRESHOLD;

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = float4(input.color.rgb * textureSample.a, input.color.a * textureSample.a);
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, silhouette * input.color.a * textureSample.a);

	return pixelProcessOutput;
}

float4 mainp_Process_Deferred_Nebula_PS(PixelProcessInput input) : SV_TARGET2 {
	float timestepMultiplier = .0010f;
	float2 noise = float2(texture1.Sample(smoothMirrorSamplerState, float2(float2(input.tex.x, -input.tex.y) + frameCounter * timestepMultiplier) * float2(1 / 6.f, 1 / 4.f)).r * 2.f - 1.f,
						  texture2.Sample(smoothMirrorSamplerState, float2(float2(-input.tex.x, input.tex.y) + frameCounter * timestepMultiplier) * float2(1 / 2.5f, 1 / 5.f)).r * 2.f - 1.f);
	float4 textureSample = texture0.Sample(smoothClampingSamplerState, input.tex + noise * .015f);
		
	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);

	return outputColor;
}

float4 mainp_lowP_Process_Deferred_Nebula_PS(PixelProcessInput input) : SV_TARGET0 {
	float timestepMultiplier = .0010f;
	float2 noise = float2(texture1.Sample(smoothMirrorSamplerState, float2(float2(input.tex.x, -input.tex.y) + frameCounter * timestepMultiplier) * float2(1 / 6.f, 1 / 4.f)).r * 2.f - 1.f,
						  texture2.Sample(smoothMirrorSamplerState, float2(float2(-input.tex.x, input.tex.y) + frameCounter * timestepMultiplier) * float2(1 / 2.5f, 1 / 5.f)).r * 2.f - 1.f);
	float4 textureSample = texture0.Sample(smoothClampingSamplerState, input.tex + noise * .015f);

	float4 outputColor = float4(input.color.rgb * textureSample.rgb, input.color.a * textureSample.a);

	return outputColor;
}

PixelProcessOutput mainp_Process_Deferred_BlindEffect_PS(PixelProcessInput input) {
	float alpha = min(pow(length(input.tex), .2f), 1.f) * input.color.a;

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, alpha);
	pixelProcessOutput.transparency = float4(0.f, 0.f, 0.f, alpha);

	return pixelProcessOutput;
}

LowPPixelProcessOutput mainp_lowP_Process_Deferred_BlindEffect_PS(PixelProcessInput input) {
	float alpha = min(pow(length(input.tex), .2f), 1.f) * input.color.a;

	LowPPixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.diffuse = float4(0.f, 0.f, 0.f, alpha);
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, alpha);

	return pixelProcessOutput;
}

PixelProcessOutput mainp_Process_Deferred_EmissiveCleaner_PS(PixelProcessInput input) {
	float4 textureSample = texture0.Sample(smoothClampingSamplerState, input.tex);

	PixelProcessOutput pixelProcessOutput;
	pixelProcessOutput.emissive = float4(0.f, 0.f, 0.f, textureSample.a);

	return pixelProcessOutput;
}

// Liquids
float4 mainp_LiquidCombine_PS(PixelInputType input) : SV_TARGET0 {
	float4 diffuseSample = texture0.Sample(sharpWrappingSamplerState, input.tex);
	float4 transparencySample = texture1.Sample(sharpWrappingSamplerState, input.tex);

	return float4(lerp(diffuseSample.rgb, transparencySample.rgb, transparencySample.a), 1.f);
}

float4 mainp_lowP_LiquidCombine_PS(PixelInputType input) : SV_TARGET0 {
	return texture0.Sample(sharpWrappingSamplerState, input.tex);
}

// Fades previous liquid buffer
float2 mainp_LiquidFader_PS(PixelInputType input) : SV_TARGET0 {
	// Sample from previous camera location so we keep position consistent
	float4 previousCenter = mul(previousCameraPos, viewProjectionMatrix);
	previousCenter.xyz /= previousCenter.w;
	previousCenter = previousCenter *.5f;

	float2 previousLiquidSample = texture0.Sample(smoothBorderSamplerState, input.tex - float2(previousCenter.x, -previousCenter.y)).rg;

	return previousLiquidSample - .1f;
}

// Outputs new liquid values
float2 mainp_Process_DeferredTextureColor_Liquid_PS() : SV_TARGET0 {
	return float2(1.f, 1.f);
}

// Blurs the liquid buffer
#define LIQUIDBUFFER_HEIGHT 256.f
#define LIQUIDBUFFER_UTEXEL (1.f / (LIQUIDBUFFER_HEIGHT * ASPECT_RATIO))
#define LIQUIDBUFFER_VTEXEL (1.f / LIQUIDBUFFER_HEIGHT)
#define LIQUIDBUFFER_BLUR_RADIUS 1.f

float2 mainp_LiquidBlurH_PS(PixelInputType input) : SV_TARGET0 {
	return BlurValue(texture0, smoothClampingSamplerState, input.tex, float2(LIQUIDBUFFER_UTEXEL, 0.f) * LIQUIDBUFFER_BLUR_RADIUS).rg;
}

float2 mainp_LiquidBlurV_PS(PixelInputType input) : SV_TARGET0 {
	return BlurValue(texture0, smoothClampingSamplerState, input.tex, float2(0.f, LIQUIDBUFFER_VTEXEL) * LIQUIDBUFFER_BLUR_RADIUS).rg;
}

float2 GetRefractionVector(float2 screenTexCoord, float timestepMultiplier, float refractionNoise, float refractionThreshold) {
	float4 worldPosition = GetWorldPosition(screenTexCoord);

	float2 noise = float2(texture2.Sample(smoothMirrorSamplerState, float2(worldPosition.x / 6.f, -worldPosition.y / 4.f) + frameCounter * timestepMultiplier).r * 2.f - 1.f,
						  texture3.Sample(smoothMirrorSamplerState, float2(-worldPosition.x / 3.f, worldPosition.y / 5.f) + frameCounter * timestepMultiplier).r * 2.f - 1.f);
	
	// Get temporary refracted position
	float2 refractedPosition = screenTexCoord + noise * refractionNoise;

	// Prevent noise from making us sample from outside the frustum
	refractedPosition = saturate(refractedPosition);

	refractedPosition = abs(refractedPosition * 2.f - 1.f);

	noise.x *= refractedPosition.x >= refractionThreshold ? 1.f - (refractedPosition.x - refractionThreshold) / (1.f - refractionThreshold) : 1.f;
	noise.y *= refractedPosition.y >= refractionThreshold ? 1.f - (refractedPosition.y - refractionThreshold) / (1.f - refractionThreshold) : 1.f;

	return noise;
}

#define LIQUID_START_CUTOFF .12f
#define LIQUID_END_CUTOFF .22f
#define LIQUIDREFRACTION_TIMESTEP_MULTIPLIER .002f
#define LIQUIDREFRACTION_NOISE .004f
#define LIQUIDREFRACTION_THRESHOLD .75f

float4 LiquidHelper(float2 tex, float2 noise, float currentLiquidSample, Texture2D liquidTexture) {
	float alpha = saturate((1.f / (LIQUID_END_CUTOFF - LIQUID_START_CUTOFF)) * currentLiquidSample - (LIQUID_START_CUTOFF / (LIQUID_END_CUTOFF - LIQUID_START_CUTOFF)));
	if (alpha == 0.f) {
		// Air
		return float4(0.f, 0.f, 0.f, 0.f);
	}

	float4 liquidSample = liquidTexture.Sample(smoothClampingSamplerState, float2(1.f, 0.f));
	float3 diffuseSample = pow(texture1.Sample(smoothClampingSamplerState, tex + alpha * noise * LIQUIDREFRACTION_NOISE).rgb, 1.f / GAMMA_CORRECTION);// TODO(cesm) This is already linear...
	return float4(lerp(diffuseSample, liquidSample.rgb, liquidSample.a * alpha), 1.f);
}

float3 TemperatureHelper(float temperature) {
	// Only works for temperature <= 6500.0
	float3 m0 = float3(0.0f,-1902.1955373783176f,-8257.7997278925690f);
	float3 m1 = float3(0.0f, 1669.5803561666639f, 2575.2827530017594f);
	float3 m2 = float3(1.0f, 1.3302673723350029f, 1.8993753891711275f);
	return saturate(m0 / (temperature +  m1) + m2);
}

struct LightOutput {
	float4 liquid : SV_TARGET0;
	float4 emissive : SV_TARGET1;
};

LightOutput mainp_LiquidWater_PS(PixelInputType input) {
	LightOutput output;

	float currentLiquidSample = texture0.Sample(smoothBorderSamplerState, input.tex).r;

	// Get final refracted position
	float2 noise = GetRefractionVector(input.tex, LIQUIDREFRACTION_TIMESTEP_MULTIPLIER, LIQUIDREFRACTION_NOISE, LIQUIDREFRACTION_THRESHOLD);

	float4 liquidOutput = LiquidHelper(input.tex, noise, currentLiquidSample, texture4);
	output.liquid = pow(liquidOutput, GAMMA_CORRECTION);
	output.emissive = float4(0.f, 0.f, 0.f, 0.f);

	return output;
}

LightOutput mainp_LiquidLava_PS(PixelInputType input) {
	LightOutput output;

	float currentLiquidSample = texture0.Sample(smoothBorderSamplerState, input.tex).g;

	float4 liquidOutput = LiquidHelper(input.tex, float2(0.f, 0.f), currentLiquidSample, texture4);
	output.liquid = float4(pow(liquidOutput.rgb, GAMMA_CORRECTION), liquidOutput.a);
	
	float sampleHotness = pow(currentLiquidSample, 4.f);
	float3 emissiveTint = TemperatureHelper(3000.f * sampleHotness);
	output.emissive = float4(.4f * liquidOutput.a * emissiveTint, liquidOutput.a);
	
	return output;
}

// Ambient occlusion
#define FLOOR_DEPTH0 10
#define FLOOR_DEPTH1 11
#define BACKGROUND_DEPTH 33

float mainp_AmbientOcclusion_PS(PixelInputType input) : SV_TARGET0 {
	// Create ambient occlusion map
	float depthValue = round(texture0.Sample(sharpClampingSamplerState, input.tex).r);
	return (depthValue == FLOOR_DEPTH0 || depthValue == FLOOR_DEPTH1) ? 1.f : 0.f;
}

#define AMBIENTOCCLUSION_SHRINK_FACTOR 4
#define AMBIENTOCCLUSION_UTEXEL (invScreenSize.x * pow(2.f, AMBIENTOCCLUSION_SHRINK_FACTOR))
#define AMBIENTOCCLUSION_VTEXEL (invScreenSize.y * pow(2.f, AMBIENTOCCLUSION_SHRINK_FACTOR))

float mainp_AmbientOcclusionBlurH_PS(PixelInputType input) : SV_TARGET0 {
	return BlurValue(texture0, smoothBorderSamplerState, input.tex, float2(AMBIENTOCCLUSION_UTEXEL, 0.f)).r;
}

float mainp_AmbientOcclusionBlurV_PS(PixelInputType input) : SV_TARGET0 {
	return BlurValue(texture0, smoothBorderSamplerState, input.tex, float2(0.f, AMBIENTOCCLUSION_VTEXEL)).r;
}

static const float3 ambientOcclusionColor = float3(0.f, 0.f, 0.f);

float4 mainp_FillAmbientOcclusion_PS(PixelInputType input) : SV_TARGET0 {
	if (round(texture0.Sample(smoothClampingSamplerState, input.tex).r) != BACKGROUND_DEPTH) {
		return float4(0.f, 0.f, 0.f, 0.f);
	}

	float ambientValue = texture1.Sample(smoothClampingSamplerState, input.tex).r;

	return float4(ambientOcclusionColor * ambientValue, ambientValue);
}

// Shadow shaders
#define SHADOW_OPACITY .4f
#define NONSHADOWABLE_VALUE 40.f

float4 mainp_SoftShadower_PS(PixelInputType input) : SV_TARGET0 {
	float2 depthSamplingDirection = float2(-invScreenSize.x, -invScreenSize.y);

	float localDepth = texture3.Sample(sharpClampingSamplerState, input.tex).r;

	float shadowOpacity = 1.f;
	if (round(localDepth) >= NONSHADOWABLE_VALUE) {
		// Non shadowable
	} else {
		bool hardDepthSamples[] = {
			localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 1.f).r > 0,
			localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 3.f).r > 5,
			localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 5.f).r > 8,
		};

		if (hardDepthSamples[0] || hardDepthSamples[1] || hardDepthSamples[2]) {
			// We're on shadow
			shadowOpacity = SHADOW_OPACITY;
		} else {
			// We're not on shadow. Should we soft-shadow?
			bool softDepthSamples[] = {
				localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 2.f).r > 0,
				localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 3.f).r > 0,
				localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 4.f).r > 0,

				localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 4.f).r > 5,
				localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 5.f).r > 5,
				localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 6.f).r > 5,

				localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 6.f).r > 8,
				localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 7.f).r > 8,
				localDepth - texture3.Sample(sharpClampingSamplerState, input.tex + depthSamplingDirection * 8.f).r > 8
			};

			float opacityStep = (1.f - SHADOW_OPACITY) / 3.f;
			if (softDepthSamples[6] || softDepthSamples[7] || softDepthSamples[8]) {
				shadowOpacity -= softDepthSamples[6] ? opacityStep : 0.f;
				shadowOpacity -= softDepthSamples[7] ? opacityStep : 0.f;
				shadowOpacity -= softDepthSamples[8] ? opacityStep : 0.f;
			} else if (softDepthSamples[3] || softDepthSamples[4] || softDepthSamples[5]) {
				shadowOpacity -= softDepthSamples[3] ? opacityStep : 0.f;
				shadowOpacity -= softDepthSamples[4] ? opacityStep : 0.f;
				shadowOpacity -= softDepthSamples[5] ? opacityStep : 0.f;
			} else if (softDepthSamples[0] || softDepthSamples[1] || softDepthSamples[2]) {
				shadowOpacity -= softDepthSamples[0] ? opacityStep : 0.f;
				shadowOpacity -= softDepthSamples[1] ? opacityStep : 0.f;
				shadowOpacity -= softDepthSamples[2] ? opacityStep : 0.f;
			}
		}
	}

	float4 diffuseSample = texture0.Sample(sharpClampingSamplerState, input.tex) * shadowOpacity;
	float4 opacitySample = texture2.Sample(sharpClampingSamplerState, input.tex);

	float3 result = diffuseSample.rgb * (1.f - opacitySample.a) + opacitySample.rgb;

	return float4(result, 1.f);
}

// Rim lights
#define RIM_MIN_DEPTH 0.f
#define RIM_IGNORE_DEPTH 14.f
#define RIM_MAX_DEPTH 26.f
#define RIM_SAMPLES 10
#define RIM_SAMPLE_DELTA 2.f

float4 mainp_RimLight_PS(PixelLightingInput input) : SV_TARGET0 {
	float2 convertedPosition = input.position.xy * invScreenSize;

	float ownDepthSample = round(texture1.Sample(sharpClampingSamplerState, convertedPosition).r);
	if (ownDepthSample >= RIM_MIN_DEPTH && ownDepthSample <= RIM_MAX_DEPTH && ownDepthSample != RIM_IGNORE_DEPTH) {
		// Calculate rim strength
		float2 directionVector = normalize(input.tex) * invScreenSize * RIM_SAMPLE_DELTA;

		float depthSamples[RIM_SAMPLES];
		[unroll(RIM_SAMPLES)] for (int sampleN = 0; sampleN < RIM_SAMPLES; ++sampleN) {
			depthSamples[sampleN] = round(texture1.Sample(sharpClampingSamplerState, convertedPosition - directionVector * (sampleN + 1)).r);
		}

		int highestShadowedSample = RIM_SAMPLES;
		for (int shadowedSamples = RIM_SAMPLES - 1; shadowedSamples >= 0; --shadowedSamples) {
			if (ownDepthSample < depthSamples[shadowedSamples] - 2.f) {
				highestShadowedSample = shadowedSamples;
			}
		}

		float rimStrength = 1.f - float(highestShadowedSample) / RIM_SAMPLES;

		// Calculate light strength
		float lightRelativeDistance = sqrt(max(1.f - length(input.tex), 0.f));
		float lightIntensity = lightRelativeDistance * rimStrength;

		// Query sample's intensity
		float4 diffuseSample = texture0.Sample(sharpClampingSamplerState, convertedPosition);
		float diffuseApproximateIntensity = min(1.f, max(diffuseSample.r, max(diffuseSample.g, diffuseSample.b)) * 2.f);

		float4 correctedColor = float4(pow(input.color.rgb, GAMMA_CORRECTION), input.color.a); // TODO(cesm)
		return float4(correctedColor.rgb * diffuseApproximateIntensity, 1.f) * lightIntensity * correctedColor.a;
	}

	return float4(0.f, 0.f, 0.f, 0.f);
}

// Lighting shaders
PixelLightingInput mainv_Lighting_VS(VertexLightInputType input) {
	PixelLightingInput output;

	output.position = mul(float4(input.position.x, input.position.y, 0.f, 1.f), viewProjectionMatrix);
	output.screenSpacePos = output.position.xy / output.position.w;
	output.tex = input.tex;
	output.color = input.color;

	return output;
}

float4 mainp_LightingFiller_PS(PixelLightingInput input) : SV_TARGET0 {
	float lightIntensity = max(1.f - length(input.tex), 0.f);
	if (lightIntensity == 0.f) {
		discard;
	}
	float3 lightEffect = lightIntensity * input.color.rgb;

	return float4(lightEffect, lightIntensity) * input.color.a;
}

#define ROOMLIGHT_CUTOFF .3f
float4 mainp_LightingRoomFiller_PS(PixelLightingInput input) : SV_TARGET0 {
	float lightIntensity = 1.f - max(abs(input.tex.x), abs(input.tex.y));
	if (lightIntensity > ROOMLIGHT_CUTOFF) {
		lightIntensity = 1.f;
	} else {
		lightIntensity = pow(lightIntensity / ROOMLIGHT_CUTOFF, .6f);
	}

	return float4(lightIntensity * input.color.rgb, lightIntensity) * input.color.a;
}

#define LIGHTBUFFER_HEIGHT 256.f
#define LIGHTBUFFER_UTEXEL (1.f / (LIGHTBUFFER_HEIGHT * ASPECT_RATIO))
#define LIGHTBUFFER_VTEXEL (1.f / LIGHTBUFFER_HEIGHT)
#define LIGHTBUFFER_BLUR_RADIUS 4.f

float4 mainp_LightingBlurH_PS(PixelInputType input) : SV_TARGET0 {
	return float4(BlurValue(texture0, smoothClampingSamplerState, input.tex, float2(LIGHTBUFFER_UTEXEL, 0.f) * LIGHTBUFFER_BLUR_RADIUS).rgb, 1.f);
}

float4 mainp_LightingBlurV_PS(PixelInputType input) : SV_TARGET0 {
	return float4(BlurValue(texture0, smoothClampingSamplerState, input.tex, float2(0.f, LIGHTBUFFER_VTEXEL) * LIGHTBUFFER_BLUR_RADIUS).rgb, 1.f);
}

#define BAYER_SIZE 8.f

float3 PosterizeDithering(float3 color, int chDepth, Texture2D bayerTex, float2 position) {
	float ofs = bayerTex.SampleLevel(sharpClampingSamplerState, frac(position / BAYER_SIZE), 0).r - 0.5f;
	float chCount = (1 << chDepth) - 1.f;
	return color.rgb + (ofs / chCount);
}

#define LUT_ROWS 8.0 // LUT64
#define LUT_SIZE (LUT_ROWS * LUT_ROWS)
#define LUT_PADDING (1.0 / LUT_SIZE)

float2 LUT_Helper(float red, float green, float blue_slice) {
	float row;
	float col = modf(min(blue_slice, LUT_SIZE - 1.0) / LUT_ROWS, row);
	return float2 (
		(col)+((red * (1.0 - 2.0 * LUT_PADDING) + LUT_PADDING) / LUT_ROWS),
		(row / LUT_ROWS) + ((green * (1.0 - 2.0 * LUT_PADDING) + LUT_PADDING) / LUT_ROWS)
	);
}

float3 Grading_Helper(float3 color, Texture2D LUT) {
	float slice;
	float sliceLerp = modf(color.b * (LUT_SIZE - 1.f), slice);
	float3 sliceColor1 = LUT.SampleLevel(smoothClampingSamplerState, LUT_Helper(color.r, color.g, slice + 0.f), 0).rgb;
	float3 sliceColor2 = LUT.SampleLevel(smoothClampingSamplerState, LUT_Helper(color.r, color.g, slice + 1.f), 0).rgb;
	return lerp(sliceColor1, sliceColor2, sliceLerp);
}

float3 ReinhardToneMapping(float3 color, float exposure) {
	return color * exposure / ((1.f + color) / exposure);
}

float ReinhardToneMapping(float luma, float exposure) {
	return luma * exposure / ((1.f + luma) / exposure);
}

float3 ReinhardLumaToneMapping(float3 color, float exposure) {
	return color * exposure / ((1.f + GetLuma(color)) / exposure);
}

float4 mainp_LightingPost_PS(PixelInputType input) : SV_TARGET0 {
	float3 diffuseTextureSample = texture0.Sample(sharpClampingSamplerState, input.tex).rgb;
	float3 multiplicativeLightEffect = texture1.Sample(smoothClampingSamplerState, input.tex).rgb;
	float3 additiveLightEffect = texture2.Sample(smoothClampingSamplerState, input.tex).rgb;
	float emissiveFactor = texture3.Sample(sharpClampingSamplerState, input.tex).a;
	float3 glowSample = texture4.Sample(smoothClampingSamplerState, input.tex).rgb;

	float vignetteValue = max(0.f, length(input.tex * 2.f - 1.f) - .8f);
	float vignetteStrength = 1.f - ReinhardToneMapping(vignetteValue, 1.4f);

	// Apply multiplicative light 
	// float3 diffuseLinear = pow(diffuseTextureSample.rgb, 1.f / GAMMA_CORRECTION); // Old formula. TODO(jordisantiago): Check if old formula gets better results
	float3 diffuseLinear = max(1.055f * pow(diffuseTextureSample.rgb, 1.0f / 2.4f) - 0.055f, 0.f);
	float3 invGammaCorrected = pow(sqrt(diffuseLinear) * multiplicativeLightEffect, 2.f);
	float3 postLight = (lerp(invGammaCorrected, diffuseLinear, emissiveFactor) + additiveLightEffect + ReinhardLumaToneMapping(glowSample, 1.25f * (1.01f - emissiveFactor)));

	float3 toneColor = saturate(PosterizeDithering(postLight.rgb, 8, texture5, input.position.xy));
	float3 nogradResult = Grading_Helper(toneColor, texture8);
	float3 result = lerp(nogradResult, lerp(Grading_Helper(toneColor, texture6), Grading_Helper(toneColor, texture7), LUTInterpolation), LUTPower) * vignetteStrength;
	return float4(result, 1.f);
}

// Glow
#define GLOWBUFFER_HEIGHT 128.f
#define GLOWBUFFER_UTEXEL (1.f / (GLOWBUFFER_HEIGHT * ASPECT_RATIO))
#define GLOWBUFFER_VTEXEL (1.f / GLOWBUFFER_HEIGHT)
#define GLOWBUFFER_BLUR_RADIUS 1.f

#define GLOWBLUR_KERNEL_SIZE 5
#define GLOWBLUR_KERNEL_COUNT 5

static const float glowBlurWeights[GLOWBLUR_KERNEL_SIZE * GLOWBLUR_KERNEL_COUNT] =
{ 
	.987581f, .006210f, .000000f, .000000f, .000000f, // Gaussian kernel sigma 0.2
	.595343f, .196119f, .006194f, .000015f, .000000f, // Gaussian kernel sigma 0.6
	.382928f, .241732f, .060598f, .005977f, .000229f, // Gaussian kernel sigma 1.0
	.279380f, .218790f, .105053f, .030904f, .005563f, // Gaussian kernel sigma 1.4
	.221569f, .190631f, .121403f, .057223f, .019959f  // Gaussian kernel sigma 1.8
};

float4 GlowBlurValue(Texture2D source, SamplerState samplerState, float2 texCoord, float2 texelSizes, float blurStrength) {
	int kernelIndex = int(clamp(blurStrength * GLOWBLUR_KERNEL_COUNT, 0, GLOWBLUR_KERNEL_COUNT - 1));
	float4 sampled = source.Sample(samplerState, texCoord) * glowBlurWeights[kernelIndex * GLOWBLUR_KERNEL_SIZE];

	float4 neighboringSamples = 0.f;
	for (int sampleN = 1; sampleN < GLOWBLUR_KERNEL_SIZE; ++sampleN) {
		neighboringSamples += source.Sample(samplerState, texCoord - float2(texelSizes.x * sampleN, texelSizes.y * sampleN)) * glowBlurWeights[kernelIndex * GLOWBLUR_KERNEL_SIZE + sampleN];
		neighboringSamples += source.Sample(samplerState, texCoord + float2(texelSizes.x * sampleN, texelSizes.y * sampleN)) * glowBlurWeights[kernelIndex * GLOWBLUR_KERNEL_SIZE + sampleN];
	}

	return (sampled + neighboringSamples) * pow(blurStrength, 0.33f);
}

float4 mainp_GlowFirstPass_PS(PixelInputType input) : SV_TARGET0 {
	return float4(texture0.Sample(smoothClampingSamplerState, input.tex).rgb * EMISSIVE_STR_MULTIPLIER, 1.f);
}

float4 mainp_GlowBlurH_PS(PixelInputType input) : SV_TARGET0 {
	float blurStrength = clamp(texture1.Sample(smoothWrappingSamplerState, input.tex).r, 1.0f, 32.0f) / 32.f;
	return GlowBlurValue(texture0, smoothClampingSamplerState, input.tex, float2(GLOWBUFFER_UTEXEL, 0.f), blurStrength);
}

float4 mainp_GlowBlurV_PS(PixelInputType input) : SV_TARGET0 {
	float blurStrength = clamp(texture1.Sample(smoothWrappingSamplerState, input.tex).r, 1.0f, 32.0f) / 32.f;
	return GlowBlurValue(texture0, smoothClampingSamplerState, input.tex, float2(0.f, GLOWBUFFER_VTEXEL), blurStrength);
}

float4 mainp_GlowApply_PS(PixelInputType input) : SV_TARGET0 {
	return float4(texture0.Sample(smoothClampingSamplerState, input.tex).rgb * (1.f - texture1.Sample(smoothClampingSamplerState, input.tex).a), 1.f); // TODO(cesm) We output sRGB to blend in sRGB, see m_layerBuffer creation
}

// Refraction shader
#define REFRACTION_STR .01f

PixelProcessOutput mainp_Refraction_PS(PixelInputType input) {
	PixelProcessOutput output;

	float2 noise = (texture4.Sample(sharpClampingSamplerState, input.tex).rg - .5f) * 2.f * float2(1.f / ASPECT_RATIO, 1.f);
	float2 samplingCoord = input.tex + (noise * REFRACTION_STR * float2(-1.f, 1.f));

	output.diffuse = float4(texture0.Sample(smoothClampingSamplerState, samplingCoord));
	output.emissive = float4(texture1.Sample(smoothClampingSamplerState, samplingCoord));
	output.transparency = float4(texture2.Sample(smoothClampingSamplerState, samplingCoord));
	output.depth = float4(texture3.Sample(smoothClampingSamplerState, samplingCoord));

	return output;
}

// Layer merging

cbuffer LayerMergerCBufferType : register(b2) {
	float layerInterpolation;
};

float4 mainp_LayerMerger_PS(PixelInputType input) : SV_TARGET0 {
	float4 layer0Sample = texture0.Sample(sharpClampingSamplerState, input.tex);
	float4 layer1Sample = texture1.Sample(sharpClampingSamplerState, input.tex);

	float4 result = lerp(layer1Sample, layer0Sample, layerInterpolation); // TODO(cesm) Layers are in sRGB, store the result in linear (will be automatically converted to sRGB)

	result.rgb *= brightness;

	return result;
}

// UI Shadowing
struct PixelUIOutput {
	float4 diffuse : SV_TARGET0;
	float4 shadow : SV_TARGET1;
};

#define UISHADOW_DISTANCE .03f
#define UISHADOW_X (UISHADOW_DISTANCE / ASPECT_RATIO)
#define UISHADOW_Y (UISHADOW_DISTANCE)

PixelUIOutput mainp_ColorUINonShadowed_PS(PixelInputType input) {
	PixelUIOutput output;

	output.diffuse = float4(input.color.rgb * input.color.a, input.color.a);
	output.shadow = float4(0.f, 0.f, 0.f, input.color.a);

	return output;
}

PixelInputType mainv_TextureUIShadowed_VS(VertexInputType input) {
	PixelInputType output;

	output.position = float4(input.position.x + UISHADOW_X, input.position.y - UISHADOW_Y, 0.f, 1.f);
	output.tex = input.tex;
	output.color = input.color;

	return output;
}

PixelUIOutput mainp_TextureUIShadowed_PS(PixelInputType input) {
	PixelUIOutput output;

	float4 textureColor = texture0.Sample(smoothWrappingSamplerState, input.tex);
	output.diffuse = float4(0.f, 0.f, 0.f, 0.f);
	output.shadow = float4(textureColor.a, 0.f, 0.f, textureColor.a);

	return output;
}

PixelUIOutput mainp_TextureUIShadowedColored_PS(PixelInputType input) {
	PixelUIOutput output;

	float4 textureColor = texture0.Sample(smoothWrappingSamplerState, input.tex);
	output.diffuse = float4(0.f, 0.f, 0.f, 0.f);
	output.shadow = float4(textureColor.a * input.color.a, 0.f, 0.f, textureColor.a * input.color.a);

	return output;
}

PixelUIOutput mainp_TextureUINonShadowed_PS(PixelInputType input) {
	PixelUIOutput output;

	float4 textureColor = texture0.Sample(smoothWrappingSamplerState, input.tex);
	output.diffuse = float4(textureColor.rgb, textureColor.a);
	output.shadow = float4(0.f, 0.f, 0.f, textureColor.a);

	return output;
}

PixelUIOutput mainp_TextureUINonShadowedColored_PS(PixelInputType input) {
	PixelUIOutput output;

	float4 textureColor = texture0.Sample(smoothWrappingSamplerState, input.tex);
	output.diffuse = float4(textureColor.rgb * input.color.rgb * input.color.a, textureColor.a * input.color.a);
	output.shadow = float4(0.f, 0.f, 0.f, textureColor.a * input.color.a);

	return output;
}

PixelUIOutput mainp_TextureUINonShadowedGrayscale_PS(PixelInputType input) {
	PixelUIOutput output;

	float4 textureColor = texture0.Sample(smoothWrappingSamplerState, input.tex);
	float textureLuma = GetLuma(textureColor.rgb);
	output.diffuse = float4(lerp(textureColor.rgb, float3(textureLuma, textureLuma, textureLuma), input.color.r) * input.color.a, textureColor.a * input.color.a);
	output.shadow = float4(0.f, 0.f, 0.f, textureColor.a * input.color.a);

	return output;
}

#define UISHADOW_SOFT_DISTANCE .001f
#define UISHADOW_SOFT_X (UISHADOW_SOFT_DISTANCE / ASPECT_RATIO)
#define UISHADOW_SOFT_Y (UISHADOW_SOFT_DISTANCE)
#define UISHADOW_OPACITY .55f

float4 mainp_UIProcess_PS(PixelInputType input) : SV_TARGET0 {
	float shadowSamples = texture1.Sample(sharpClampingSamplerState, input.tex).r +
		texture1.Sample(sharpClampingSamplerState, input.tex + float2(UISHADOW_SOFT_X, UISHADOW_SOFT_Y)).r + texture1.Sample(sharpClampingSamplerState, input.tex + float2(UISHADOW_SOFT_X * 2, UISHADOW_SOFT_Y * 2)).r +
		texture1.Sample(sharpClampingSamplerState, input.tex + float2(UISHADOW_SOFT_X, -UISHADOW_SOFT_Y)).r + texture1.Sample(sharpClampingSamplerState, input.tex + float2(UISHADOW_SOFT_X * 2, -UISHADOW_SOFT_Y * 2)).r +
		texture1.Sample(sharpClampingSamplerState, input.tex + float2(-UISHADOW_SOFT_X, UISHADOW_SOFT_Y)).r + texture1.Sample(sharpClampingSamplerState, input.tex + float2(-UISHADOW_SOFT_X * 2, UISHADOW_SOFT_Y * 2)).r +
		texture1.Sample(sharpClampingSamplerState, input.tex + float2(0.f, UISHADOW_SOFT_Y)).r + texture1.Sample(sharpClampingSamplerState, input.tex + float2(0.f, UISHADOW_SOFT_Y * 2)).r +
		texture1.Sample(sharpClampingSamplerState, input.tex + float2(UISHADOW_SOFT_X, 0.f)).r + texture1.Sample(sharpClampingSamplerState, input.tex + float2(UISHADOW_SOFT_X * 2, 0.f)).r;

	float shadow = 1.f - shadowSamples / 11.f * (1.f - UISHADOW_OPACITY);

	float3 diffuse = texture0.Sample(smoothClampingSamplerState, input.tex).rgb * shadow;

	return float4(diffuse, 1.f);
}

// 3D shaders
PixelInputType mainv_World3DTexture_VS(VertexInputType input) {
	PixelInputType output;

	output.position = mul(input.position, projectionMatrix);
	output.tex = input.tex;

	return output;
}

float4 mainp_Journal_PS(PixelInputType input, bool isFrontFace : SV_ISFRONTFACE) : SV_TARGET0 {
	float4 textureSample = texture0.Sample(smoothWrappingSamplerState, !isFrontFace ? float2(1.f - input.tex.x, input.tex.y): input.tex);
	if (textureSample.a < .9f) {
		discard;
	}

	return float4(textureSample.rgb, textureSample.a);
}

// Debug shaders
float4 mainp_TextureDebug_PS(PixelInputType input) : SV_TARGET0 {
	return float4(input.tex.r, input.tex.g, 0.f, .8f);
}

float4 mainp_ShadowerDepthDebug_PS(PixelInputType input) : SV_TARGET0 {
	return texture1.Sample(sharpClampingSamplerState, input.tex) / 36.f;
}
