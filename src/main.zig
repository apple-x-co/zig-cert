const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const host = "example.com";
    const port = 443;
    const stream = try std.net.tcpConnectToHost(allocator, host, port);
    defer stream.close();

    var ca_bundle = std.crypto.Certificate.Bundle{};
    defer ca_bundle.deinit(allocator);
    try ca_bundle.rescan(allocator);

    var client = try std.crypto.tls.Client.init(stream, ca_bundle, host);
    _ = client;

    // FIXME: 証明書の情報を取得したい
    // const parsed = try std.crypto.Certificate.parse(.{ .buffer = ca_bundle.bytes.items, .index = 0 });
    // std.debug.print("{s}", .{parsed.subject()});
}
