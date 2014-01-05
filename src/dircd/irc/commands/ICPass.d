module dircd.irc.commands.ICPass;

import dircd.irc.User;
import dircd.irc.LineType;
import dircd.irc.commands.ICommand;

public class ICPass : ICommand {

    public string getName() {
        return "PASS";
    }

    public void run(User u, Captures!(string, ulong) line) {
        if (u.getIRC().getPass() is null) return;
        if (line["params"].strip() == "") {
            u.sendLine(u.getIRC().generateLine(LineType.ErrNeedMoreParams, "PASS :Need more parameters"));
            return;
        }
        if (u.getIRC().getPass() != line["params"]) {
            u.sendLine(u.getIRC().generateLine(LineType.ErrPasswdMismatch, ""));
            u.disconnect("Incorrect password.");
            return;
        }
        u.correctPass = true;
    }

}