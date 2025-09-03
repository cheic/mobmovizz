import 'dart:convert';

MovieProvider movieProviderFromJson(String str) => MovieProvider.fromJson(json.decode(str));

String movieProviderToJson(MovieProvider data) => json.encode(data.toJson());

class MovieProvider {
    int? id;
    Results? results;

    MovieProvider({
        this.id,
        this.results,
    });

    factory MovieProvider.fromJson(Map<String, dynamic> json) => MovieProvider(
        id: json["id"],
        results: json["results"] == null ? null : Results.fromJson(json["results"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "results": results?.toJson(),
    };
}

class Results {
    Ad? ad;
    Ar? ar;
    Ar? be;
    Ar? bo;
    Ar? br;
    Ar? bz;
    Ar? ca;
    Ar? cl;
    Ar? co;
    Ar? cr;
    Ar? dk;
    Ar? ec;
    Ar? es;
    Ar? fi;
    Ar? fr;
    Ar? gb;
    Ar? gt;
    Ar? hn;
    Ar? ie;
    It? it;
    Ar? jp;
    Ar? kr;
    Ar? mx;
    Ar? ni;
    Ar? no;
    Ar? pe;
    Ad? pt;
    Ar? py;
    Ar? se;
    Ar? us;
    Ar? ve;

    Results({
        this.ad,
        this.ar,
        this.be,
        this.bo,
        this.br,
        this.bz,
        this.ca,
        this.cl,
        this.co,
        this.cr,
        this.dk,
        this.ec,
        this.es,
        this.fi,
        this.fr,
        this.gb,
        this.gt,
        this.hn,
        this.ie,
        this.it,
        this.jp,
        this.kr,
        this.mx,
        this.ni,
        this.no,
        this.pe,
        this.pt,
        this.py,
        this.se,
        this.us,
        this.ve,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        ad: json["AD"] == null ? null : Ad.fromJson(json["AD"]),
        ar: json["AR"] == null ? null : Ar.fromJson(json["AR"]),
        be: json["BE"] == null ? null : Ar.fromJson(json["BE"]),
        bo: json["BO"] == null ? null : Ar.fromJson(json["BO"]),
        br: json["BR"] == null ? null : Ar.fromJson(json["BR"]),
        bz: json["BZ"] == null ? null : Ar.fromJson(json["BZ"]),
        ca: json["CA"] == null ? null : Ar.fromJson(json["CA"]),
        cl: json["CL"] == null ? null : Ar.fromJson(json["CL"]),
        co: json["CO"] == null ? null : Ar.fromJson(json["CO"]),
        cr: json["CR"] == null ? null : Ar.fromJson(json["CR"]),
        dk: json["DK"] == null ? null : Ar.fromJson(json["DK"]),
        ec: json["EC"] == null ? null : Ar.fromJson(json["EC"]),
        es: json["ES"] == null ? null : Ar.fromJson(json["ES"]),
        fi: json["FI"] == null ? null : Ar.fromJson(json["FI"]),
        fr: json["FR"] == null ? null : Ar.fromJson(json["FR"]),
        gb: json["GB"] == null ? null : Ar.fromJson(json["GB"]),
        gt: json["GT"] == null ? null : Ar.fromJson(json["GT"]),
        hn: json["HN"] == null ? null : Ar.fromJson(json["HN"]),
        ie: json["IE"] == null ? null : Ar.fromJson(json["IE"]),
        it: json["IT"] == null ? null : It.fromJson(json["IT"]),
        jp: json["JP"] == null ? null : Ar.fromJson(json["JP"]),
        kr: json["KR"] == null ? null : Ar.fromJson(json["KR"]),
        mx: json["MX"] == null ? null : Ar.fromJson(json["MX"]),
        ni: json["NI"] == null ? null : Ar.fromJson(json["NI"]),
        no: json["NO"] == null ? null : Ar.fromJson(json["NO"]),
        pe: json["PE"] == null ? null : Ar.fromJson(json["PE"]),
        pt: json["PT"] == null ? null : Ad.fromJson(json["PT"]),
        py: json["PY"] == null ? null : Ar.fromJson(json["PY"]),
        se: json["SE"] == null ? null : Ar.fromJson(json["SE"]),
        us: json["US"] == null ? null : Ar.fromJson(json["US"]),
        ve: json["VE"] == null ? null : Ar.fromJson(json["VE"]),
    );

    Map<String, dynamic> toJson() => {
        "AD": ad?.toJson(),
        "AR": ar?.toJson(),
        "BE": be?.toJson(),
        "BO": bo?.toJson(),
        "BR": br?.toJson(),
        "BZ": bz?.toJson(),
        "CA": ca?.toJson(),
        "CL": cl?.toJson(),
        "CO": co?.toJson(),
        "CR": cr?.toJson(),
        "DK": dk?.toJson(),
        "EC": ec?.toJson(),
        "ES": es?.toJson(),
        "FI": fi?.toJson(),
        "FR": fr?.toJson(),
        "GB": gb?.toJson(),
        "GT": gt?.toJson(),
        "HN": hn?.toJson(),
        "IE": ie?.toJson(),
        "IT": it?.toJson(),
        "JP": jp?.toJson(),
        "KR": kr?.toJson(),
        "MX": mx?.toJson(),
        "NI": ni?.toJson(),
        "NO": no?.toJson(),
        "PE": pe?.toJson(),
        "PT": pt?.toJson(),
        "PY": py?.toJson(),
        "SE": se?.toJson(),
        "US": us?.toJson(),
        "VE": ve?.toJson(),
    };
}

class Ad {
    String? link;
    List<Flatrate>? flatrate;

    Ad({
        this.link,
        this.flatrate,
    });

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        link: json["link"],
        flatrate: json["flatrate"] == null ? [] : List<Flatrate>.from(json["flatrate"]!.map((x) => Flatrate.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "link": link,
        "flatrate": flatrate == null ? [] : List<dynamic>.from(flatrate!.map((x) => x.toJson())),
    };
}

class Flatrate {
    String? logoPath;
    int? providerId;
    String? providerName;
    int? displayPriority;

    Flatrate({
        this.logoPath,
        this.providerId,
        this.providerName,
        this.displayPriority,
    });

    factory Flatrate.fromJson(Map<String, dynamic> json) => Flatrate(
        logoPath: json["logo_path"],
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        displayPriority: json["display_priority"],
    );

    Map<String, dynamic> toJson() => {
        "logo_path": logoPath,
        "provider_id": providerId,
        "provider_name": providerName,
        "display_priority": displayPriority,
    };
}

class Ar {
    String? link;
    List<Flatrate>? rent;
    List<Flatrate>? flatrate;
    List<Flatrate>? buy;
    List<Flatrate>? free;

    Ar({
        this.link,
        this.rent,
        this.flatrate,
        this.buy,
        this.free,
    });

    factory Ar.fromJson(Map<String, dynamic> json) => Ar(
        link: json["link"],
        rent: json["rent"] == null ? [] : List<Flatrate>.from(json["rent"]!.map((x) => Flatrate.fromJson(x))),
        flatrate: json["flatrate"] == null ? [] : List<Flatrate>.from(json["flatrate"]!.map((x) => Flatrate.fromJson(x))),
        buy: json["buy"] == null ? [] : List<Flatrate>.from(json["buy"]!.map((x) => Flatrate.fromJson(x))),
        free: json["free"] == null ? [] : List<Flatrate>.from(json["free"]!.map((x) => Flatrate.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "link": link,
        "rent": rent == null ? [] : List<dynamic>.from(rent!.map((x) => x.toJson())),
        "flatrate": flatrate == null ? [] : List<dynamic>.from(flatrate!.map((x) => x.toJson())),
        "buy": buy == null ? [] : List<dynamic>.from(buy!.map((x) => x.toJson())),
        "free": free == null ? [] : List<dynamic>.from(free!.map((x) => x.toJson())),
    };
}

class It {
    String? link;
    List<Flatrate>? ads;

    It({
        this.link,
        this.ads,
    });

    factory It.fromJson(Map<String, dynamic> json) => It(
        link: json["link"],
        ads: json["ads"] == null ? [] : List<Flatrate>.from(json["ads"]!.map((x) => Flatrate.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "link": link,
        "ads": ads == null ? [] : List<dynamic>.from(ads!.map((x) => x.toJson())),
    };
}
