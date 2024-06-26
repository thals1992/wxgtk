// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SoundingSites {

    public static HashMap<string, string> name;
    public static HashMap<string, string> lat;
    public static HashMap<string, string> lon;

    public static void initStatic() {
        name = new HashMap<string, string>();
        lat = new HashMap<string, string>();
        lon = new HashMap<string, string>();

        name["VBG"] = "CA, Vandenberg AFB";
        name["1Y7"] = "AZ, Yuma";
        name["76405"] = "MX, La Paz";
        name["76458"] = "MX, Mazatlan";
        name["SLE"] = "OR, Salem";
        name["UIL"] = "WA, Quillayute";
        name["YLW"] = ", KELOWNA APT";
        name["OAK"] = "CA, Oakland";
        name["NKX"] = "CA, San Diego";
        name["TUS"] = "AZ, Tucson";
        name["DRT"] = "TX, Del Rio";
        name["RAP"] = "SD, Rapid City";
        name["INL"] = "MN, International Falls";
        name["BNA"] = "TN, Nashville";
        name["YMO"] = ", MOOSONEE";
        name["GSO"] = "NC, Greensboro";
        name["WAL"] = "VA, Wallops Island";
        name["IAD"] = "DC, Washington";
        name["PIT"] = "PA, Pittsburgh";
        name["ALB"] = "NY, Albany";
        name["CHH"] = "MA, Chatham";
        name["YQI"] = "Nova Scotia, Yarmouth";
        name["XMR"] = "FL, Cape Canaveral";
        name["TLH"] = "FL, Tallahassee";
        name["WPL"] = "ON, Pickle Lake";
        name["DNR"] = "CO, Denver";

        lat["76225"] = "28.70";
        lat["76405"] = "24.07";
        lat["76458"] = "23.18";
        lat["ABE"] = "60.78";
        lat["ABQ"] = "35.03";
        lat["ABR"] = "45.45";
        lat["ACD"] = "55.20";
        lat["ADQ"] = "57.75";
        lat["AFA"] = "64.82";
        lat["AKN"] = "58.68";
        lat["ALB"] = "42.75";
        lat["AMA"] = "35.23";
        lat["AMC"] = "62.95";
        lat["ANC"] = "61.17";
        lat["ANT"] = "55.03";
        lat["AOM"] = "64.52";
        lat["AOT"] = "66.87";
        lat["APX"] = "44.90";
        lat["ASN"] = "57.15";
        lat["ASY"] = "52.72";
        lat["AYA"] = "59.52";
        lat["BIS"] = "46.77";
        lat["BMX"] = "33.17";
        lat["BNA"] = "36.12";
        lat["BOI"] = "43.57";
        lat["BRO"] = "25.90";
        lat["BUF"] = "42.93";
        lat["CAR"] = "46.87";
        lat["CHH"] = "41.67";
        lat["CHS"] = "32.90";
        lat["CRP"] = "27.77";
        lat["DDC"] = "37.77";
        lat["DNR"] = "39.75";
        lat["DRA"] = "36.62";
        lat["DRT"] = "29.37";
        lat["DTX"] = "42.68";
        lat["DVN"] = "41.60";
        lat["EPZ"] = "31.90";
        lat["EYW"] = "24.55";
        lat["FFC"] = "33.36";
        lat["FLG"] = "35.23";
        lat["FWD"] = "32.80";
        lat["GGW"] = "48.21";
        lat["GJT"] = "39.12";
        lat["GRB"] = "44.48";
        lat["GSO"] = "36.08";
        lat["GYX"] = "43.89";
        lat["IAD"] = "39.083667";
        lat["ILN"] = "39.42";
        lat["ILX"] = "40.10";
        lat["INL"] = "48.57";
        lat["JAN"] = "32.32";
        lat["JAX"] = "30.43";
        lat["KEY"] = "24.55";
        lat["LBF"] = "41.13";
        lat["LCH"] = "30.12";
        lat["LIX"] = "30.337";
        lat["LKN"] = "40.87";
        lat["LWX"] = "38.98";
        lat["LZK"] = "34.83";
        lat["MAF"] = "31.95";
        lat["MFL"] = "25.75";
        lat["MFR"] = "42.37";
        lat["MFX"] = "25.80";
        lat["MHX"] = "34.70";
        lat["MPX"] = "44.85";
        lat["NJM"] = "34.69";
        lat["NKX"] = "32.73";
        lat["OAK"] = "37.73";
        lat["OAX"] = "41.32";
        lat["OKX"] = "40.86";
        lat["OTX"] = "47.68";
        lat["OUN"] = "35.23";
        lat["PIT"] = "40.50";
        lat["REV"] = "39.57";
        lat["RIW"] = "43.00";
        lat["RNK"] = "37.21";
        lat["SGF"] = "37.14";
        lat["SHV"] = "32.45";
        lat["SIL"] = "30.25";
        lat["SLC"] = "40.78";
        lat["SLE"] = "44.92";
        lat["TBW"] = "27.70";
        lat["TFX"] = "47.45";
        lat["TLH"] = "30.56";
        lat["TOP"] = "39.07";
        lat["TUS"] = "32.12";
        lat["UIL"] = "47.95";
        lat["UNR"] = "44.07";
        lat["VBG"] = "34.72";
        lat["WAL"] = "37.85";
        lat["WMW"] = "46.0";
        lat["WPL"] = "51.47";
        lat["YLW"] = "49.97";
        lat["YMO"] = "51.27";

        lon["1Y7"] = "114.40";
        lon["76225"] = "106.07";
        lon["76405"] = "110.33";
        lon["76458"] = "106.42";
        lon["ABE"] = "161.80";
        lon["ABQ"] = "106.62";
        lon["ABR"] = "98.41";
        lon["ACD"] = "162.73";
        lon["ADQ"] = "152.50";
        lon["AFA"] = "147.87";
        lon["AKN"] = "156.65";
        lon["ALB"] = "73.80";
        lon["AMA"] = "101.70";
        lon["AMC"] = "155.60";
        lon["ANC"] = "150.02";
        lon["ANT"] = "131.57";
        lon["AOM"] = "165.45";
        lon["AOT"] = "162.63";
        lon["APX"] = "84.72";
        lon["ASN"] = "170.22";
        lon["ASY"] = "174.12";
        lon["AYA"] = "139.67";
        lon["BIS"] = "100.75";
        lon["BMX"] = "86.77";
        lon["BNA"] = "86.68";
        lon["BOI"] = "116.22";
        lon["BRO"] = "97.43";
        lon["BUF"] = "78.73";
        lon["CAR"] = "68.02";
        lon["CHH"] = "69.97";
        lon["CHS"] = "80.03";
        lon["CRP"] = "97.50";
        lon["DDC"] = "99.97";
        lon["DNR"] = "104.87";
        lon["DRA"] = "116.02";
        lon["DRT"] = "100.92";
        lon["DTX"] = "83.47";
        lon["DVN"] = "90.60";
        lon["EPZ"] = "106.70";
        lon["EYW"] = "81.75";
        lon["FFC"] = "84.56";
        lon["FLG"] = "111.82";
        lon["FWD"] = "97.30";
        lon["GGW"] = "106.63";
        lon["GJT"] = "108.53";
        lon["GRB"] = "88.13";
        lon["GSO"] = "79.95";
        lon["GYX"] = "70.25";
        lon["IAD"] = "77.529224";
        lon["ILN"] = "83.82";
        lon["ILX"] = "89.30";
        lon["INL"] = "93.38";
        lon["JAN"] = "90.08";
        lon["JAX"] = "81.61";
        lon["KEY"] = "81.75";
        lon["LBF"] = "100.68";
        lon["LCH"] = "93.22";
        lon["LIX"] = "89.825";
        lon["LKN"] = "115.73";
        lon["LWX"] = "77.47";
        lon["LZK"] = "92.25";
        lon["MAF"] = "102.18";
        lon["MFL"] = "80.38";
        lon["MFR"] = "122.87";
        lon["MFX"] = "80.38";
        lon["MHX"] = "76.80";
        lon["MPX"] = "93.57";
        lon["NJM"] = "77.03";
        lon["NKX"] = "117.17";
        lon["OAK"] = "122.22";
        lon["OAX"] = "96.37";
        lon["OKX"] = "72.86";
        lon["OTX"] = "117.63";
        lon["OUN"] = "97.47";
        lon["PIT"] = "80.22";
        lon["REV"] = "119.80";
        lon["RIW"] = "108.50";
        lon["RNK"] = "80.41";
        lon["SGF"] = "93.23";
        lon["SHV"] = "93.83";
        lon["SIL"] = "89.77";
        lon["SLC"] = "111.97";
        lon["SLE"] = "123.00";
        lon["TBW"] = "82.40";
        lon["TFX"] = "111.38";
        lon["TLH"] = "84.45";
        lon["TOP"] = "95.62";
        lon["TUS"] = "110.93";
        lon["UIL"] = "124.55";
        lon["UNR"] = "103.21";
        lon["VBG"] = "120.57";
        lon["WAL"] = "75.48";
        lon["WMW"] = "76.87";
        lon["WPL"] = "90.20";
        lon["YLW"] = "119.38";
        lon["YMO"] = "80.65";
    }
}
