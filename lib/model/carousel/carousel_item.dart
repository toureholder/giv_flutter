class CarouselItem {
  final String imageUrl;
  final String linkUrl;
  final String title;
  final String caption;

  CarouselItem({this.imageUrl, this.linkUrl, this.title, this.caption});

  static List<CarouselItem> mockList() {
    return [
      CarouselItem(
        imageUrl: 'https://picsum.photos/400/300/?image=20',
        title: 'Quanta coisa!',
        caption: 'Dê uma pesquisada, vai ;)',
      ),
      CarouselItem(
        imageUrl: 'https://picsum.photos/400/300/?image=1073',
          title: 'Melhore seu inglês',
          caption: 'Veja os livros sendo doados',
      ),
      CarouselItem(
        imageUrl: 'https://picsum.photos/400/300/?image=535',
        title: 'Abra espaço para o novo',
        caption: 'Veja como é fácil doar',
      ),
    ];
  }
}