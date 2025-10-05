const root: type = @import("root");

const std: type = root.std;

const allocator = root.allocator;

pub fn parseRequestData(json: []const u8, T: type) anyerror!T {
    return (try std.json.parseFromSlice(T, allocator, json, .{})).value;
}

pub fn requestDateResolve(date: []const u8) anyerror!struct { []const u8, []const u8 } {
    const yearEnd = (try std.fmt.parseInt(u32, date[0..4], 10) - 1);
    const yearStart = (try std.fmt.parseInt(u32, date[0..4], 10) - 31);
    const month: []const u8 = date[5..7];
    const day: []const u8 = date[8..10];
    return .{
        try std.fmt.allocPrint(allocator, "{d}{s}{s}", .{
            yearStart, month, day
        }),
        try std.fmt.allocPrint(allocator, "{d}{s}{s}", .{
            yearEnd, month, day
        }),
    };
}

pub fn internalError() error { internalError }!void {
    return error.internalError;
}

pub fn accumulate(param: *const std.json.Value, suffix: []const u8, sum_ptr: *f64, count_ptr: *usize) void {
    switch (param.*) {
        .object => |obj| {
            var it = obj.iterator();
            while (it.next()) |entry| {
                const date = entry.key_ptr.*;
                if (std.mem.endsWith(u8, date, suffix)) {
                    switch (entry.value_ptr.*) {
                        .float => |val| {
                            if (val != -999.0) {
                                sum_ptr.* += val;
                                count_ptr.* += 1;
                            }
                        },
                        else => continue,
                    }
                }
            }
        },
        else => return,
    }
}
