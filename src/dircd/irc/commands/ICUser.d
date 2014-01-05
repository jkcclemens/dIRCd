module dircd.irc.commands.ICUser;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.User;

import std.string: strip;

public class ICUser : ICommand {

    public string getName() {
        return "USER";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto realname = line["trail"];
        auto parts = line["params"].split(" ");
        auto givenUser = parts[0];
        auto hostname = (parts.length > 1) ? parts[1] : null;
        if (hostname is null) return; // bad syntax; send message
        if (realname.strip() == "") realname = (u.getNick() is null || u.getNick().strip() == "") ? givenUser : u.getNick();
        if (realname.strip() == "") return; // bad name; send message
        u.setRealName(realname);
        //u.setHostname(hostname);
        u.setUser(givenUser);
    }

}
