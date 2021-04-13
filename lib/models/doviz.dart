class ItemListElement {
    ItemListElement({
        this.type,
        this.currency,
        this.currentExchangeRate,
    });

    String type;
    String currency;
    CurrentExchangeRate currentExchangeRate;

    factory ItemListElement.fromJson(Map<String, dynamic> json) => ItemListElement(
        type: json["@type"],
        currency: json["currency"],
        currentExchangeRate: CurrentExchangeRate.fromJson(json["currentExchangeRate"]),
    );

    Map<String, dynamic> toJson() => {
        "@type": type,
        "currency": currency,
        "currentExchangeRate": currentExchangeRate.toJson(),
    };
}

class CurrentExchangeRate {
    CurrentExchangeRate({
        this.type,
        this.price,
        this.priceCurrency,
    });

    String type;
    double price;
    String priceCurrency;

    factory CurrentExchangeRate.fromJson(Map<String, dynamic> json) => CurrentExchangeRate(
        type: json["@type"],
        price: json["price"].toDouble(),
        priceCurrency: json["priceCurrency"],
    );

    Map<String, dynamic> toJson() => {
        "@type": type,
        "price": price,
        "priceCurrency": priceCurrency,
    };
}
