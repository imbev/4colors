const std = @import("std");
const c = @cImport({
    @cInclude("SDL3/SDL.h");
});

pub const Color = enum {
    BLUE,
    GREEN,
    RED,
    YELLOW,
};

pub const Rectangle = struct {
    renderer: *c.SDL_Renderer,
    color: Color,
    x: usize,
    y: usize,
    width: usize,
    height: usize,

    pub fn init(
        renderer: *c.SDL_Renderer,
        color: Color,
        x: usize, y:usize) Rectangle {
        return Rectangle {
            .renderer = renderer,
            .color = color,
            .x = x,
            .y = y,
            .width = 400,
            .height = 320
        };
    }

    pub fn render(self: Rectangle) void {
        switch (self.color) {
            Color.BLUE => {
                _ = c.SDL_SetRenderDrawColor(self.renderer, 0, 0, 255, 100);
            },
            Color.GREEN => {
                _ = c.SDL_SetRenderDrawColor(self.renderer, 0, 255, 0, 100);
            },
            Color.RED => {
                _ = c.SDL_SetRenderDrawColor(self.renderer, 255, 0, 0, 100);
            },
            Color.YELLOW => {
                _ = c.SDL_SetRenderDrawColor(self.renderer, 255, 255, 0, 100);
            }
        }
        const rect = c.SDL_FRect{
            .x = @floatFromInt(self.x),
            .y = @floatFromInt(self.y),
            .w = @floatFromInt(self.width),
            .h = @floatFromInt(self.height)
        };
        _ = c.SDL_RenderFillRect(self.renderer, &rect);
    }
};

pub fn main() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) == false) {
        c.SDL_Log("Failed to init sdl: %s\n", c.SDL_GetError());
    }
    defer c.SDL_Quit();

    const window: *c.SDL_Window = c.SDL_CreateWindow("4 Colors", 800, 640, 0).?;
    defer c.SDL_DestroyWindow(window);

    const renderer: *c.SDL_Renderer = c.SDL_CreateRenderer(window, null).?;
    defer c.SDL_DestroyRenderer(renderer);

    var blue_rect = Rectangle.init(renderer, Color.BLUE, 0, 0);
    var green_rect = Rectangle.init(renderer, Color.GREEN, 400, 0);
    var red_rect = Rectangle.init(renderer, Color.RED, 0, 320);
    var yellow_rect = Rectangle.init(renderer, Color.YELLOW, 400, 320);

    var quit: bool = false;
    var e: c.SDL_Event = std.mem.zeroes(c.SDL_Event);
    while (!quit) {

        while ( c.SDL_PollEvent(&e)) {

            if (e.type == c.SDL_EVENT_QUIT) {
                quit = true;
            }
        }

        _ = c.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);
        _ = c.SDL_RenderClear(renderer);

        blue_rect.render();
        green_rect.render();
        red_rect.render();
        yellow_rect.render();

        _ = c.SDL_RenderPresent(renderer);
    }

}

