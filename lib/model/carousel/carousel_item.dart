class CarouselItem {
  final String imageUrl;
  final String linkUrl;
  final String title;
  final String caption;

  CarouselItem({this.imageUrl, this.linkUrl, this.title, this.caption});

  static List<CarouselItem> mockList() {
    return [
      CarouselItem(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/pullup-life.appspot.com/o/marketing%2Ftemp_giv%2Fgiv_banner_o_que_eh_minimalismo.jpg?alt=media&token=dfe0d449-0044-4c9b-88f4-5f9375d94784',
      ),
      CarouselItem(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/pullup-life.appspot.com/o/marketing%2Ftemp_giv%2Fgiv_banner_7_coisas.jpg?alt=media&token=3b17aa2f-feb6-46d0-8ee9-28405dca88d5',
      ),
      CarouselItem(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/pullup-life.appspot.com/o/marketing%2Ftemp_giv%2Fgiv_banner_o_prazer.jpg?alt=media&token=66484516-8339-4569-97cd-62cc1b1c89ba',
      )
    ];
  }
}