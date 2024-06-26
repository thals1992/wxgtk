// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class TabWidget : Widget {

    public delegate void ConnectFn(Gtk.Widget w, uint i);
    unowned ConnectFn fn;
    Gtk.Notebook tw = new Gtk.Notebook();

    public void addTab(Box widget, string s) {
        var text = new Text(false);
        text.setText(s);
        tw.append_page(widget.getView(), text.get());
    }

    public void connect(ConnectFn fn) {
        this.fn = fn;
        tw.switch_page.connect((w, i) => fn(w, i));
    }

    public void switchIndex(int index) {
        tw.set_current_page(index);
    }

    public Gtk.Widget getView() { return tw; }
}
