module dircd.irc.commands.IC;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.User;

public class IC : ICommand {

    public string getName() {
        return "";
    }

    public void run(User u, Captures!(string, ulong) line) {

    }

}
