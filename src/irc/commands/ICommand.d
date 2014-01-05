module org.royaldev.dircd.irc.commands.ICommand;

import std.regex: Captures;
import org.royaldev.dircd.irc.User;

public interface ICommand {
    public string getName();
    public void run(User runner, Captures!(string, ulong) line);
}
