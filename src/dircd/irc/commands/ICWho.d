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
        foreach (User user; channel.getUsers()) {
            string mode = channel.getModeString(user);
            auto toSend = "%s %s %s %s %s H *%s :%s %s".format(
                channel.getName(),
                user.getUser(),
                user.getHostname(),
                user.getIRC().getHost(),
                user.getNick(),
                mode != "" ? " " ~ mode : "",
                0,
                user.getRealName()
            );
            u.sendLine(u.getIRC().generateLine(u, LineType.RplWhoReply, toSend));
        }
        u.sendLine(u.getIRC().generateLine(u, LineType.RplEndOfWho, "%s :End of /WHO list".format(channel.getName())));
    }
}
