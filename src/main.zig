const pg: type = @import("pg");
const std: type = @import("std");
const httpz: type = @import("httpz");

const allocator = gpa.allocator();
var gpa = std.heap.GeneralPurposeAllocator(.{}) {};

pub fn main() anyerror!void {
    var server = try httpz.Server(void).init(allocator, .{.port = 5882}, {});
    var router = try server.router(.{});
    defer {
        server.stop();
        server.deinit();
    }
    const pool = try pg.Pool.init(allocator, .{
        .connect = .{
            .port = "",
            .host = "",
        },
        .auth = .{
            .username = "postgres",
            .database = "postgres",
            .password = "postgres",
            .timeout = 10_000,
        }
    });
    const result = try pool.query(
        \\

        ,.{

        }
    );
    result.column_names
    router.get("/api/user/:id", getUser, .{});
    // try server.listen();
}

fn getUser(req: *httpz.Request, res: *httpz.Response) anyerror!void {
  res.status = 200;
  try res.json(.{.id = req.param("id").?, .name = "Teg"}, .{});
}
