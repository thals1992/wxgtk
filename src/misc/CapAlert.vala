// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class CapAlert {

    public string text = "";
    public string title = "";
    string summary = "";
    public string area = "";
    string instructions = "";
    public string vtec = "";
    public string url = "";
    public string nwsHeadLine = "";
    public string windThreat = "";
    public string maxWindGust = "";
    public string hailThreat = "";
    public string maxHailSize = "";
    public string tornadoThreat = "";
    public string motion = "";

    public CapAlert.zero() {
    }

    public CapAlert(string url) {
        this.url = url;
        var html = UtilityIO.getHtml(url);
        title = UtilityString.parse(html, "\"headline\": \"(.*?)\"");
        summary = UtilityString.parse(html, "\"description\": \"(.*?)\"");
        instructions = UtilityString.parse(html, "\"instruction\": \"(.*?)\"");
        area = UtilityString.parse(html, "\"areaDesc\": \"(.*?)\"");
        summary = summary.replace("\\n", "\n");
        instructions = instructions.replace("\\n", "\n");

        windThreat = UtilityString.parse(html, "\"windThreat\": \\[.*?\"(.*?)\".*?\\],");
        maxWindGust = UtilityString.parse(html, "\"maxWindGust\": \\[.*?\"(.*?)\".*?\\],");
        hailThreat = UtilityString.parse(html, "\"hailThreat\": \\[.*?\"(.*?)\".*?\\],");
        maxHailSize = UtilityString.parse(html, "\"maxHailSize\": \\[\\s*(.*?)\\s*\\],");
        tornadoThreat = UtilityString.parse(html, "\"tornadoDetection\": \\[.*?\"(.*?)\".*?\\],");
        nwsHeadLine = UtilityString.parse(html, "\"NWSheadline\": \\[.*?\"(.*?)\".*?\\],");
        motion = UtilityString.parse(html, "\"eventMotionDescription\": \\[.*?\"(.*?)\".*?\\],");
        vtec = UtilityString.parse(html, "\"VTEC\": \\[.*?\"(.*?)\".*?\\],");

        text = "";
        text += title;
        text += GlobalVariables.newline;
        text += "Counties: ";
        text += area;
        text += GlobalVariables.newline;

        if (nwsHeadLine != "") {
            text += "..." + nwsHeadLine + "..." + GlobalVariables.newline + GlobalVariables.newline;
        }

        text += summary;
        text += GlobalVariables.newline + GlobalVariables.newline;

        if (instructions != "") {
            text += "PRECAUTIONARY/PREPAREDNESS ACTIONS..." + GlobalVariables.newline + GlobalVariables.newline;
            text += instructions;
        }

        text += GlobalVariables.newline + GlobalVariables.newline;

        if (windThreat != "") {
                text += "WIND THREAT..." + windThreat;
                text += GlobalVariables.newline;
        }
        if (maxWindGust != "" && maxWindGust != "0") {
                text += "MAX WIND GUST..." + maxWindGust;
                text += GlobalVariables.newline;
        }
        if (hailThreat != "") {
                text += "HAIL THREAT..." + hailThreat;
                text += GlobalVariables.newline;

                text += "MAX HAIL SIZE..." + maxHailSize + " in";
                text += GlobalVariables.newline;
        }
        if (tornadoThreat != "") {
                text += "TORNADO THREAT..." + tornadoThreat;
                text += GlobalVariables.newline;
        }
        text += motion + GlobalVariables.newline;
        text += vtec + GlobalVariables.newline;
    }
}
