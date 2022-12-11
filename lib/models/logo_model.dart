class LogoModel {
    LogoModel({
        this.json,
    });

    final Map json;

    String get light => json['light'];

    String get dark => json['dark'];
}
