const std: type = @import("root").std;
const httpz: type = @import("root").httpz;

const allocator = @import("root").allocator;

fn accumulate(param: *const std.json.Value, suffix: []const u8, sum_ptr: *f64, count_ptr: *usize) void {
    // Mudança aqui: use switch em vez de verificar json_type
    switch (param.*) {
        .object => |obj| {
            var it = obj.iterator();
            while (it.next()) |entry| {
                const date = entry.key_ptr.*;
                if (std.mem.endsWith(u8, date, suffix)) {
                    // Mudança aqui: acesse o valor float de forma diferente
                    switch (entry.value_ptr.*) {
                        .float => |val| {
                            if (val != -999.0) { // ignora dados faltantes
                                sum_ptr.* += val;
                                count_ptr.* += 1;
                            }
                        },
                        .integer => |val| {
                            const float_val = @as(f64, @floatFromInt(val));
                            if (float_val != -999.0) {
                                sum_ptr.* += float_val;
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

const Coordinates = struct {
    latitude: f64,
    longitude: f64,
};

const Place = struct {
    coordinates: Coordinates,
    address: []const u8,
};

const PredictionRequest = struct {
    date: []const u8,
    place: Place,
    description: []const u8,
};

fn parseRequestData(json_body: []const u8) anyerror!PredictionRequest {
    var parsed = try std.json.parseFromSlice(std.json.Value, allocator, json_body, .{});
    defer parsed.deinit();

    const root = parsed.value;

    const date = if (root.object.get("date")) |date_value|
        if (date_value == .string) date_value.string else return error.InvalidDate
    else return error.MissingDate;

    const place_obj = if (root.object.get("place")) |place_value|
        if (place_value == .object) place_value.object else return error.InvalidPlace
    else return error.MissingPlace;

    const coordinates_array = if (place_obj.get("coordinates")) |coords_value|
        if (coords_value == .array) coords_value.array else return error.InvalidCoordinates
    else return error.MissingCoordinates;

    if (coordinates_array.items.len != 2) return error.InvalidCoordinatesLength;

    const latitude = if (coordinates_array.items[0] == .number_string)
        try std.fmt.parseFloat(f64, coordinates_array.items[0].number_string)
    else if (coordinates_array.items[0] == .integer)
        @as(f64, @floatFromInt(coordinates_array.items[0].integer))
    else if (coordinates_array.items[0] == .float)
        coordinates_array.items[0].float
    else return error.InvalidLatitude;

    const longitude = if (coordinates_array.items[1] == .number_string)
        try std.fmt.parseFloat(f64, coordinates_array.items[1].number_string)
    else if (coordinates_array.items[1] == .integer)
        @as(f64, @floatFromInt(coordinates_array.items[1].integer))
    else if (coordinates_array.items[1] == .float)
        coordinates_array.items[1].float
    else return error.InvalidLongitude;

    const address = if (place_obj.get("address")) |addr_value|
        if (addr_value == .string) addr_value.string else return error.InvalidAddress
    else return error.MissingAddress;

    const description = if (root.object.get("description")) |desc_value|
        if (desc_value == .string) desc_value.string else return error.InvalidDescription
    else return error.MissingDescription;

    return PredictionRequest{
        .date = date,
        .place = Place{
            .coordinates = Coordinates{
                .latitude = latitude,
                .longitude = longitude,
            },
            .address = address,
        },
        .description = description,
    };
}

pub fn NASAPredictio(_: *httpz.Request, res: *httpz.Response) anyerror!void {
    res.body = @embedFile("json.txt");
}


pub fn NASAPrediction(req: *httpz.Request, res: *httpz.Response) anyerror!void {
    errdefer {
        res.status = 500;
    }

    var parsed = try std.json.parseFromSlice(std.json.Value, allocator, req.body().?, .{});
    defer parsed.deinit();

    _ = try parseRequestData(req.body() orelse {
        res.status = 400; return;
    });

    const v = parsed.value;
    const param_map = v.object
        .get("properties").?
        .object.get("parameter").?
        .object;

    var results = struct {
        ws_sum: f64 = 0,
        t_sum: f64 = 0,
        p_sum: f64 = 0,
        count: usize = 0,
    }{};

    const date_suffix = "0210";

    accumulate(&param_map.get("WS10M").?, date_suffix, &results.ws_sum, &results.count);
    accumulate(&param_map.get("T2M").?, date_suffix, &results.t_sum, &results.count);
    accumulate(&param_map.get("PRECTOTCORR").?, date_suffix, &results.p_sum, &results.count);

    const years = r: {
        if(results.count == 0) {
            res.status = 404; return;
        }
        break :r results.count;
    };

    const ret: struct {
        ws_avg: u32,
        t_avg: u32,
        p_avg: u32,

    } = .{
        .ws_avg = @intFromFloat(results.ws_sum / @as(f64, @floatFromInt(years))),
        .t_avg = @intFromFloat(results.t_sum / @as(f64, @floatFromInt(years))),
        .p_avg = @intFromFloat(results.p_sum / @as(f64, @floatFromInt(years))),

    };
    try res.json(.{
        .temperature = ret.t_avg,
	.windSpeed = ret.ws_avg,
	.precipitationPercentage = ret.p_avg,
    }, .{});
}
