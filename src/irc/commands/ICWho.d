module org.royaldev.dircd.irc.commands.ICWho;

import std.string: strip;
import org.royaldev.dircd.irc.commands.ICommand;
import org.royaldev.dircd.irc.User;
import org.royaldev.dircd.irc.LineType;

public class ICWho : ICommand {

    public string getName() {
        return "WHO";
    }

    public void run(User runner, Captures!(string, ulong) line) {
        auto chan = line["params"];
        if (chan.strip() == "") return;
        auto channel = runner.getIRC().getChannel(chan);
        if (channel is null) return; // we don't support this yet
        foreach (User u; channel.getUsers()) {
            auto toSend = "%s %s %s %s %s %s H :%s %s".format(
                runner.getNick(),
                channel.getName(),
                u.getUser(),
                u.getHostname(),
                u.getIRC().getHost(),
                u.getNick(),
                0,
                u.getRealName()
            );
            runner.sendLine(runner.getIRC().generateLine(LineType.RplWhoReply, toSend));
        }
        runner.sendLine(runner.getIRC().generateLine(LineType.RplEndOfWho, channel.getName() ~ " :End of /WHO list"));
    }
}
