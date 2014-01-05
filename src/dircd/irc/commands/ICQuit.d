module dircd.irc.commands.ICQuit;

import dircd.irc.Channel;
import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.User;

import std.string: strip;

public class ICQuit : ICommand {

    public string getName() {
        return "QUIT";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto message = line["trail"];
        if (message.strip() == "") message = u.getNick();
        foreach (Channel c; u.getChannels()) {
            c.quitUser(u, message);
        }
        u.getIRC().removeUser(u);
    }

}
