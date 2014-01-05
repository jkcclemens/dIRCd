module dircd.irc.commands.ICPong;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.User;

import std.datetime: Clock;
import std.string: strip;

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
