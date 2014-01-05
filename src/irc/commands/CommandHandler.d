module org.royaldev.dircd.irc.commands.CommandHandler;

import std.string: toLower;
import org.royaldev.dircd.irc.commands.ICommand;

public class CommandHandler {

    /**
    * Associative array of commands sorted by their names.
    */
    private ICommand[string] commands;

    public ICommand getCommand(string name) {
        name = name.toLower();
        return (name in commands) ? commands[name] : null;
    }

    public void addCommand(ICommand ic) {
        if (ic.getName().toLower() in commands) return;
        commands[ic.getName().toLower()] = ic;
    }

}
