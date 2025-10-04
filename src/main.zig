const internal: type = @import("root.zig");

pub const std: type = @import("std");
pub const httpz: type = @import("httpz");
pub const curl: type = @import("curl");

pub const service: type = internal.service;
pub const repository: type = internal.repository;
pub const controller: type = internal.controller;
pub const server: type = internal.server;

pub const Server_T: type = httpz.Server(void);

pub const allocator = @import("allocator.zig").allocator;

pub fn main() anyerror!void {
    try @constCast((try @call(.always_inline, server.routes_load, .{
        @constCast(&(try @call(.always_inline, server.server_init, .{

        })))
    }))).listen();
}

