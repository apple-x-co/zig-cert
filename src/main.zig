const std = @import("std");
const tcp = std.x.net.tcp;

const openssl = @cImport({
    @cInclude("openssl/ssl.h");
    @cInclude("openssl/err.h");
});

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});

    // const client = try tcp.Client.init(.ip, .{ .close_on_exec = true });
    // defer client.deinit();

    // client.connect(std.x.net.ip.Address.from(.{"googl.com"}));

    // std.x.net.tcp.Domain.ip

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // https://github.com/search?l=zig&q=std.net.tcpConnectToHost&type=Code
    // https://github.com/genkiroid/cert/blob/master/cert.go
    const tcp_conn = try std.net.tcpConnectToHost(allocator, "google.com", 443);
    defer tcp_conn.close();

    //////
    // var buf: []u8 = undefined;
    // var size = try tcp_conn.read(buf);

    // std.log.debug("{s}", .{tcp_conn});
    // std.log.debug("{s}", .{buf});
    // std.log.debug("{d}", .{size});

    //////
    // https://ken-ohwada.hatenadiary.org/entry/2021/02/27/113436
    // https://github.com/haze/zig-libressl/tree/main
    // https://qiita.com/edo_m18/items/41770cba5c166f276a83
    //
    // https://github.com/search?l=zig&q=OPENSSL_init_ssl&type=Code
    // https://github.com/marler8997/ziget/blob/5b6f0667c906e1c76b71317a599d9a3831d50661/openssl/ssl.zig
    // https://github.com/fubark/cosmic/blob/0bfed2520d1f67203014a9c3330801c745f34cca/lib/openssl/openssl.zig

    std.debug.print("[DEBUG] openssl init\n", .{});
    //std.log.debug("{}", .{openssl});

    if (openssl.OPENSSL_init_ssl(0, null) != 1) {
        return error.InitializationError;
    }

    // FIXME: 以下のエラーをどうにかする
    // error(link): undefined reference to symbol '_OPENSSL_init_ssl'
    // error(link):   first referenced in '/path/to/zig-cert/zig-cache/o/b31ad817d877ac41188e138e31aeb0b9/zig-cert.o'
    // error: UndefinedSymbolReference
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
