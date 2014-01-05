module org.royaldev.dircd.irc.User;

import std.socket: Socket;
import std.algorithm: remove;
import std.regex: regex, rreplace = replace, match;
import std.string: split, toUpper, strip, format;
import std.conv: to;
import org.royaldev.dircd.irc.LineType;
import org.royaldev.dircd.irc.IRC;
import org.royaldev.dircd.irc.Channel;
import core.time: dur;
import std.stdio: writeln;
import std.datetime: Clock;

public class User {

    private Socket s;
    private IRC irc;

    private Channel[] channels;

    private string nick;
    private string realName;
    private string user;
    private string hostname;

    private const long connTime;
    private long lastPing = 0L;
    private long lastPong = 0L;

    private bool connected;
    public bool correctPass;

    public this(Socket connection, IRC server) {
        this.s = connection;
        this.irc = server;
        this.connTime = Clock.currTime().toUnixTime();
        this.connected = true;
        this.correctPass = false;
    }

    public bool isConnected() {
        return this.connected;
    }

    public long getLastPing() {
        return this.lastPing;
    }

    public void setLastPing(long st) {
        this.lastPing = st;
    }

    public long getLastPong() {
        return this.lastPong;
    }

    public void setLastPong(long st) {
        this.lastPong = st;
    }

    public long getConnectionTime() {
        return this.connTime;
    }

    public IRC getIRC() {
        return irc;
    }

    public string getNick() {
        return this.nick;
    }

    public void setNick(string newNick) {
        this.nick = newNick;
    }

    public string getRealName() {
        return this.realName;
    }

    public void setRealName(string realName) {
        this.realName = realName;
    }

    public string getHostmask() {
        return getNick() ~ "!" ~ getUser() ~ "@" ~ this.irc.getHost();
    }

    public string getUser() {
        return this.user;
    }

    public string getHostname() {
        return this.hostname;
    }

    public void setHostname(string hostname) {
        this.hostname = hostname;
    }

    public void setUser(string user) {
        this.user = user;
    }

    public Channel[] getChannels() {
        return this.channels;
    }

    public void addChannel(Channel c) {
        this.channels ~= c;
    }

    public void removeChannel(Channel c) {
        int index = -1;
        for (int i = 0; i < channels.length; i++) {
            if (channels[i].getName() != c.getName()) continue;
            index = i;
            break;
        }
        if (index == -1) return;
        this.channels = channels.remove(index);
    }

    /**
     * Blockingly reads a line. This will block until it receives "\n"
     */
    public string readLine() {
        string line = "";
        with (s) {
            while (isAlive()) {
                char[1] buff;
                auto amt = receive(buff);
                if (!amt) {
                    this.disconnect("Connection reset by peer");
                    break;

                }
                line ~= to!string(buff[0..amt]);
                if (line.length > 1 && line[$-1..$] == "\n") return line; // support bad clients
            }
        }
        return line;
    }

    public void sendLine(string line) {
        with (s) {
            if (!isAlive()) return;
            writeln("SENT ", this.getHostmask(), ": ", line);
            send(line ~ "\r\n");
        }
    }

    public void disconnect(string reason) {
        if (!connected) return;
        foreach (Channel c; this.getChannels()) {
            c.quitUser(this, reason);
        }
        this.getIRC().removeUser(this);
        this.s.close();
        this.connected = false;
    }

    /**
    * This will block until the socket closes. Should be run in a thread.
    */
    public void handle() {
        auto pt = new PingThread(this);
        pt.start();
        auto hostname = s.remoteAddress().toHostNameString();
        if (hostname is null) hostname = s.remoteAddress().toAddrString();
        setHostname(hostname);
        while (s.isAlive()) {
            auto lineText = readLine().rreplace(regex(r"\r?\n"), "");
            if (lineText.strip() == "") continue;
            writeln("RECV ", this.getHostmask(), ": ", lineText);
            Captures!(string, ulong) line;
            try {
                line = this.irc.parseLine(lineText);
            } catch (Exception e) {
                writeln(e);
                continue;
            }
            auto command = line["command"].toUpper();
            if (this.irc.getPass() !is null && !this.correctPass) {
                if (command != "PASS" && command != "PONG") continue;
            }
            auto ic = this.irc.getCommandHandler().getCommand(command);
            if (ic is null) {
                sendLine(this.irc.generateLine(LineType.ErrUnknownCommand, this.getNick() ~ " " ~ command ~ " :Unknown command"));
                continue;
            }
            ic.run(this, line);
        }
        this.disconnect("Connection closed");
        writeln("Connection closed: ", this.getHostmask());
    }

    private class PingThread : Thread {

        private User u;

        public this(User u) {
            this.u = u;
            super(&run);
        }

        private : void run() {
            while (true) {
                if (!u.isConnected()) break;
                this.sleep(dur!"seconds"(5));
                long currTime = Clock.currTime().toUnixTime();
                if (u.getLastPong() != 0L && currTime - u.getLastPong() > 120) {
                    u.disconnect("Ping timeout: %d seconds".format(currTime - u.getLastPong()));
                    break;
                }
                if (currTime - u.getLastPing() < 120) continue;
                u.sendLine("PING " ~ u.getIRC().getHost());
                u.setLastPing(currTime);
                if (u.getLastPong() == 0L) u.setLastPong(currTime);
            }
        }
    }

}