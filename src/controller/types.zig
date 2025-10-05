pub const RequestParser_T: type = struct {
    date: []const u8,
    place: struct {
        coordinates: [2]f64,
        address: []const u8,
    },
    description: []const u8,
};

pub const TemporalInfo_T: type = struct {
    temperature: u32,
    windSpeed: u32,
    precipitationPercentage: u32,
};

pub const Coord_T: type = enum {
    lat,
    lon,
};
