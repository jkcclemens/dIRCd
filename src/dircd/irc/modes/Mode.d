module dircd.irc.modes.Mode;

import dircd.irc.modes.ChanMode;
import dircd.irc.modes.UserMode;

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

}
