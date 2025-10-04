const std: type = @import("root").std;
const httpz: type = @import("root").httpz;

pub fn NASAPrediction(req: *httpz.Request, _: *httpz.Response) anyerror!void {
    r: {
        std.debug.print("{s}\n", .{
            req.body() orelse break :r {}
        });
    }
    while(true) {}
}
