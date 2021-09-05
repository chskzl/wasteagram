import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/post.dart';

void main() {

  test('unit tests', () {
    Post testPost = Post(date: DateTime.now(), imageURL: 'https://i.kym-cdn.com/entries/icons/original/000/034/421/cover1.jpg', quantity: 5, latitude: 5.0, longitude: 5.0);

    expect(testPost.imageURL, isNotEmpty);
    expect(testPost.quantity, isPositive);
    expect(testPost.date.toString(), isNotEmpty);
  });
}
