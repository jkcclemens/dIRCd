module dircd.irc.commands.ICommand;

import std.regex: Captures;
import dircd.irc.User;

public interface ICommand {
    public string getName();
    public void run(User runner, Captures!(string, ulong) line);
}
