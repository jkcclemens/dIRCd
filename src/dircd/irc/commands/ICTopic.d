module dircd.irc.commands.ICTopic;

import dircd.irc.User;
import dircd.irc.LineType;
import dircd.irc.commands.ICommand;

public class ICTopic : ICommand {

    public string getName() {
        return "TOPIC";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto chan = line["params"].strip();
        auto topic = line["trail"];
        if (chan == "") return; // issues
        auto channel = u.getIRC().getChannel(chan);
        if (channel is null) {
            u.sendLine(u.getIRC().generateLine(LineType.ErrBadChanMask, chan ~ " :Bad channel mask"));
            return;
        }
        channel.setTopic(u, topic);
    }

}