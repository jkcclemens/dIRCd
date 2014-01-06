module dircd.irc.commands.ICWho;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.modes.ChanMode;
import dircd.irc.modes.Mode;
import dircd.irc.User;

import std.string: strip;

public class ICWho : ICommand {

    public string getName() {
        return "WHO";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto chan = line["params"];
        if (chan.strip() == "") return;
        auto channel = u.getIRC().getChannel(chan);
        if (channel is null) return; // we don't support this yet
        bool anonymous = channel.hasMode(ChanMode.Anonymous);
        foreach (User user; channel.getUsers()) {
            bool display = user.getNick() == u.getNick() || !anonymous;
            string mode = channel.getModeString(user);
            auto toSend = "%s %s %s %s %s H *%s :%s %s".format(
                channel.getName(),
                display ? user.getUser() : "anonymous",
                display ? user.getHostname() : "anonymous",
                user.getIRC().getHost(),
                display ? user.getNick() : "anonymous",
                mode != "" ? " " ~ mode : "",
                0,
                display ? user.getRealName() : "anonymous"
            );
            u.sendLine(u.getIRC().generateLine(u, LineType.RplWhoReply, toSend));
        }
        u.sendLine(u.getIRC().generateLine(u, LineType.RplEndOfWho, "%s :End of /WHO list".format(channel.getName())));
    }
}
