const internal: type = @import("root.zig");

pub const std: type = @import("std");
pub const httpz: type = @import("httpz");
pub const curl: type = @import("curl");

pub const service: type = internal.service;
pub const repository: type = internal.repository;
pub const controller: type = internal.controller;
//pub const server: type = internal.server;

pub const Server_T: type = httpz.Server(void);

pub const allocator = @import("allocator.zig").allocator;

const routes = [_]struct {
    router: []const u8,
    fun: *const fn(*httpz.Request, *httpz.Response) anyerror!void,
    type: enum {
        POST,
        GET
    },
} {
    .{
        .router = "/api/weather",
        .fun = &controller.core.NASAPrediction,
        .type = .POST,
    },
};

pub fn main() anyerror!void {
    var server = try httpz.Server(void).init(allocator, .{
            .address = "191.252.92.87",
            .port = 8080,
        },
        {}
    );
    defer server.deinit();
    const cors = try server.middleware(httpz.middleware.Cors, .{
        .origin = "*",
        .methods = "GET, POST, PUT, DELETE, OPTIONS",
        .max_age = "86400",
    });
    var router = try server.router(.{.middlewares = &.{cors}});
    inline for(routes) |r| {
        switch(r.type) {
            .GET => router.get(r.router, r.fun, .{
            }),
            .POST => router.post(r.router, r.fun, .{
            }),
        }
    }
    try server.listen();
}

