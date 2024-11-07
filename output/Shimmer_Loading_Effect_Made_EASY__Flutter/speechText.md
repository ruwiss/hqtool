Siz değerli izleyici, bu videoda, nasıl bir Shimmer etkisi yaratacağınızı öğreneceksiniz. Bu gibi bir Shimmer etkisini oluşturmayı öğrenmek istiyorsanız, ancak daha karmaşık bir şeye ihtiyacınız varsa, videonun açıklamasındaki bağlantıya tıklayabilirsiniz. Bence oradaki örnek aşırı karmaşık, çünkü bu basit örnek için 300'den fazla kod satırı kullanmışlar. Bizim örnekte ise sadece 77 kod satırı var ve bunu adım adım size göstereceğim. Hadi sıfırdan başlayalım.

Öncelikle, bir ShimmerView widget'ı oluşturmalıyız. Bu widget, stateless bir widget olacak ve içine bir Column yerleştireceğiz. Column'ın crossAxisAlignment özelliği Start olarak ayarlanacak, böylece her şey sola hizalanacak. Ardından, Column'ın children özelliği içerisine ShimmerBox adında bir widget daha ekleyeceğiz. Bu da stateless bir widget olacak, ancak bir Constructor'a ihtiyacımız olacak. Constructor'da bir int tipinde flex ve bir double tipinde width değişkeni tanımlayacağız. Flex değeri, ShimmerBox widget'ının yüksekliğini belirleyecek.

Sonrasında bir Expanded widget'ı döndüreceğiz. Expanded widget'ın flex özelliği, Constructor'da tanımlanan flex değerini alacak. Expanded widget'ın child'ı olarak da FractionallySizedBox'ı kullanacağız. FractionallySizedBox'ın içine widthFactor'ü ekleyeceğiz, bu da Constructor'dan gelen width değerini alacak.

Ardından, FractionallySizedBox'ın child'ı olarak Container'ı oluşturacağız. Container'a padding ve decoration ekleyeceğiz. Decoration'ın color özelliği, siyah opak renk olacak ve border radius'u da 15 olacak.

Son olarak, ShimmerView içerisinde ShimmerBox'ları ekleyeceğiz. Children özelliği içerisinde 3 tane ShimmerBox widget'ı ve 3 tane SizedBox widget'ı ekleyeceğiz. Bu da tek bir öğe oluşturacak. Bu kodu çoğaltırsak, istediğimiz kadar öğe oluşturabiliriz. Kodları dilediğiniz gibi değiştirebilirsiniz.

Görüşmek üzere! 
