module dircd.irc.commands.ICNames;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
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
            u.sendLine(u.getIRC().generateLine(LineType.ErrBadChanMask, chan ~ " :Bad channel mask"));
            return;
        }
        string toSend = u.getNick() ~ " = " ~ channel.getName() ~ " :";
        foreach (User user; channel.getUsers()) toSend ~= user.getNick() ~ " ";
        u.sendLine(u.getIRC().generateLine(LineType.RplNamReply, toSend.strip()));
        u.sendLine(u.getIRC().generateLine(LineType.RplEndOfNames, user.getNick() ~ " " ~ channel.getName() ~ " :End of /NAMES list"));
    }

}
