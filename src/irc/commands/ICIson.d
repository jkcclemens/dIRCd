module org.royaldev.dircd.irc.commands.ICIson;

import org.royaldev.dircd.irc.User;
import org.royaldev.dircd.irc.LineType;
import org.royaldev.dircd.irc.commands.ICommand;

public class ICIson : ICommand {

    public string getName() {
        return "ISON";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto nickList = line["params"];
        if (nickList.strip() == "") {
            u.sendLine(u.getIRC().generateLine(LineType.ErrNeedMoreParams, "ISON :Not enough parameters"));
            return;
        }
        string reply = ":";
        foreach (string nick; nickList.split(",")) {
            nick = nick.strip(); // bad clients
            if (nick == "") continue; // invalid nick
            foreach (User user; u.getIRC().getUsers()) if (user.getNick() == nick) reply ~= user.getNick() ~ ",";
        }
        if (reply.split(",").length > 1) reply = reply[0..$-1]; // cut off last ","
        u.sendLine(u.getIRC().generateLine(LineType.RplIsOn, u.getNick() ~ " " ~ reply));
    }

}
