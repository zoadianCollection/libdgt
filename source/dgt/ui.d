module dgt.ui;

import dgt.array : Array;
import dgt.geom : Rectanglei, Vectori;
import dgt.texture : Texture;
import dgt.window : Window;

struct Button
{
    @disable this();

    public @nogc nothrow:

    Rectanglei area;
    Vectori position;
    Texture tex, hover, press;

    this(in Rectanglei area, in Vectori position, in Texture tex, in Texture hover, in Texture press)
    {
        this.area = area;
        this.position = position;
        this.tex = tex;
        this.hover = hover;
        this.press = press;
    }

    bool draw(ref scope Window window) const
    {
        bool mouseContained = area.contains(window.mouse);
        window.draw(mouseContained ? (window.mouseLeftPressed ? press : hover) : tex,
                position.x, position.y);
        return mouseContained && window.mouseLeftReleased;
    }
}

struct Slider
{
    public @nogc nothrow:
    Rectanglei area;
    Texture slider;

    @disable this();

    this(in Rectanglei area, in Texture sliderHead)
    {
        this.area = area;
        this.slider = sliderHead;
    }

    float draw(ref scope Window window, in float current) const
    {
        window.draw(slider, -slider.size.width / 2 + area.x + current * area.width,
                -slider.size.height / 2 + area.y + area.height / 2);
        if (window.mouseLeftPressed && area.contains(window.mouse))
            return (window.mouse.x - area.x) / cast(float)(area.width);
        else
            return current;
    }

}

struct Carousel
{
    @disable this();
    public @nogc nothrow:
    Button left, right;
    Vectori position;
    const(Array!Texture) textures;

    this(in Button left, in Button right, in Vectori currentItemPosition, in Array!Texture textures)
    {
        this.left = left;
        this.right = right;
        this.position = currentItemPosition;
        this.textures = textures;
    }

    int draw(ref scope Window window, in int current) const
    {
        int next = current;
        if (left.draw(window))
            next --;
        if (right.draw(window))
            next ++;
        next = cast(int)((next + textures.length) % textures.length);
        window.draw(textures[next], position.x, position.y);
        return next;
    }
}
