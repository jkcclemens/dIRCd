module dircd.irc.commands.IC;

import dircd.irc.User;
import dircd.irc.LineType;
import dircd.irc.commands.ICommand;

public class IC : ICommand {

    public string getName() {
        return "";
    }

    public void run(User u, Captures!(string, ulong) line) {

    }

}
