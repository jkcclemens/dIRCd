module dircd.irc.commands.ICTopic;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.modes.ChanMode;
import dircd.irc.User;

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
            u.sendLine(u.getIRC().generateLine(u, LineType.ErrBadChanMask, chan ~ " :Bad channel mask"));
            return;
        }
        if (channel.hasMode(ChanMode.TopicOpOnly) && !channel.userHasMode(u, ChanMode.ChannelOperator)) return; // error message
        channel.setTopic(u, topic);
    }

}
