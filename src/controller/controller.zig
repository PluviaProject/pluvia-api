const std: type = @import("root").std;
const httpz: type = @import("root").httpz;
const curl: type = @import("root").curl;
const controller: type = @import("root").controller;

const allocator = @import("root").allocator;

fn getJsonNASAHistory(
    start: []const u8,
    end: []const u8,
    lat: f64,
    lon: f64
) anyerror![]const u8 {
    const ca_bundle = try curl.allocCABundle(allocator);
    const easy = try curl.Easy.init(.{
        .ca_bundle = ca_bundle,
    });
    var buffer: []u8 = try allocator.alloc(u8, comptime 1024 * 1024 * 2);
    const falseSize: usize = buffer.len;
    for(0..buffer.len) |i| {
        buffer[i] = 0;
    }
    const url: []const u8 = try @call(.never_inline, std.fmt.allocPrint, .{
        allocator,
        "https://power.larc.nasa.gov/api/temporal/daily/point?parameters=T2M,WS10M,PRECTOT&community=AG&longitude={any}&latitude={any}&start={s}&end={s}&format=JSON",
        .{
            lon, lat, start, end
        }
    });
    var writer = std.Io.Writer.fixed(buffer);
    const resp = try easy.fetch(@ptrCast(url), .{
        .writer = &writer,
    });
    defer {
        buffer.len = falseSize;
        allocator.free(buffer);
        ca_bundle.deinit();
        easy.deinit();
    }
    const someJson: []u8 = try allocator.alloc(u8, writer.end);
    buffer.len = writer.end;
    @memcpy(someJson, buffer);
    return if(resp.status_code != 200) error.InternalError else someJson;
}

fn getJsonAI(
    req: controller.types.RequestParser_T,
    hist: controller.types.TemporalInfo_T,
) anyerror![]const u8 {
    const url: []const u8 = "https://pluvia-ai-service.igor-faoro17.workers.dev/weather/insights";
    const ca_bundle = try curl.allocCABundle(allocator);
    const easy = try curl.Easy.init(.{
        .ca_bundle = ca_bundle,
    });
    var buffer: []u8 = try allocator.alloc(u8, comptime 1024 * 32);
    const falseSize: usize = buffer.len;
    var writer = std.Io.Writer.fixed(buffer);
    const body = try std.fmt.allocPrint(allocator,
        \\{{
        \\    "date": "{s}",
        \\    "place": {{
        \\        "coordinates": [
        \\            {any},
        \\            {any}
        \\        ],
        \\        "address": "{s}"
        \\    }},
        \\    "description": "{s}",
        \\    "temporalAverage": {{
        \\        "temperature": {d},
        \\        "windSpeed": {d},
        \\        "precipitationPercentage": {d}
        \\    }}
        \\}}
    , .{
        req.date,
        req.place.coordinates[
            @intFromEnum(controller.types.Coord_T.lat)
        ],
        req.place.coordinates[
            @intFromEnum(controller.types.Coord_T.lon)
        ],
        req.place.address,
        req.description,
        hist.temperature,
        hist.windSpeed,
        hist.precipitationPercentage,
    });
    _ = try easy.fetch(@ptrCast(url), .{
        .writer = &writer,
        .body = body,
        .method = .POST,
    });
    defer {
        buffer.len = falseSize;
        allocator.free(buffer);
        ca_bundle.deinit();
        easy.deinit();
    }
    const someJson: []u8 = try allocator.alloc(u8, writer.end);
    buffer.len = writer.end;
    @memcpy(someJson, buffer);
    return someJson;
}

pub fn NASAPrediction(req: *httpz.Request, res: *httpz.Response) anyerror!void {
    errdefer {
        res.status = 500;
    }

    const requestParsed: controller.types.RequestParser_T = try @call(.always_inline, controller.utils.parseRequestData, .{
        req.body() orelse try @call(.always_inline, controller.utils.internalError, .{}),
        controller.types.RequestParser_T
    });

    const start: []const u8, const end: []const u8 = try @call(.always_inline, controller.utils.requestDateResolve, .{
        requestParsed.date
    });

    const NASAJson = try @call(.always_inline, getJsonNASAHistory, .{
        start,
        end,
        requestParsed.place.coordinates[
            @intFromEnum(controller.types.Coord_T.lat)
        ],
        requestParsed.place.coordinates[
            @intFromEnum(controller.types.Coord_T.lon)
        ]
    });

    const parsed = try std.json.parseFromSlice(std.json.Value, allocator, NASAJson, .{});
    const root = parsed.value;
    const param_map = root.object
        .get("properties").?
        .object.get("parameter").?
        .object;

    var results = struct {
        ws_sum: f64 = 0,
        t_sum: f64 = 0,
        p_sum: f64 = 0,
        count: usize = 0,
    }{};

    const dateSuffix: []const u8 = start[4..start.len];

    controller.utils.accumulate(&param_map.get("WS10M").?, dateSuffix, &results.ws_sum, &results.count);
    controller.utils.accumulate(&param_map.get("T2M").?, dateSuffix, &results.t_sum, &results.count);
    controller.utils.accumulate(&param_map.get("PRECTOTCORR").?, dateSuffix, &results.p_sum, &results.count);

    const ret: controller.types.TemporalInfo_T = .{
        .windSpeed = @intFromFloat(results.ws_sum / @as(f64, @floatFromInt(results.count / 3))),
        .temperature = @intFromFloat(results.t_sum / @as(f64, @floatFromInt(results.count / 3))),
        .precipitationPercentage = @intFromFloat(results.p_sum / @as(f64, @floatFromInt(results.count / 3)))
    };

    const IAJson = try @call(.always_inline, getJsonAI, .{
        requestParsed, ret
    });

    const IARespParsed: controller.types.AIResp_T = try @call(.always_inline, controller.utils.parseRequestData, .{
        IAJson,
        controller.types.AIResp_T
    });

    try res.json(.{
        .temperature = ret.temperature,
        .windSpeed = ret.windSpeed,
        .precipitationPercentage = ret.precipitationPercentage,
        .description = IARespParsed.description,
        .insights = IARespParsed.insights,
    }, .{});
}
