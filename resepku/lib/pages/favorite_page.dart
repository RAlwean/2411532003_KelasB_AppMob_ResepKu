import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'package:resepku/providers/favorite_provider.dart'; 
  
class FavoritePage extends StatelessWidget { 
  const FavoritePage({super.key}); 
  
  // Method untuk memunculkan dialog konfirmasi hapus semua
  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Semua Favorit'),
        content: const Text('Yakin ingin menghapus semua resep favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Memanggil fungsi clear() dari FavoriteProvider
              context.read<FavoriteProvider>().clear();
              Navigator.pop(ctx);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override 
  Widget build(BuildContext context) { 
    // Membaca jumlah favorit untuk mengontrol status aktif tombol "Hapus semua"
    final favoriteCount = context.watch<FavoriteProvider>().count;

    return Scaffold( 
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Hapus semua',
            // Jika kosong (count == 0), onPressed diset null agar tombol nonaktif
            onPressed: favoriteCount == 0 ? null : () => _confirmClear(context),
          ),
        ],
      ), 
      body: Consumer<FavoriteProvider>( 
        builder: (context, favorite, child) { 
          if (favorite.count == 0) { 
            return const Center( 
              child: Text( 
                'Belum ada resep favorit.\nTekan ikon hati di daftar resep.', 
                textAlign: TextAlign.center, 
              ), 
            ); 
          } 
          return ListView( 
            children: [ 
              for (final recipe in favorite.items) 
                ListTile( 
                  title: Text(recipe.name), 
                  subtitle: Text(recipe.cuisine), 
                  trailing: IconButton( 
                    icon: const Icon(Icons.delete_outline), 
                    onPressed: () => favorite.toggle(recipe), 
                  ), 
                ), 
            ], 
          ); 
        }, 
      ), 
    ); 
  } 
}