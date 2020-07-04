shader_type canvas_item;
uniform vec4 color : hint_color;

void fragment(){ 
	COLOR.rgb = color.rgb;    // 颜色
	COLOR.a = texture(TEXTURE, UV).a; // 形状
}