const std: type = @import("root").std;

pub const allocator = gpa.allocator();
var gpa = std.heap.GeneralPurposeAllocator(.{}) {};
