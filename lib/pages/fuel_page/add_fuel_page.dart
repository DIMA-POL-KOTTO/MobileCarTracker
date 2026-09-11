import 'package:flutter/material.dart';

class AddFuelPage extends StatelessWidget {
  const AddFuelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Добавить заправку'),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 90,
                child: ElevatedButton(
                  onPressed: () {
                    // Потом откроем камеру
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt, size: 32, color: Colors.blue),
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Сфотографировать чек',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue
                          ),
                          ),
                          SizedBox(height: 4),
                          Text("Данные будут распознаны автоматически",
                            style: TextStyle(fontSize: 13, color: Colors.blue
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            SizedBox(
              width: double.infinity,
              height: 90,
              child: ElevatedButton(
                onPressed: () {}, 
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(16),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit, size: 32, color: Colors.blue),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ввести вручную',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue
                        ),
                        ),
                        SizedBox(height: 4),
                        Text("Самостоятельно указать данные заправки", 
                          style: TextStyle(fontSize: 13, color: Colors.blue
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}