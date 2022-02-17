// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class MainWindow : Gtk.ApplicationWindow {

    ComboBox comboBox = new ComboBox(Location.listOfNames());
    ObjectSevenDay objectSevenDay = new ObjectSevenDay(Location.getLatLonCurrent());
    ObjectCurrentConditions objectCurrentConditions = new ObjectCurrentConditions(Location.getLatLonCurrent());
    ObjectHazards objectHazards = new ObjectHazards(Location.getLatLonCurrent());
    ObjectCardSevenDay objectCardSevenDay;
    ObjectCardCurrentConditions objectCardCurrentConditions;
    ObjectCardHazards objectCardHazards;
    VBox box = new VBox();
    VBox boxCc = new VBox();
    VBox boxSevenDay = new VBox();
    VBox boxHazards = new VBox();
    ObjectToolbar toolbar;
    bool initializedCc = false;
    bool initialized7Day = false;
    HBox layout = new HBox();
    VBox imageLayout = new VBox();
    VBox forecastLayout = new VBox();
    VBox rightMostLayout = new VBox();
    /// Gtk.EventControllerKey controller;
    HashMap<string, Image> imageWidgets = new HashMap<string, Image>();
    HashMap<string, Text> textWidgets = new HashMap<string, Text>();
    string tokenString = "";
    int imageSize = UIPreferences.mainScreenImageSize;
    ArrayList<NexradWidget> nexradList = new ArrayList<NexradWidget>();
    //
    // Mini SevereDashboard
    //
    HBox boxSevereDashboard = new HBox();
    ArrayList<string> urls = new ArrayList<string>();
    ArrayList<Image> images = new ArrayList<Image>();
    HashMap<PolygonType, SevereNotice> watchesByType = new HashMap<PolygonType, SevereNotice>();
    ArrayList<WByteArray> bytesList = new ArrayList<WByteArray>();

    public MainWindow(Gtk.Application application) {
        GLib.Object(application: application);
        UtilityUI.maximize(this);

        try { //GTK4_DELETE
            this.icon = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + "wx_launcher.png"); //GTK4_DELETE
        } catch (Error e) { //GTK4_DELETE
            print("Error " + e.message + "\n"); //GTK4_DELETE
        } //GTK4_DELETE

        // controller = new Gtk.EventControllerKey(this); //GTK4_DELETE
        /// controller = new Gtk.EventControllerKey();
        /// ((Gtk.Widget)this).add_controller(controller);
        /// controller.key_pressed.connect(window_key_pressed);

        toolbar = new ObjectToolbar(reload);
        comboBox.setIndex(Location.getCurrentLocation());
        comboBox.connect(comboBoxChanged);
        Location.comboBox = comboBox;

        watchesByType[PolygonType.watch] = new SevereNotice(PolygonType.watch);
        watchesByType[PolygonType.mcd] = new SevereNotice(PolygonType.mcd);
        watchesByType[PolygonType.mpd] = new SevereNotice(PolygonType.mpd);

        //
        // TEST init nexrad
        //
        if (UIPreferences.nexradMainScreen) {
            var sb = new StatusBar( );
            var rsb = new RadarStatusBox();
            nexradList.add(
                new NexradWidget(
                    0,
                    1,
                    true,
                    sb,
                    rsb,
                    () => {},
                    () => {},
                    () => {},
                    () => {},
                    () => {}
                )
            );
        }
        addWidgets();

        layout.addWidget(toolbar.get());
        if (UIPreferences.mainScreenSevereDashboard) {
            box.addLayout(boxSevereDashboard.get());
        }
        box.addLayout(layout.get());
        layout.addLayout(imageLayout.get());
        layout.addLayout(forecastLayout.get());
        new ScrolledWindow(this, box);

        forecastLayout.addLayout(comboBox.get());
        forecastLayout.addLayout(boxCc.get());
        forecastLayout.addLayout(boxHazards.get());
        forecastLayout.addLayout(boxSevenDay.get());
        layout.addLayout(rightMostLayout.get());

        reload();
    }

    void comboBoxChanged() {
        if (comboBox.getIndex() != -1) {
            this.locationChanged();
        }
    }

    void locationChanged() {
        Location.setCurrentLocation(comboBox.getIndex());
        reload();
    }

    void reload() {
        configChangeCheck();
        new FutureVoid(getCC, updateCc);
        new FutureVoid(getHazards, updateHazards);
        new FutureVoid(get7Day, update7Day);
        if (!UtilityUI.isScreenSmall()) {
            foreach (var item in UIPreferences.homeScreenItemsText) {
                if (item.isEnabled()) {
                    new FutureText(item.prefToken, textWidgets[item.prefToken].setText);
                }
            }
            foreach (var item in UIPreferences.homeScreenItemsImage) {
                if (item.isEnabled()) {
                    new FutureBytes(UtilityDownload.getImageProduct(item.prefToken), imageWidgets[item.prefToken].setBytes);
                }
            }
            if (UIPreferences.nexradMainScreen) {
                var pane = 0;
                nexradList[pane].nexradState.radarSite = Location.radarSite();
                nexradList[pane].nexradState.reset();
                nexradList[pane].nexradState.zoom = 0.6;
                new FutureVoid(nexradList[pane].initGeom, nexradList[pane].da.draw);
                foreach (var nw in nexradList) {
                    new FutureVoid(nw.downloadData, nw.update);
                }
            }
            if (UIPreferences.mainScreenSevereDashboard) {
                new FutureVoid(downloadWatch, updateWatch);
            }
        }
    }

    void downloadWatch() {
        urls.clear();
        foreach (var t in new PolygonType[]{PolygonType.mcd, PolygonType.mpd, PolygonType.watch}) {
            ObjectPolygonWatch.polygonDataByType[t].download();
        }
        urls.add(UtilityDownload.getImageProduct("USWARN"));
        urls.add(UtilityDownload.getImageProduct("STRPT"));

        foreach (var t in new PolygonType[]{PolygonType.watch, PolygonType.mcd, PolygonType.mpd}) {
            ObjectPolygonWatch.polygonDataByType[t].download();
            watchesByType[t].getBitmaps();
            urls.add_all(watchesByType[t].urls);
        }
        foreach (var index in UtilityList.range(urls.size)) {
            images.add(new Image.withIndex(index));
            images.last().imageSize = 150;
            bytesList.add(new WByteArray.fromArray(UtilityIO.downloadAsByteArray(urls[index])));
        }
    }

    void updateWatch() {
        foreach (var index in UtilityList.range(urls.size)) {
            images[index].setBytes(bytesList[index].data);
            images[index].connect(launch);
            boxSevereDashboard.addWidget(images[index].get());
            //  if (boxRows.size <= (int)(index / imagesAcross)) {
            //      HBox boxRow = new HBox();
            //      boxRows.add(boxRow);
            //  }
            //  boxRows.last().addWidget(images[index].get());
        }
        //  foreach (HBox br in boxRows) {
        //      boxImages.addLayout(br.get());
        //  }
        // updateStatusBar();
    }

    void launch(int indexFinal) {
        if (indexFinal == 0) {
            new UsAlerts();
        } else if (indexFinal == 1) {
            new SpcStormReports("today");
        } else if (indexFinal > 1) {
            new SpcMcdWatchMpdViewer(urls[indexFinal]);
        }
    }

    void configChangeCheck() {
        if (tokenString != computeTokenString() || UIPreferences.mainScreenImageSize != imageSize) {
            addWidgets();
        }
    }

    void get7Day() {
        objectSevenDay = new ObjectSevenDay(Location.getLatLonCurrent());
        objectSevenDay.process();
    }

    void getCC() {
        objectCurrentConditions = new ObjectCurrentConditions(Location.getLatLonCurrent());
        objectCurrentConditions.process();
    }

    void getHazards() {
        objectHazards = new ObjectHazards(Location.getLatLonCurrent());
        objectHazards.process();
    }

    void updateCc() {
        if (!initializedCc) {
            objectCardCurrentConditions = new ObjectCardCurrentConditions(objectCurrentConditions);
            boxCc.addLayout(objectCardCurrentConditions.get());
            initializedCc = true;
        } else {
            objectCardCurrentConditions.update(objectCurrentConditions);
        }
    }

    void update7Day() {
        if (!initialized7Day || objectCardSevenDay.cards.size == 0) {
            objectCardSevenDay = new ObjectCardSevenDay(boxSevenDay, objectSevenDay.detailedForecasts, objectSevenDay.icons);
            initialized7Day = true;
        } else {
            objectCardSevenDay.update(objectSevenDay.detailedForecasts, objectSevenDay.icons);
        }
    }

    void updateHazards() {
        boxHazards.removeChildren();
        objectCardHazards = new ObjectCardHazards(objectHazards);
        boxHazards.addLayout(objectCardHazards.get());
    }

    void addWidgets() {
        imageLayout.removeChildren();
        rightMostLayout.removeChildren();
        imageWidgets.clear();
        textWidgets.clear();
        tokenString = "";
        if (UIPreferences.mainScreenSevereDashboard) {
            boxSevereDashboard.removeChildren();
        }
        //
        // TEST - put nexrad at top
        //
        if (UIPreferences.nexradMainScreen) {
            nexradList[0].da.setSizeRequest(UIPreferences.mainScreenImageSize, UIPreferences.mainScreenImageSize);
            imageLayout.addWidget(nexradList[0].da.get());
            foreach (var nw in nexradList) {
                //  if (useASpecificRadar) {
                //      nw.nexradState.radarSite = radarToUse;
                //  } else {
                //      nw.nexradState.readPreferences();
                //  }
                //  if (RadarPreferences.colorLegend) {
                //      colorLegends.add(new UIColorLegend(nw.nexradState.radarProduct));
                //  }
                new FutureVoid(nw.initGeom, nw.da.draw);
            }

        }
        //
        // image setup
        //
        var imageIndex = 0;
        foreach (var item in UIPreferences.homeScreenItemsImage) {
            if (item.isEnabled()) {
                imageWidgets[item.prefToken] = new Image.withIndex(imageIndex);
                imageWidgets[item.prefToken].connect(launchImageScreen);
                imageWidgets[item.prefToken].imageSize = UIPreferences.mainScreenImageSize;
                imageLayout.addWidget(imageWidgets[item.prefToken].get());
                tokenString += item.prefToken;
            }
            imageSize = UIPreferences.mainScreenImageSize;
            imageIndex += 1;
        }
        //
        // Textual right side bar (hourly)
        //
        foreach (var item in UIPreferences.homeScreenItemsText) {
            if (item.isEnabled()) {
                textWidgets[item.prefToken] = new Text();
                textWidgets[item.prefToken].setFixedWidth();
                rightMostLayout.addWidget(textWidgets[item.prefToken].get());
                tokenString += item.prefToken;
            }
        }
    }

    string computeTokenString() {
        var tokenString = "";
        foreach (var item in UIPreferences.homeScreenItemsImage) {
            if (item.isEnabled()) {
                tokenString += item.prefToken;
            }
        }
        foreach (var item in UIPreferences.homeScreenItemsText) {
            if (item.isEnabled()) {
                tokenString += item.prefToken;
            }
        }
        return tokenString;
    }

    // GTK3
    protected override bool key_press_event(Gdk.EventKey event) { //GTK4_DELETE
        return windowKeyPressedCommon(event.keyval, event.state); //GTK4_DELETE
    } //GTK4_DELETE

    ///  bool window_key_pressed(Gtk.EventControllerKey controller, uint keyval, uint keycode, Gdk.ModifierType state) {
    ///      return windowKeyPressedCommon(keyval, state);
    ///  }

    bool windowKeyPressedCommon(uint keyval, Gdk.ModifierType state) {
        if (keyval == Gdk.Key.Escape) {
            close();
            return true;
        }
        var default_modifiers = Gtk.accelerator_get_default_mod_mask();
        if ((state & default_modifiers) == Gdk.ModifierType.CONTROL_MASK) {
            switch (keyval) {
                case Gdk.Key.q:
                    close();
                    break;
                case Gdk.Key.h:
                    new Hourly();
                    break;
                case Gdk.Key.a:
                    new WfoText();
                    break;
                case Gdk.Key.l:
                    Route.lightning();
                    break;
                case Gdk.Key.c:
                    new GoesViewer("");
                    break;
                case Gdk.Key.f:
                    new SpcFireSummary();
                    break;
                case Gdk.Key.s:
                    new SpcSwoSummary();
                    break;
                case Gdk.Key.z:
                    new SpcMeso();
                    break;
                case Gdk.Key.i:
                    new NationalImages();
                    break;
                case Gdk.Key.d:
                    new SevereDashboard();
                    break;
                case Gdk.Key.o:
                    new Nhc();
                    break;
                case Gdk.Key.u:
                    reload();
                    break;
                case Gdk.Key.m:
                    new RadarMosaicAwc();
                    break;
                case Gdk.Key.n:
                    new ModelViewer("NCEP");
                    break;
                case Gdk.Key.t:
                    new NationalText("");
                    break;
                case Gdk.Key.r:
                    new Nexrad(1, false, "");
                    break;
                case Gdk.Key.@1:
                    new Nexrad(1, false, "");
                    break;
                case Gdk.Key.@2:
                    new Nexrad(2, false, "");
                    break;
                case Gdk.Key.@4:
                    new Nexrad(4, false, "");
                    break;
                case Gdk.Key.p:
                    toolbar.settingsPopoverBox.popup();
                    break;
                case Gdk.Key.v:
                    new ObservationSites();
                    break;
                default:
                    break;
            }
        }
        return true;
    }

    void launchImageScreen(int index) {
        var token = UIPreferences.homeScreenItemsImage[index].prefToken;
        if (token == "VISIBLE_SATELLITE") {
            new GoesViewer("");
        } else if (token == "RADAR_MOSAIC") {
            new RadarMosaicAwc();
        } else if (token == "ANALYSIS_RADAR_AND_WARNINGS") {
            new NationalImages();
        } else if (token == "USWARN") {
            new UsAlerts();
        }
    }
}