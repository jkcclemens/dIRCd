module org.royaldev.dircd.dIRCd;

import std.c.stdlib: exit;
import std.getopt: getopt, config;

import org.royaldev.dircd.irc.IRC;

string hostname;
string password;
short port = 6667;

private void main(string[] args) {
    bool displayHelp = false;
    getopt(
        args,
        config.caseSensitive,
        config.bundling,
        config.passThrough,
        "H|hostname", &hostname,
        "p|port", &port,
        "P|password|server-password", &password,
        "h|help", &displayHelp
    );
    if (displayHelp) {
        writeln("Usage: ", args[0], " -H hostname [-p port] [-P password] [-h]");
        writeln("-H | --hostname\n\tRequired\n\tSets the hostname to bind to.");
        writeln("-p | --port\n\tSets the port to bind to.\n\tDefaults to 6667.");
        writeln("-P | --password | --server-password\n\tSets the password for the server.");
        writeln("-h | --help\n\tDisplays this help.");
        exit(0);
    }
    if (hostname is null) {
        writeln("Missing required arguments. Try " ~ args[0] ~ " -h for help.");
        exit(1);
    }
    new dIRCd();
}

public class dIRCd {
    public this() {
        auto irc = new IRC(hostname, port, password);
        irc.startServer();
    }
}
