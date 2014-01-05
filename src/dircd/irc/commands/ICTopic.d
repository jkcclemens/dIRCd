module dircd.irc.commands.ICTopic;

import dircd.irc.User;
import dircd.irc.LineType;
import dircd.irc.commands.ICommand;

public class ICTopic : ICommand {

    public string getName() {
        return "TOPIC";
    }

    public void run(User u, Captures!(string, ulong) line) {

    }

}
