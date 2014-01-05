module org.royaldev.dircd.irc.commands.ICJoin;

import org.royaldev.dircd.irc.User;
import org.royaldev.dircd.irc.Channel;
import org.royaldev.dircd.irc.LineType;
import org.royaldev.dircd.irc.commands.ICommand;

public class ICJoin : ICommand {

    public string getName() {
        return "JOIN";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto chansString = line["params"];
        if (chansString.strip() == "") return;
        auto chans = chansString.split(",");
        foreach (string chan; chans) {
            if (chan == "0") {
                foreach (Channel c; u.getChannels()) c.partUser(u, "");
                continue;
            }
            auto channel = u.getIRC().getChannel(chan);
            if (channel is null) {
                u.sendLine(u.getIRC().generateLine(LineType.ErrBadChanMask, chan ~ " :Bad channel mask"));
                return;
            }
            channel.addUser(u);
            u.addChannel(channel);
            auto names = u.getIRC().getCommandHandler().getCommand("NAMES");
            if (names !is null) names.run(u, u.getIRC().parseLine("NAMES " ~ channel.getName()));
            auto who = u.getIRC().getCommandHandler().getCommand("WHO");
            if (who !is null) who.run(u, u.getIRC().parseLine("WHO " ~ channel.getName));
        }
    }

}
