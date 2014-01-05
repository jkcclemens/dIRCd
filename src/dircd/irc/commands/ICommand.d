module dircd.irc.commands.ICommand;

import dircd.irc.User;

import std.regex: Captures;

public interface ICommand {
    public string getName();
    public void run(User runner, Captures!(string, ulong) line);
}
