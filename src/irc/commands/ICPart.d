module org.royaldev.dircd.irc.commands.ICPart;

import org.royaldev.dircd.irc.User;
import org.royaldev.dircd.irc.LineType;
import org.royaldev.dircd.irc.commands.ICommand;

public class ICPart : ICommand {

    public string getName() {
        return "PART";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto chansString = line["params"];
        auto message = line["trail"];
        if (chansString.strip() == "") return; // needs more params!
        auto chans = chansString.split(",");
        foreach (string chan; chans) {
            auto channel = u.getIRC().getChannel(chan);
            if (channel is null) {
                u.sendLine(u.getIRC().generateLine(LineType.ErrBadChanMask, chan ~ " :Bad channel mask"));
                return;
            }
            channel.partUser(u, message);
        }
    }

}
