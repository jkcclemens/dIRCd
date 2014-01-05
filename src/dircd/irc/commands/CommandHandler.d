module dircd.irc.commands.CommandHandler;

import dircd.irc.commands.ICommand;

import std.string: toLower;

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
