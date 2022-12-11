class OnboardModel
{
    OnboardModel({
        this.json,
    });

    final Map json;

    String get title => json['title'];

    String get subTitle => json['subTitle'];

    String get image => json['image'];
}
