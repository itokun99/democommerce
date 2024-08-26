import 'package:ecommerce/core/configs/api.dart';
import 'package:ecommerce/core/services/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final products = useState<List<dynamic>>([]);
    final isLoading = useState(true);
    final errorMessage = useState<String?>(null);

    final dashboardService = DashboardService();

    void fetchProducts() async {
      try {
        final fetchedProducts = await dashboardService.getProducts();
        products.value =
            fetchedProducts.take(10).toList(); // Membatasi 10 produk pertama
      } catch (error) {
        errorMessage.value = error.toString();
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchProducts();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Home'),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : errorMessage.value != null
              ? Center(child: Text(errorMessage.value!))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dua kolom
                      crossAxisSpacing: 8.0, // Spasi antar kolom
                      mainAxisSpacing: 8.0, // Spasi antar baris
                      childAspectRatio: 2 / 3, // Rasio tinggi dan lebar
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final product = products.value[index];
                      final imageUrl =
                          '${ApiConfig.baseURL}/${product['image_name']}';
                      const defaultImage = 'https://via.placeholder.com/150';

                      return GridTile(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    defaultImage,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              product['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '\$${product['price']}',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
