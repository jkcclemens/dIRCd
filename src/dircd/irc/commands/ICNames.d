module dircd.irc.commands.ICNames;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.modes.ChanMode;
import dircd.irc.modes.Mode;
import dircd.irc.User;

public class ICNames : ICommand {

    public string getName() {
        return "NAMES";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto chan = line["params"];
        if (chan.strip() == "") return; // not implemented
        auto channel = u.getIRC().getChannel(chan);
        if (channel is null) {
            u.sendLine(u.getIRC().generateLine(u, LineType.ErrBadChanMask, chan ~ " :Bad channel mask"));
            return;
        }
        string toSend = "= " ~ channel.getName() ~ " :";
        bool anonymous = channel.hasMode(ChanMode.Anonymous);
        foreach (User user; channel.getUsers()) {
            auto nick = (anonymous && user.getNick() != u.getNick()) ? "anonymous" : user.getNick();
            toSend ~=  channel.getModeString(user) ~ nick ~ " ";
        }
        u.sendLine(u.getIRC().generateLine(u, LineType.RplNamReply, toSend.strip()));
        u.sendLine(u.getIRC().generateLine(u, LineType.RplEndOfNames, "%s :End of /NAMES list".format(channel.getName())));
    }

}
