module dircd.irc.commands.ICCap;

import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.User;
import dircd.irc.cap.Capability;

public class ICCap : ICommand {

    public string getName() {
        return "CAP";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto params = line["params"].strip();
        if (params == "") return; // bad command
        auto param = params.split(" ")[0];
        switch (param) {
            case "LS":
                handleLS(u);
                break;
            case "ACK":
                handleACK(u, params);
                break;
            default:
                return; // no support
        }
    }

    private void handleLS(User u) {
        u.sendLine(":%s CAP * LS :~multi-prefix".format(u.getIRC().getHost()));
    }

    private void handleACK(User u, string params) {
        if (params.split(" ").length < 2) return; // invalid
        auto cap = params.split(" ")[1];
        auto caps = u.getCapabilities();
        caps ~= to!Capability(cap);
        u.setCapabilities(caps);
    }

}
