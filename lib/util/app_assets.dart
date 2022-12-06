class AppAssets {
  static String forbidden() {
    return "assets/images/forbidden.svg";
  }

  static String error404() {
    return "assets/images/error.png";
  }

  static String noImage() {
    return "assets/images/no_image.png";
  }

  static String eyebrowBanner() {
    return "assets/images/eyebrow_banner.png";
  }

  static String logo() {
    return "assets/images/logo/cafeys-07.png";
  }

  static String launcher() {
    return "assets/images/ic_launcher.png";
  }

  static String faceContour() {
    return "assets/images/face_contour.png";
  }
}

class Eyebrow {
  late String left;
  late String right;

  Eyebrow({required this.left, required this.right});
}
