module dircd.irc.modes.Mode;

import dircd.irc.modes.ChanMode;
import dircd.irc.modes.UserMode;

import std.algorithm: canFind, remove;
import std.conv: to;

public class Mode {

    private const bool isChanMode;
    private bool takesParam;
    private string param;

    private ChanMode cm;
    private UserMode um;

    this(ChanMode cm) {
        this.cm = cm;
        this.isChanMode = true;
        this.takesParam = false;
    }

    this(ChanMode cm, bool takesParam) {
        this.cm = cm;
        this.isChanMode = true;
        this.takesParam = takesParam;
    }

    this(ChanMode cm, bool takesParam, string param) {
        this.cm = cm;
        this.isChanMode = true;
        this.takesParam = takesParam;
        this.param = param;
    }

    this(UserMode um) {
        this.um = um;
        this.isChanMode = false;
        this.takesParam = false;
    }

    this(UserMode cm, bool takesParam) {
        this.um = um;
        this.isChanMode = false;
        this.takesParam = takesParam;
    }

    this(UserMode cm, bool takesParam, string param) {
        this.um = um;
        this.isChanMode = false;
        this.takesParam = takesParam;
        this.param = param;
    }

    public enum getMode() {
        return isChanMode ? this.cm : this.um;
    }

    public bool takesParameter() {
        return this.takesParam;
    }

    public string getParam() {
        return this.param;
    }

    public bool equals(Mode other) {
        return other.getParam() == this.param && other.takesParameter() == this.takesParam && other.getMode() == this.getMode();
    }

    public static Mode[][Operation] parseModeString(T)(string modes, string[] params, string[] paramModes) {
        if (modes.length < 1) return null;
        if (modes[0] != '+' && modes[0] != '-') return null;
        Mode[][Operation] changes;
        Operation o;
        int count = -1;
        foreach (char c; modes.dup) {
            if (c == '-' || c == '+') {
                if (count == 0) return null;
                o = c == '+' ? Operation.Add : Operation.Remove;
                count = 0;
            } else {
                string param;
                T mode = cast(T) to!string(c);
                if (paramModes[o].canFind(c)) {
                    param = params[0];
                    params = params.remove(0);
                }
                changes[o] ~= new Mode(mode, param !is null, param);
                count++;
            }
        }
        return changes;
    }

    public static enum Operation : int {
        Add     = 0,
        Remove  = 1
    }
}
