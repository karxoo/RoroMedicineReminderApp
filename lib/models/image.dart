class ImageClass {
  String? name, url;
  ImageClass({this.name, this.url});
}

class ImageModel {
  List<ImageClass> images = [];
  ImageModel();
  List<ImageClass> getAllImages(Map<String, dynamic> data) {
    images = [];

    data.forEach((name, url) {
      ImageClass image = ImageClass(name: name, url: url as String?);
      images.add(image);
    });
    return images;
  }

  List<ImageClass> searchImages(String name) {
    List<ImageClass> imagesFound = [];
    for (var image in images) {
      final imageName = image.name?.toLowerCase() ?? '';
      if (name.isNotEmpty && imageName.startsWith(name.toLowerCase())) {
        imagesFound.add(image);
      }
    }
    return imagesFound;
  }
}
