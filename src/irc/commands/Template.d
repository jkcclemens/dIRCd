module org.royaldev.dircd.irc.commands.IC;

import org.royaldev.dircd.irc.User;
import org.royaldev.dircd.irc.LineType;
import org.royaldev.dircd.irc.commands.ICommand;

public class IC : ICommand {

    public string getName() {
        return "";
    }

    public void run(User u, Captures!(string, ulong) line) {

    }

}
