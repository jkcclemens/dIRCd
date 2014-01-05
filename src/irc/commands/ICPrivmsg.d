module org.royaldev.dircd.irc.commands.ICPrivmsg;

import org.royaldev.dircd.irc.User;
import org.royaldev.dircd.irc.LineType;
import org.royaldev.dircd.irc.commands.ICommand;

public class ICPrivmsg : ICommand {

    public string getName() {
        return "PRIVMSG";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto channel = line["params"], message = line["trail"];
        if (channel.strip() == "" || message.strip() == "") {
            u.sendLine(u.getIRC().generateLine(LineType.ErrNeedMoreParams, "PRIVMSG :Need more parameters"));
            return;
        }
        auto chan = u.getIRC().getChannel(channel);
        if (chan is null) {
            u.sendLine(u.getIRC().generateLine(LineType.ErrBadChanMask, channel ~ " :Bad channel mask"));
            return;
        }
        chan.sendMessage(u, message);
    }

}
