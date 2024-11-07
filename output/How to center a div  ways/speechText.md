Neden bir div'i düzgün şekilde ortalamak bu kadar zor?

Bu videoda, bir div'i ortalamak için 12 farklı yolu inceleyeceğiz.

90'lı yıllarda bir şeyi ortalamak için tek yol tablo düzeni kullanmaktı. Lütfen bunu artık yapmayın.

Temel kurulumumuz var. Klasik bir üst elemanımız ve onun içinde "child" sınıfına sahip bir div'imiz var.

İşte onu şık göstermek için temel CSS stilleri.

İlk gerçek örneğimizde üst elemanımızın konumunu "relative", alt elemanımızın konumunu ise "absolute" yapacağız.

Bu sayede alt elemanın "top", "right", "bottom" ve "left" konumunu ayarlayabiliriz.

"Top" ve "left" konumlarını 50'ye ayarlayacağız. Ancak bunun kutunun sol üst köşesini ortaya koyduğunu fark edin.

Bunu "transform" kullanarak düzeltebiliriz. "Transform" ile kutunun x ve y konumlarını -50'ye çevireceğiz. Şimdi mükemmel bir şekilde ortalandı.

Üçüncü örnekte "relative" ve "absolute" konumları kullanacağız, ancak bu sefer "top", "right", "bottom" ve "left" değerlerini sıfıra ayarlayacağız. Ardından "margin: auto" ekleyeceğiz.

Bu, içeriğimizi ortama zorlayacaktır.

Veya "top", "right", "bottom" ve "left" konumlarını "inset" adlı tek bir özellikte birleştirebiliriz. Bu da aynı şekilde çalışır.

Beşinci örnekte, üst elemanın "display" özelliğini "flex" olarak ayarlayacağız. Ardından "justify-content" özelliği ile kutumuzu yatay olarak ortalayacağız.

"Align-items" özelliği ile de kutumuzu dikey olarak ortalayacağız.

Bu yöntemde alt elemanı stillemekle uğraşmaya gerek yok.

Alternatif olarak, birden fazla alt elemanımız varsa ve hangisinin ortalanacağını belirlemek istiyorsak, bu özellikleri "self" versiyonunu kullanarak alt elemana taşıyabiliriz.

Burada "align-self" değerini "center" olarak ayarlıyoruz. Veya hiç "content" veya "item" hizalama kullanmıyoruz, yalnızca alt elemanda "margin: auto" ayarlıyoruz.

Benzer bir şeyi "grid" düzeni ile yapabiliriz. "Display" değerini "grid" olarak ayarlayacağız. Ardından "justify-content: center" ve "align-items: center" diyeceğiz.

"Grid" ayrıca kısaltmalar da sunuyor. "Justify-content" ve "align-items" değerlerini "place-items: center" ile değiştirebiliriz.

Yine, hangisinin ortalanacağını belirlemek istiyorsak, bu özellikleri alt elemana taşıyabiliriz. Veya "place-self" kısaltmasını kullanabiliriz. Veya sadece alt elemanda "margin: auto" ayarlayabiliriz.

Umarım bu yardımcı olmuştur. Bu videoya beğeni atın ve benzer içerikler için abone olun.
