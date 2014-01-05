module dircd.irc.commands.ICMode;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.modes.ChanMode;
import dircd.irc.modes.UserMode;
import dircd.irc.User;

public class ICMode : ICommand {

    public string getName() {
        return "MODE";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto params = line["params"].split(" ");
        auto target = params[0];
        bool query = params.length < 2 || params[1].strip() == "";
        if (target.strip() == "") return; // needs more params?
        if (u.getIRC().startsWithChannelPrefix(target)) {
            auto channel = u.getIRC().getChannel(target);
            if (channel is null) {
                u.sendLine(u.getIRC().generateLine(u, LineType.ErrBadChanMask, target ~ " :Bad channel mask"));
                return;
            }
            if (query) {
                /*string toSend = "+";
                foreach (ChanMode cm; channel.getModes()) toSend ~= cm;
                u.sendLine(":" ~ u.getIRC().getHost() ~ " MODE " ~ channel.getName() ~ " " ~ toSend);*/
                channel.sendModes(u);
            }
            return;
        }
        auto user = u.getIRC().getUser(target);
        if (user is null) return; // error?
        if (query) {
            string toSend = "+";
            foreach (UserMode um; user.getModes()) toSend ~= um;
            u.sendLine(":" ~ u.getIRC().getHost() ~ " MODE " ~ user.getNick() ~ " " ~ toSend);
        }
    }

}
