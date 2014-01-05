module org.royaldev.dircd.irc.commands.ICPong;

import std.datetime: Clock;
import std.string: strip;

import org.royaldev.dircd.irc.User;
import org.royaldev.dircd.irc.LineType;
import org.royaldev.dircd.irc.commands.ICommand;

public class ICPong : ICommand {

    public string getName() {
        return "PONG";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto params = line["params"];
        if (params.strip() == "" || params != u.getIRC().getHost()) return;
        u.setLastPong(Clock.currTime().toUnixTime());
    }

}
