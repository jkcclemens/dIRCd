module dircd.irc.Channel;

import dircd.irc.IRC;
import dircd.irc.modes.Mode;
import dircd.irc.modes.ChanMode;
import dircd.irc.User;

import std.algorithm: countUntil, remove;

public class Channel {

    private IRC irc;

    private string name; // name of chan
    private User[] users; // users in chan
    private string topic; // topic
    private User topicUser; // person who set topic

    private Mode[] modes = [new Mode(ChanMode.NoOutsideMessages), new Mode(ChanMode.TopicOpOnly)];

    public this(IRC irc, string name) {
        this.irc = irc;
        this.name = name;
    }

    public Mode[] getModes() {
        return this.modes;
    }

    public void setModes(Mode[] modes) {
        this.modes = modes;
    }

    public Mode[] getModesForParam(string param) {
        Mode[] ms;
        foreach (Mode m; this.modes) {
            if (m.getParam() != param) continue;
            ms ~= m;
        }
        return ms;
    }

    public void sendModes() {
        foreach (User u; this.getUsers()) sendModes(u);
    }

    public void sendModes(User u) {
        string toSend = "+";
        foreach (Mode m; this.getModes()) {
            if (m.getMode() == ChanMode.ChannelOperator) continue;
            toSend ~= m.getMode();
        }
        u.sendHostLine("MODE %s %s".format(this.getName(), toSend));
    }

    public string getModeString(User u) {
        if (!this.hasUser(u)) return null; // no user
        string mode = "";
        /*foreach (Mode m; this.getModesForParam(u.getNick())) {
            if (m.getMode() == ChanMode.Voice && mode == "") mode = "+";
            if (m.getMode() == ChanMode.ChannelOperator) mode = "@";
        }*/
        if (this.userHasMode(u, ChanMode.ChannelOperator)) mode = "@";
        if (this.userHasMode(u, ChanMode.Voice) && mode == "") mode = "+";
        return mode;
    }

    public bool hasMode(ChanMode cm) {
        foreach (Mode m; this.modes) if (m.getMode() == cm) return true;
        return false;
    }

    public bool userHasMode(User u, ChanMode cm) {
        foreach (Mode m; this.modes) if (m.getMode() == cm && m.getParam() == u.getNick()) return true;
        return false;
    }

    public bool hasUser(User u) {
        foreach (User user; this.users) {
            if (u.getNick() != user.getNick()) continue;
            return true;
        }
        return false;
    }

    public string getName() {
        return this.name;
    }

    public User[] getUsers() {
        return this.users;
    }

    public string getTopic() {
        return this.topic;
    }

    public User getTopicUser() {
        return this.topicUser;
    }

    public void setTopic(User setting, string topic) {
        this.topic = topic;
        this.topicUser = setting;
        sendLineAll(":" ~ setting.getHostmask() ~ " TOPIC " ~ this.getName() ~ " :" ~ topic);
    }

    public void sendMessage(User who, string message) {
        sendLineAllExcept(who, ":" ~ who.getHostmask() ~ " PRIVMSG " ~ this.getName() ~ " :" ~ message);
    }

    public void sendLineAll(string line) {
        foreach (User u; users) u.sendLine(line);
    }

    public void sendHostLineAll(string line) {
        foreach (User u; users) u.sendHostLine(line);
    }

    public void sendLineAllExcept(User except, string line) {
        foreach (User u; users) {
            if (u.getNick() == except.getNick()) continue;
            u.sendLine(line);
        }
    }

    public void addUser(User u) {
        bool isOp = this.users.length < 1; // first user gets op
        this.users ~= u;
        sendLineAll(":" ~ u.getHostmask() ~ " JOIN " ~ getName());
        if (isOp) {
            auto modes = this.getModes();
            modes ~= new Mode(ChanMode.ChannelOperator, true, u.getNick());
            this.setModes(modes);
        }
    }

    public void partUser(User u, string message) {
        sendLineAll(":" ~ u.getHostmask() ~ " PART " ~ getName() ~ " :" ~ message);
        removeUser(u);
    }

    public void quitUser(User u, string message) {
        sendLineAll(":" ~ u.getHostmask() ~ " QUIT :" ~ message);
        removeUser(u);
    }

    public void removeUser(User u) {
        int index = -1;
        for (int i = 0; i < users.length; i++) {
            if (users[i].getNick() != u.getNick()) continue;
            index = i;
            break;
        }
        if (index == -1) return;
        users = users.remove(index);
        if (users.length < 1) this.irc.removeChannel(this);
        foreach (Mode m; this.getModesForParam(u.getNick())) {
            this.modes = this.modes.remove(this.modes.countUntil(m));
        }
    }

}
