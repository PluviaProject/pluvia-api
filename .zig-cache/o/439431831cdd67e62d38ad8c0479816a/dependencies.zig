pub const packages = struct {
    pub const @"N-V-__8AAEGLAAB4JS8S1rWwdvXUTwnt7gRNthhJanWx4AvP" = struct {
        pub const build_root = "/home/tux/.cache/zig/p/N-V-__8AAEGLAAB4JS8S1rWwdvXUTwnt7gRNthhJanWx4AvP";
        pub const build_zig = @import("N-V-__8AAEGLAAB4JS8S1rWwdvXUTwnt7gRNthhJanWx4AvP");
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"httpz-0.0.0-PNVzrFndBgDr9zQx7Mj_MFiqYslgcRlx45FJ_gERmRTb" = struct {
        pub const build_root = "/home/tux/.cache/zig/p/httpz-0.0.0-PNVzrFndBgDr9zQx7Mj_MFiqYslgcRlx45FJ_gERmRTb";
        pub const build_zig = @import("httpz-0.0.0-PNVzrFndBgDr9zQx7Mj_MFiqYslgcRlx45FJ_gERmRTb");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "metrics", "metrics-0.0.0-W7G4eP2_AQAdJGKMonHeZFaY4oU4ZXPFFTqFCFXItX3O" },
            .{ "websocket", "websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV" },
        };
    };
    pub const @"metrics-0.0.0-W7G4eP2_AQAdJGKMonHeZFaY4oU4ZXPFFTqFCFXItX3O" = struct {
        pub const build_root = "/home/tux/.cache/zig/p/metrics-0.0.0-W7G4eP2_AQAdJGKMonHeZFaY4oU4ZXPFFTqFCFXItX3O";
        pub const build_zig = @import("metrics-0.0.0-W7G4eP2_AQAdJGKMonHeZFaY4oU4ZXPFFTqFCFXItX3O");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
    pub const @"metrics-0.0.0-W7G4eP2_AQBKsaql3dhLJ-pkf-RdP-zV3vflJy4N34jC" = struct {
        pub const build_root = "/home/tux/.cache/zig/p/metrics-0.0.0-W7G4eP2_AQBKsaql3dhLJ-pkf-RdP-zV3vflJy4N34jC";
        pub const build_zig = @import("metrics-0.0.0-W7G4eP2_AQBKsaql3dhLJ-pkf-RdP-zV3vflJy4N34jC");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
    pub const @"pg-0.0.0-Wp_7gfctBgDqwQeDUvgpYeFe7VMR9T0ovGrTSXtSdQeV" = struct {
        pub const build_root = "/home/tux/.cache/zig/p/pg-0.0.0-Wp_7gfctBgDqwQeDUvgpYeFe7VMR9T0ovGrTSXtSdQeV";
        pub const build_zig = @import("pg-0.0.0-Wp_7gfctBgDqwQeDUvgpYeFe7VMR9T0ovGrTSXtSdQeV");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "buffer", "N-V-__8AAEGLAAB4JS8S1rWwdvXUTwnt7gRNthhJanWx4AvP" },
            .{ "metrics", "metrics-0.0.0-W7G4eP2_AQBKsaql3dhLJ-pkf-RdP-zV3vflJy4N34jC" },
        };
    };
    pub const @"websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV" = struct {
        pub const build_root = "/home/tux/.cache/zig/p/websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV";
        pub const build_zig = @import("websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "httpz", "httpz-0.0.0-PNVzrFndBgDr9zQx7Mj_MFiqYslgcRlx45FJ_gERmRTb" },
    .{ "pg", "pg-0.0.0-Wp_7gfctBgDqwQeDUvgpYeFe7VMR9T0ovGrTSXtSdQeV" },
};
