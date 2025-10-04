pub const packages = struct {
    pub const @"N-V-__8AAFrtpQI1j9eOv7aN3lt3eH1TJfH4npAdRIrg2gGH" = struct {
        pub const available = true;
        pub const build_root = "/home/tux/.cache/zig/p/N-V-__8AAFrtpQI1j9eOv7aN3lt3eH1TJfH4npAdRIrg2gGH";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"N-V-__8AAHipPQF9UuLPiaV1CtJzZIxvTN61tMGdFx8LGjIV" = struct {
        pub const available = true;
        pub const build_root = "/home/tux/.cache/zig/p/N-V-__8AAHipPQF9UuLPiaV1CtJzZIxvTN61tMGdFx8LGjIV";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"N-V-__8AAJj_QgDBhU17TCtcvdjOZZPDfkvxrEAyZkc14VN8" = struct {
        pub const available = true;
        pub const build_root = "/home/tux/.cache/zig/p/N-V-__8AAJj_QgDBhU17TCtcvdjOZZPDfkvxrEAyZkc14VN8";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"curl-0.3.2-P4tT4SXPAACuV6f5eyh4jG_1SspjWwMm_vRJfoKrQep5" = struct {
        pub const build_root = "/home/tux/.cache/zig/p/curl-0.3.2-P4tT4SXPAACuV6f5eyh4jG_1SspjWwMm_vRJfoKrQep5";
        pub const build_zig = @import("curl-0.3.2-P4tT4SXPAACuV6f5eyh4jG_1SspjWwMm_vRJfoKrQep5");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "curl", "N-V-__8AAHipPQF9UuLPiaV1CtJzZIxvTN61tMGdFx8LGjIV" },
            .{ "zlib", "N-V-__8AAJj_QgDBhU17TCtcvdjOZZPDfkvxrEAyZkc14VN8" },
            .{ "mbedtls", "N-V-__8AAFrtpQI1j9eOv7aN3lt3eH1TJfH4npAdRIrg2gGH" },
        };
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
    pub const @"websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV" = struct {
        pub const build_root = "/home/tux/.cache/zig/p/websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV";
        pub const build_zig = @import("websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "httpz", "httpz-0.0.0-PNVzrFndBgDr9zQx7Mj_MFiqYslgcRlx45FJ_gERmRTb" },
    .{ "curl", "curl-0.3.2-P4tT4SXPAACuV6f5eyh4jG_1SspjWwMm_vRJfoKrQep5" },
};
