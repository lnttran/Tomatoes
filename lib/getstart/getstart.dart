import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tomatoes/login_sinup/auth.dart';

class getStart extends StatelessWidget {
  const getStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/startBG.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                children: [
                  Text(
                    'Let\'s cook \ntogether!',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 80),
                  )
                ],
              ),
            ),
            const SizedBox(height: 300),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const auth();
                    },
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: 170,
                height: 60,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF83015),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 3), // Offset in x and y direction
                    ),
                  ],
                ),
                child: Text(
                  'Get Start',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
