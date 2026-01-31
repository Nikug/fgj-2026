extends TextureButton

@export var triangle_color: Color = Color.WHITE
@export var triangle_size: int = 32
@export var pointing_left: bool = false

func _ready():
    texture_normal = create_triangle_texture(triangle_color, pointing_left)
    custom_minimum_size = Vector2(triangle_size, triangle_size)

func create_triangle_texture(color: Color, left: bool) -> ImageTexture:
    var image = Image.create(triangle_size, triangle_size, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    var points = []
    if left:
        # Left-pointing triangle
        points = [Vector2(triangle_size - 4, 4), Vector2(triangle_size - 4, triangle_size - 4), Vector2(4, triangle_size / 2)]
    else:
        # Right-pointing triangle
        points = [Vector2(4, 4), Vector2(4, triangle_size - 4), Vector2(triangle_size - 4, triangle_size / 2)]
    
    # Draw filled triangle
    for y in range(triangle_size):
        for x in range(triangle_size):
            if point_in_triangle(Vector2(x, y), points[0], points[1], points[2]):
                image.set_pixel(x, y, color)
    
    return ImageTexture.create_from_image(image)

func point_in_triangle(p: Vector2, a: Vector2, b: Vector2, c: Vector2) -> bool:
    var area = abs((b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y))
    var area1 = abs((p.x - b.x) * (c.y - b.y) - (c.x - b.x) * (p.y - b.y))
    var area2 = abs((a.x - p.x) * (c.y - p.y) - (c.x - p.x) * (a.y - p.y))
    var area3 = abs((a.x - b.x) * (p.y - b.y) - (b.x - p.x) * (a.y - b.y))
    return abs(area - (area1 + area2 + area3)) < 1.0