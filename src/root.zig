pub const repository: type = @import("repository/repository.zig");
pub const controller: type = struct {
    pub const core: type = @import("controller/controller.zig");
    pub const utils: type = @import("controller/utils.zig");
    pub const types: type = @import("controller/types.zig");
};
pub const service: type = @import("service/service.zig");
pub const server: type = @import("server.zig");

