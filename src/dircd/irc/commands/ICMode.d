module dircd.irc.commands.ICMode;

import dircd.irc.Channel;
import dircd.irc.commands.ICommand;
import dircd.irc.LineType;
import dircd.irc.modes.ChanMode;
import dircd.irc.modes.Mode;
import dircd.irc.modes.UserMode;
import dircd.irc.User;

import std.algorithm: startsWith;
import std.array: join;

public class ICMode : ICommand {

    public string getName() {
        return "MODE";
    }

    public void run(User u, Captures!(string, ulong) line) {
        auto params = line["params"].split(" ");
        auto target = params[0];
        bool query = params.length < 2 || params[1].strip() == "";
        if (target.strip() == "") return; // needs more params?
        if (u.getIRC().startsWithChannelPrefix(target)) {
            auto channel = u.getIRC().getChannel(target);
            if (channel is null) {
                u.sendLine(u.getIRC().generateLine(u, LineType.ErrBadChanMask, target ~ " :Bad channel mask"));
                return;
            }
            if (query) { // querying for all modes
                /*string toSend = "+";
                foreach (ChanMode cm; channel.getModes()) toSend ~= cm;
                u.sendLine(":" ~ u.getIRC().getHost() ~ " MODE " ~ channel.getName() ~ " " ~ toSend);*/
                channel.sendModes(u);
                return;
            }
            auto modes = params[1..$];
            if (modes[0].startsWith("+") || modes[0].startsWith("-")) { // setting or removing
                // TODO: Don't manually specify which modes take params
                auto parsedMode = Mode.parseModeString!ChanMode(modes[0], modes.length > 1 ? modes[1..$] : [], ["ovklbeI", "ovklbeI"]);
                if (parsedMode == null) return; // TODO: Throw exception instead
                string toSend = "";
                string toSendParams = "";
                // TODO: Merge these loops into one
                if (Mode.Operation.Add in parsedMode) {
                    toSend ~= "+";
                    foreach (Mode m; parsedMode[Mode.Operation.Add]) {
                        try {
                            validate(channel, m);
                        } catch (ModeException e) {
                            u.sendLine(u.getIRC().generateLine(u, e.getLineType(), e.getMessage()));
                            continue;
                        }
                        toSend ~= m.getMode();
                        if (m.takesParameter()) toSendParams ~= m.getParam() ~ " ";
                        channel.addMode(m);
                    }
                }
                if (Mode.Operation.Remove in parsedMode) {
                    toSend ~= "-";
                    foreach (Mode m; parsedMode[Mode.Operation.Remove]) {
                        toSend ~= m.getMode();
                        if (m.takesParameter()) toSendParams ~= m.getParam() ~ " ";
                        channel.removeMode(m);
                    }
                }
                toSend ~= " " ~ toSendParams;
                toSend = toSend.strip();
                if (toSend[1..$] == "") return;
                channel.sendLineAll(":%s MODE %s %s".format(u.getHostmask(), channel.getName(), toSend));
                return;
            } else { // querying for some modes
                /*foreach (string c; params[1..$])
                ChanMode cm = cast(ChanMode) to!string(c);*/
                return; // not supported
            }
            return;
        }
        auto user = u.getIRC().getUser(target);
        if (user is null) return; // error?
        if (query) {
            string toSend = "+";
            foreach (UserMode um; user.getModes()) toSend ~= um;
            u.sendLine(":" ~ u.getIRC().getHost() ~ " MODE " ~ user.getNick() ~ " " ~ toSend);
        }
    }

    public void validate(Channel c, Mode m) {
        auto mode = m.getMode();
        if (mode == ChanMode.ChannelOperator && !c.hasUser(m.getParam())) throw new ModeException(LineType.ErrNoSuchNick, "User not in channel");
    }

    public class ModeException : Exception {
        private LineType lt;
        private string message;

        public this(LineType lt, string message) {
            super(message);
            this.lt = lt, this.message = message;
        }

        public LineType getLineType() {
            return this.lt;
        }

        public string getMessage() {
            return this.message;
        }
    }

}
