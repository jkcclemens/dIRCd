module dircd.irc.commands.ICPrivmsg;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.User;

public class ICPrivmsg : ICommand {

    public string getName() {
        return "PRIVMSG";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto target = line["params"], message = line["trail"];
        if (target.strip() == "" || message.strip() == "") {
            u.sendLine(u.getIRC().generateLine(LineType.ErrNeedMoreParams, "PRIVMSG :Need more parameters"));
            return;
        }
        if (u.getIRC().startsWithChannelPrefix(target)) {
            auto chan = u.getIRC().getChannel(target);
            if (chan is null) {
                u.sendLine(u.getIRC().generateLine(LineType.ErrBadChanMask, target ~ " :Bad channel mask"));
                return;
            }
            chan.sendMessage(u, message);
            return;
        }
        auto user = u.getIRC().getUser(target);
        if (user is null) return; // nothing left to do
        user.sendMessage(u, message);
    }

}
