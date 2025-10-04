const root: type = @import("root");

const httpz: type = root.httpz;
const controller: type = root.controller;

const Server_T: type = root.Server_T;

const allocator = @import("root").allocator;

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
        .fun = &controller.NASAPredictio,
        .type = .POST,
    },
};

pub fn server_init() anyerror!Server_T {
    return @call(.never_inline, Server_T.init, .{
        allocator,
        httpz.Config {
            .address = "10.9.6.92",
            .port = 8080,
        },
        {}
    });
}

pub fn routes_load(server: *Server_T) anyerror!*const Server_T {
    const router = try server.router(.{});
    inline for(routes) |r| {
        switch(r.type) {
            .GET => router.get(r.router, r.fun, .{}),
            .POST => router.post(r.router, r.fun, .{}),
        }
    }
    return server;
}
