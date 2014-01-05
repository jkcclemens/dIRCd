module dircd.irc.commands.ICNick;

import std.regex: Regex, regex;

import dircd.irc.User;
import dircd.irc.LineType;
import dircd.irc.commands.ICommand;

public class ICNick : ICommand {

    private Regex!char nickRegex = regex(r"[^a-zA-Z0-9\-\[\]'`^{}_]");

    public string getName() {
        return "NICK";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto newNick = line["params"];
        if (newNick.match(nickRegex)) {
            u.sendLine(u.getIRC().generateLine(LineType.ErrErroneusNickname, newNick ~ " :Erroneous nickname"));
            return;
        }
        foreach (User user; u.getIRC().getUsers()) {
            if (user.getNick() == newNick) {
                u.sendLine(u.getIRC().generateLine(LineType.ErrNickNameInUse, newNick ~ " :This nick is already being used."));
                return;
            }
        }
        bool firstSet = u.getNick() is null;
        u.setNick(newNick);
        u.sendLine(":" ~ u.getHostmask() ~ " NICK :" ~ newNick);
        if (firstSet) {
            u.sendLine(u.getIRC().generateLine(LineType.RplWelcome, ""));
            u.sendLine(u.getIRC().generateLine(LineType.RplMotdStart, ""));
            u.sendLine(u.getIRC().generateLine(LineType.RplMotdEnd, ""));
        }
    }

}
