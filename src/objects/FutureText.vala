// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class FutureText {

    public delegate void FTUpdateFunc(string data);
    unowned FTUpdateFunc updateFunc;
    string textData;
    string arg1;
    FutureType dataType;

    void run() {
        new Thread<void*>("downloadText", download);
    }

    public FutureText(string arg1, FTUpdateFunc updateFunc) {
        this.updateFunc = updateFunc;
        this.arg1 = arg1;
        dataType = FutureType.text;
        run();
    }

    void* download() {
        textData = UtilityDownload.getTextProduct(arg1);
        GLib.Idle.add(() => { updateFunc(textData); return false; });
        return null;
    }
}